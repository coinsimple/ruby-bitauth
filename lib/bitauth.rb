require "openssl"

class BitAuth
  VERSION = "0.0.1"

  attr_accessor :sin, :public_key, :private_key

  def initialize(opts = {})
    if opts[:private_key]
      self.private_key = opts[:private_key]
      self.public_key = pubkey_from_privkey private_key
      self.sin = generate_sin public_key
    elsif opts[:public_key]
      self.public_key = opts[:public_key]
      self.sin = generate_sin public_key
    else
      generate_keys
    end
  end

  def sign(data)
    fail(ArgumentError, 'Missing Private Key') if public_key.nil?

    hash = OpenSSL::Digest::SHA256.new.hexdigest data

    ecdsa = OpenSSL::PKey::EC.new('secp256k1')
    ecdsa.private_key = OpenSSL::BN.new private_key, 16

    ecdsa.dsa_sign_asn1(hash).unpack('H*')[0]
  end

  def verify(data, sig)
    hash = OpenSSL::Digest::SHA256.new.hexdigest data

    ecdsa = OpenSSL::PKey::EC.new('secp256k1')
    pub = OpenSSL::PKey::EC::Point.new(ecdsa.group, OpenSSL::BN.new(public_key, 16))

    ecdsa.public_key = pub
    ecdsa.dsa_verify_asn1(hash, [sig].pack('H*'))
  rescue
    false
  end

  private

  def base58(num)
    letters = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
    res = ''
    while num > 0
      num, r = num.divmod(58)
      res.prepend letters[r]
    end
    res
  end

  def generate_sin(pubkey)
    sha = OpenSSL::Digest::SHA256.new
    ripe = OpenSSL::Digest::RIPEMD160.new

    hash = '0f02' + ripe.hexdigest(sha.digest([pubkey].pack('H*')))
    checksum = sha.hexdigest(sha.digest([hash].pack('H*')))[0...8]

    key = hash + checksum
    base58 key.hex
  end

  def pubkey_from_privkey(privkey)
    ecdsa = OpenSSL::PKey::EC.new('secp256k1')
    priv = OpenSSL::BN.new(privkey, 16)

    pub = ecdsa.group.generator.mul([priv], []).to_bn.to_i.to_s(16).rjust(130, '0')

    x = [pub].pack('H*')[1..32].unpack('H*').first
    y = [pub].pack('H*')[33..64].unpack('H*').first.to_i(16)

    if y.odd?
      '03' + x
    else
      '02' + x
    end
  end

  def generate_keys
    ecdsa = OpenSSL::PKey::EC.new('secp256k1')
    keys = ecdsa.generate_key

    self.private_key = keys.private_key.to_s.to_i.to_s(16)
    self.public_key = pubkey_from_privkey private_key
    self.sin = generate_sin public_key
  end
end

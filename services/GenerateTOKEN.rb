require "openssl"

def token(name, password)
  OpenSSL::HMAC.hexdigest('SHA256', ENV["NAME_HASH_ID"], name + password)
end
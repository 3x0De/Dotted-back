require "openssl"

def token(name, password)
  OpenSSL::HMAC.hexdigest('SHA256', ENV["HASH_ID"], name + password)
end
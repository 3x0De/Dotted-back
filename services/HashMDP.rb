require "openssl"

def hash_mdp(donnee)
  OpenSSL::HMAC.hexdigest('SHA256', ENV["HASH_PASSWORLD"], donnee.to_s)
end
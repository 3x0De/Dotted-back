require "openssl"
require "securerandom"

def hash_img(image)
    ext = File.extname(image)
    basename = File.basename(image, ext)
    OpenSSL::HMAC.hexdigest('SHA256', ENV["HASH_IMAGE"], "#{basename}-#{SecureRandom.uuid}") + ext
end
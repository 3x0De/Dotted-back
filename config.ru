require 'rack/cors'

use Rack::Cors do
  allow do
    origins 'http://localhost:5173'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options],
      credentials: true
  end
end

require_relative 'app'

map '/Image' do
  run Image
end
map '/Page' do
  run Page
end
map '/User' do
  run Utilisateur
end
map '/' do
  run Application
end
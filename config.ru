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
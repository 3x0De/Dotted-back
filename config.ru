require_relative 'app'

map '/Page' do
  run Page
end

map '/User' do
  run Utilisateur
end

map '/' do
  run Application
end
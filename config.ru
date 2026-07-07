require_relative 'app'

map '/User' do
  run Utilisateur
end

map '/' do
  run Application
end
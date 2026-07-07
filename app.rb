require "sinatra/base"
require "hashids"
require_relative "db/db"
require_relative "models/Users"
require_relative "routes/User.rb"


class Application < Sinatra::Base
  set :bind, '0.0.0.0'
  set :port, 4567

  use Utilisateur,  map: '/User'

  get "/" do

    "Hello  World!"
  end

  run! if app_file == $0

end

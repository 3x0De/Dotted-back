require "sinatra"
require_relative "db/db"

set :bind, '0.0.0.0'
set :port, 4567

get "/" do
  "Hello  World!"
end

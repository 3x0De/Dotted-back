require "sinatra/base"
require "hashids"
require_relative "routes/User"
require_relative "routes/Page"
require_relative "routes/Image"


class Application < Sinatra::Base


  get "/" do
    "Hello  World!"
  end

  not_found do
    content_type :json

    status 404
    { error: "Ressource introuvable", message: "Baby, je lève mon verre et je danse tout seul dans l'appart. Tu reviendras hanter mes rêves, t'es une erreur 404" }.to_json
  end


end

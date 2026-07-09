require 'sinatra'
require 'json'
require_relative '../services/HashIMAGE'

class Image < Sinatra::Base

    # /

    put '/' do
        content_type :json

        if params[:image] && params[:image][:tempfile]
            tempfile      = params[:image][:tempfile]
            name          = params[:image][:filename]

            name = hash_img name

            path = File.join('Image', name)

            File.open(path, 'wb') do |f|
                f.write(tempfile.read)
            end

            path_name = "/Image/#{name}"

            status 200
            { message: "L'image est enregistré avec succès ! Voici le lien", data: path_name }.to_json
        else
            status 400
            { message: "Erreur : Aucun fichier détecté" }.to_json
        end
    end

end
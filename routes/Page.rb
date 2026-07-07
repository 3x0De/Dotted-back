require "hashids"
require 'sinatra'
require 'json'
require_relative "../services/HashURL"
require_relative "../models/Pages"

class Page < Sinatra::Base

    # /

    post "/" do
        content_type :json

        request_body = request.body.read

        if request_body.strip.empty?
            status 400
            return { message: "Erreur : Le corps de la requête (JSON) est vide !" }.to_json
        end

        begin
            payload = JSON.parse(request_body)
        rescue JSON::ParserError
            status 400
            return { message: "Erreur : Le format JSON envoyé est invalide !" }.to_json
        end

        token = payload["token"]

        gestion = PagesList.new token

        gestion.liste_path.to_json
    end
end
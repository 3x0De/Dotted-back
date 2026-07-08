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

        token  = payload["token"]
        racine = payload["racine"]
        prive  = payload["prive"]

        gestion = PagesList.new token


        unless prive
            if racine
                gestion.liste_path_racine_public.to_json
            else gestion.liste_path_public.to_json
            end
        else
            if racine
                gestion.liste_path_racine_prive.to_json
            else gestion.liste_path.to_json
            end
        end
    end

    put "/" do
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

        token      = payload["token"]
        visibilite = payload["visibilite"]
        parent     = payload["parent"]

        parent = parent ? unhash_url(parent) : nil

        gestion = PagesList.new token

        requete = gestion.add!(visibilite, parent)

        if requete
            status 201
            { message: "page créé avec succès !", data: hash_url(requete) }.to_json
        else
            status 401
            { message: "No bitches ?" }
        end
    end
end
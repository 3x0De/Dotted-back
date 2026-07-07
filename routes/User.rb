require 'sinatra'
require 'json'
require_relative '../models/Users'

class Utilisateur < Sinatra::Base

    get "/User" do
        content_type :json

        resp = UsersList.new
        resp.liste_path.to_json
    end

    put "/User" do
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

        username = payload["username"]
        email    = payload["email"]
        mdp      = payload["mdp"]
        ip       = [request.ip]

        return { message: "Nom d'utilisateur incorrect", data: payload }.to_json unless username&.match?(/\A\S+\z/)
        return { message: "Nom d'email incorrect", data: payload }.to_json unless email&.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)

        gestionnaire = UsersList.new
        gestionnaire.add!(username, mdp, email, ip)

        { message: "Utilisateur mis à jour avec succès !", data: payload }.to_json
    end

    delete "/User" do
        content_type :json

        request_body = request.body.read
        payload = JSON.parse(request_body)

        id = payload["id"]
        ip = request.ip

        gestionnaire = UsersList.new

        if gestionnaire.delete!(id, ip)
            { message: "Utilisateur supprimé avec succès !"}
        else
            { message: "Utilisateur non supprimé avec succès !"}
        end
    end

end
require 'sinatra'
require 'json'
require_relative '../models/Users'

class Utilisateur < Sinatra::Base

    # /User

    get "/User" do
        content_type :json

        resp = UsersList.new

        status 200
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

        unless username&.match?(/\A\S+\z/)
            status 400
            return { message: "Nom d'utilisateur incorrect", data: payload }.to_json
        end
        unless email&.match?(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
            status 400
            return { message: "Nom d'email incorrect", data: payload }.to_json
        end

        gestionnaire = UsersList.new
        requete = gestionnaire.add!(username, mdp, email)

        if requete
            status 201
            { message: "Utilisateur créé avec succès !", data:  requete }.to_json
        else 
            status 409
            { message: "Un autre utilisateur a le meme nom ou utilise la même email" }.to_json
        end
    end

    # /User/login

    post "/User/login" do
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
        mdp      = payload["mdp"]

        gestionnaire = UsersList.new
        valid = gestionnaire.user?(username, mdp)

        if valid
            status 200
            { message: "Identifiants corrects, voici le token", data: valid }.to_json
        else
            status 401
            { message: "Identifiants incorrects, t'a cru berner qui ?" }.to_json
        end
    end

end
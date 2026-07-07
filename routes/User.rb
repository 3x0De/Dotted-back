require 'sinatra'
require 'json'
require_relative '../models/Users'

class Utilisateur < Sinatra::Base

    # /

    get "/" do
        content_type :json

        resp = UsersList.new

        status 200
        resp.liste_path.to_json
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

        username = payload["username"]
        mdp      = payload["mdp"]

        unless username&.match?(/\A\S+\z/) || username == "login"
            status 400
            return { message: "Nom d'utilisateur déjà pris", data: payload }.to_json
        end

        gestionnaire = UsersList.new
        requete = gestionnaire.add!(username, mdp)

        if requete
            status 201
            { message: "Utilisateur créé avec succès !", data:  requete }.to_json
        else 
            status 409
            { message: "Un autre utilisateur a le meme nom" }.to_json
        end
    end

    # /login

    post "/login" do
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


    # /:name

    post "/:name" do

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

        username = params[:name]
        token    = payload["token"]
        type     = payload["type"]
        nouveau  = payload["nouveau"]

        user = User.new username, token


        if user.valide
            if type == "username"
                user.username = nouveau

                status 200
                return { message: "Le nom d'utilisateur a été mis a jour" }.to_json

            elsif type == "password"
                user.password = nouveau

                status 200
                return { message: "Le nom mot de passe a été mis a jour" }.to_json
            end
        else
            if user.nameValid?(username)
                status 401
                { message: "Je vais porter plainte pour usurpation d'identité là" }.to_json
            else
                status 400
                { message: "non." }.to_json
            end
        end

    end

    delete "/:name" do

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

        username = params[:name]
        token    = payload["token"]

        user = User.new username, token


        if user.valide
            user.delete!
            status 200
            { message: "Bye bye TT" }.to_json
        else
            if user.nameValid?(username)
                status 400
                { message: "Tu te prends pour qui a vouloir supprimer un compte qu'est pas à toi ?" }.to_json
            else
                status 400
                { message: "non." }.to_json
            end
        end

    end

end
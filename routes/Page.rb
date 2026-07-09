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

        token  = request.cookies['DottedClub']
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

        token      = request.cookies['DottedClub']
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
            { message: "No bitches ?" }.to_json
        end
    end

    # /:id

    get "/:id" do

        content_type :json

        id    = unhash_url params[:id]
        token = request.cookies['DottedClub']


        gestion = Pages.new token, id

        if gestion.valide
            status 200
            { title: gestion.Title, icon: gestion.Icon, banniere: gestion.Banniere, contenu: gestion.Contenu }.to_json
        else
            status 400
            { message: "Soit tu veux me berner, soit tu t'es trompé" }.to_json
        end
    end

    post "/:id" do
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


        id       = unhash_url params[:id]
        token    = request.cookies['DottedClub']
        type     = payload["type"]
        nouveau  = payload["nouveau"]

        page = Pages.new token, id

        if page.valide
            if type == "titre"
                page.Title = nouveau
                status 200
                {message: "Le titre est mis a jour avec suces"}.to_json
            elsif type == "icon"
                page.Icon = nouveau
                status 200
                {message: "L'iconne est mise a jour avec suces"}.to_json
            elsif type == "banniere"
                page.Banniere = nouveau
                status 200
                {message: "La banniere est mise a jour avec suces"}.to_json
            elsif type == "contenu"
                page.Contenu = nouveau
                status 200
                {message: "Le contenu est mis a jour avec suces"}.to_json
            end
        else {message:"oinoin"}.to_json
        end
    end

end
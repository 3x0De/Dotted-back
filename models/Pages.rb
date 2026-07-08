require_relative "../services/HashURL"
require_relative "DatabaseComunicator"

class Pages < DatabaseComunicator

    attr_reader :Title, :Icon, :Banniere, :Contenu, :Parent

    def initialize(id)
        super("pages")

        query = recup_val(false, "title, icon, banniere, contenu, parent", "id = ?", unhash_url(id))


        @Title    = query ? query[:title] : nil
        @Icon     = query ? query[:title] : nil
        @Banniere = query ? query[:title] : nil
        @Contenu  = query ? query[:title] : nil
        @Parent   = query ? query[:title] : nil
    end

end

class PagesList < DatabaseComunicator

    attr_reader :liste_path, :liste_path_public, :liste_path_racine_public, :liste_path_racine_prive

    def initialize(token)
        super("pages")

        @userId = DB.fetch("SELECT id FROM Users WHERE token = ?;", token).first

        @userId = @userId ? @userId[:id] : nil

        @liste = []
        @liste_public = []
        @liste_racine_public = []
        @liste_racine_prive = []


        @liste_path = []
        @liste_path_public = []
        @liste_path_racine_public = []
        @liste_path_racine_prive = []

        query = "SELECT P.id FROM Pages P JOIN LinkinPark L ON L.pageId = P.id WHERE L.userid = ? AND L.Visibilite;"

        requete = DB.fetch(query, @userId).all

        requete.each do |el|
            @liste_public.push hash_url el[:id]
        end

        @liste_public.each do |el|
            @liste_path_public.push "/Page/#{el}"
        end


        query = "SELECT P.id FROM Pages P JOIN LinkinPark L ON L.pageId = P.id WHERE L.userid = ?;"

        requete = DB.fetch(query, @userId).all

        requete.each do |el|
            @liste.push hash_url el[:id]
        end

        @liste.each do |el|
            @liste_path.push "/Page/#{el}"
        end

        query = "SELECT P.id FROM Pages P JOIN LinkinPark L ON L.pageId = P.id JOIN Users U ON U.id = L.userId WHERE U.id = ? AND L.Visibilite AND P.Parent IS NULL;"

        requete = DB.fetch(query, @userId).all

        requete.each do |el|
            @liste_racine_public.push hash_url el[:id]
        end

        @liste_racine_public.each do |el|
            @liste_path_racine_public.push "/Page/#{el}"
        end

        query = "SELECT P.id FROM Pages P JOIN LinkinPark L ON L.pageId = P.id JOIN Users U ON U.id = L.userId WHERE U.id = ? AND NOT L.Visibilite AND P.Parent IS NULL;"

        requete = DB.fetch(query, @userId).all

        requete.each do |el|
            @liste_racine_prive.push hash_url el[:id]
        end

        @liste_racine_prive.each do |el|
            @liste_path_racine_prive.push "/Page/#{el}"
        end

    end

    def add!(visibilite = true, parent = nil)
        return false if @userId.nil?

        add_val!({contenu: '{"id": 0, "type": "STATE.col", "content": [{"id": 1, "type": null, "content": "1"}]}', parent: parent })

        id = recup_val(false, "max(id) as max")[:max]

        DB[:linkinpark].insert(userid: @userId, pageid: id, visibilite: visibilite ? visibilite : true)

        id
    end


end
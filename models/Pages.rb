require_relative "../services/HashURL"
require_relative "DatabaseComunicator"
require_relative "Categories"

class Pages < DatabaseComunicator

    attr_reader :valide, :Title, :Icon, :Banniere, :Contenu, :Parent, :Categories

    def initialize(token, id)
        super("pages")

        @token = token

        @userId = DB.fetch("SELECT id FROM Users JOIN LinkinPark ON id = userId WHERE token = ? AND pageId = ?;", token, id).first

        @userId = @userId ? @userId[:id] : nil

        @valide = !@userId.nil?

        if @valide
            query = recup_val(false, "title, icon, banniere, contenu, parent", "id = ?", id)


            @Title      = query ? query[:title] : nil
            @Icon       = query ? query[:icon] : nil
            @Banniere   = query ? query[:banniere] : nil
            @Contenu    = query ? query[:contenu] : nil
            @Parent     = query ? query[:parent] : nil
            @id         = id

            @cat = CategoriesList.new @id
            @Categories = @cat.liste
        end
    end

    def Title=(val)
        if @valide
            if change_val!("title", "id = ?", val, @id)
                @Title = val
            end
        end
    end

    def Icon=(val)
        if @valide
            if change_val!("icon", "id = ?", val, @id)
                @Icon = val
            end
        end
    end

    def Banniere=(val)
        if @valide
            if change_val!("banniere", "id = ?", val, @id)
                @Banniere = val
            end
        end
    end

    def Contenu=(val)
        if @valide
            if change_val!("contenu", "id = ?", val.to_json, @id)
                @Contenu = val
            end
        end
    end

    def delete!()
        if @valide && @id != 1
            delete_val!({id: @id})
        end
    end

    def path()
        if @Parent.nil?
            return [{ name: @Title, path: hash_url(@id) }]
        end

        parent_page = Pages.new(@token, @Parent)

        parent_page.path << { name: @Title, path: hash_url(@id) }
    end

    def addCate! (nom, type, value)
        @cat.add!(nom, type, value)
    end

    def changeCate! (type, nouveau, paramId)

        if type == "nom"
            @cat.nom(nouveau, paramId)
        elsif type == "type"
            @cat.type(nouveau, paramId)
        elsif type == "value"
            @cat.val(nouveau, paramId)
        end

    end

    def delCate! (paramId)

        @cat.del!(paramId)

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

        add_val!({contenu: '{"id": 0, "type": "column", "content": [{"id": 1, "type": null, "content": ""}]}', parent: parent })

        id = recup_val(false, "max(id) as max")[:max]

        DB[:linkinpark].insert(userid: @userId, pageid: id, visibilite: visibilite)

        id
    end


end
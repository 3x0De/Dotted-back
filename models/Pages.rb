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

    attr_reader :liste, :liste_path

    def initialize(token)
        super("pages")

        @liste = []
        @liste_path = []

        query = "SELECT P.id FROM Pages P JOIN LinkinPark L ON L.pageId = P.id JOIN Users U ON U.id = L.userId WHERE U.token = ?;"

        requete = DB.fetch(query, token).all

        requete.each do |el|
            @liste.push hash_url el[:id]
        end

        @liste.each do |el|
            @liste_path.push "/Page/#{el}"
        end

    end

end
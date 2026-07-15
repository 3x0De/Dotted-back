require_relative "DatabaseComunicator"

class CategoriesList < DatabaseComunicator

    attr_reader :liste

    def initialize (idPage)
        super("categories")

        @idPage = idPage

        resultat = recup_val(true, "nom, type, value", "PageId = ?", @idPage)

        @liste = resultat

    end

end
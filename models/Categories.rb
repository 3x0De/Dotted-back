require_relative "DatabaseComunicator"

class CategoriesList < DatabaseComunicator

    attr_reader :liste

    def initialize (idPage)
        super("categories")

        @idPage = idPage

        resultat = recup_val(true, "id", "PageId = ?", @idPage)

        @liste = []

        resultat.each do |el|
            @liste.push el[:id]
        end

    end

    def add! (nom, type, value)
        resultat = add_val!({nom: nom, type: type, value: value, pageid: @idPage})
    end

    def nom(val, paramId)
        change_val!("nom", "id = ?", val, paramId)
    end

    def type(val, paramId)
        change_val!("type", "id = ?", val, paramId)
    end

    def val(val, paramId)
        change_val!("value", "id = ?", val, paramId)
    end

    def del!(paramId)
        delete_val!({id: paramId})
    end

end
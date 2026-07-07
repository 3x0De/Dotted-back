require_relative "../db/db"

class DatabaseComunicator
  def initialize(table)
    table_sym = table.to_sym

    if DB.tables.include?(table_sym)
      @table = table_sym
    else
      @table = nil
      puts "/!\\ La table '#{table}' n'existe pas."
    end
  end

  protected

  def recup_val(multiple = false, attribut = "*", condition = nil, *args)
    return nil if @table.nil?


    attributs_vises = attribut.split(",").map(&:strip)

    unless valid_arg?(attributs_vises)
      puts "/!\\ Attribut(s) '#{attribut}' invalide(s) pour la table '#{@table}'."
      return nil
    end

    if condition != nil
      query = "SELECT #{attribut} FROM #{@table} WHERE #{condition};"
    else
      query = "SELECT #{attribut} FROM #{@table};"
    end


    if multiple
        return DB.fetch(query, *args).all
    else return DB.fetch(query, *args).first
    end
  end


  def delete_val!(condition)

    DB[@table].where(condition).delete

  end

  def add_val!(args = {})
    return false if args.empty?

    schema = DB.schema(@table).to_h

    args.each do |cle, valeur|
      colonne_sym = cle.to_sym
      next unless schema[colonne_sym]

      db_type = schema[colonne_sym][:db_type].to_s

      if db_type.include?("[]")
        elements = valeur.is_a?(Array) ? valeur : [valeur.to_s]

        type_base = db_type.sub("[]", "")

        args[cle] = Sequel.lit("'{#{elements.join(',')}}'::#{type_base}[]")
      end
    end

    begin
      DB[@table].insert(args)
    rescue Sequel::DatabaseError => e
      puts "/!\\ Erreur d'insertion dans la table #{@table} : #{e.message}"
      raise e
    end
  end

  private

  def valid_arg?(args_list)
    return true if args_list == ["*"]

    colonnes_valides = DB[@table].columns

    args_list.all? do |nom_attribut|
      next true if nom_attribut.include?("(")
      colonnes_valides.include?(nom_attribut.to_sym)
    end
  end
end
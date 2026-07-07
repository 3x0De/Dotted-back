require_relative "DatabaseComunicator"
require_relative "../services/HashMDP"
require_relative "../services/GenerateTOKEN"

class User < DatabaseComunicator
  attr_reader :username, :valide

  def initialize(name, token)
    super("users")


    resultat = recup_val(false, "count(*) AS valide", "token = ? AND username = ?", token, name)
    @valide = resultat && resultat[:valide].to_i == 1

    if @valide
      data = recup_val(false,"password", "username = ?", @username)
      @username = name
      @mdp = data ? data[:password] : nil
    end
  end

  def username=(new_val)
    return unless @valide

    nouveau_token = token(new_val, @username)

    if change_val!(["username", "token"], "username = ?", new_val, nouveau_token, @username)
      @username = new_val
    end
  end

  def password=(new_val)
    return unless @valide

    nouveau_mdp_hash = hash_mdp(new_val)
    nouveau_token = token(@username, nouveau_mdp_hash)

    if change_val!(["password", "token"], "username = ?", nouveau_mdp_hash, nouveau_token, @username)
      @mdp = nouveau_mdp_hash
    end
  end

end


class UsersList < DatabaseComunicator

  attr_reader :liste, :liste_path

  def initialize()
    super("users")


    @liste = []

    liste = recup_val(true,"username")

    liste.each do |el|
      @liste.push el[:username]
    end

    @liste_path = []

    @liste.each do |el|
      @liste_path.push "/User/#{el}"
    end
  end

  def add!(username, mdp)
    if recup_val(false, "count(*) as exist", "username = ?", username)[:exist] == 0
       add_val!(username:username, password: hash_mdp(mdp), token: token(username, hash_mdp(mdp)))
      return token(username, hash_mdp(mdp))
    else return false
    end
  end

  def user?(username, mdp)
    requete = recup_val(false,"token", "username = ? AND password = ?", username, hash_mdp(mdp))

    requete ? requete[:token] : false
  end

end

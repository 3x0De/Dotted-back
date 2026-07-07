require_relative "DatabaseComunicator"
require_relative "../services/HashMDP"
require_relative "../services/GenerateTOKEN"

class User < DatabaseComunicator
  attr_accessor :id, :username, :email, :password, :ip

  def initialize(name, token)
    super("users")
    @username = name

    requete = recup_val(false,"email, password", "username = ?", @username)

    @email    = requete ? requete[:email] : nil
    @password = requete ? requete[:password] : nil
    @ip       = requete ? requete[:ip].tr('{}', '').split(',') : []
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

  def add!(username, mdp, email)
    if recup_val(false, "count(*) as exist", "username = ? OR email = ?", username, email)[:exist] == 0
       add_val!(username:username, password: hash_mdp(mdp), email:email, token: token(username, hash_mdp(mdp)))
      return token(username, hash_mdp(mdp))
    else return false
    end
  end

  def user?(username, mdp)
    requete = recup_val(false,"token", "username = ? AND password = ?", username, hash_mdp(mdp))

    requete ? token(username, hash_mdp(mdp)) : false
  end

end

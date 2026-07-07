require_relative "DatabaseComunicator"
require_relative "../services/HashMDP"

class User < DatabaseComunicator
  attr_accessor :id, :username, :email, :password, :ip

  def initialize(id)
    super("users")
    @id = id

    requete = recup_val(false,"username, email", "id = ?", id)

    @username = requete ? requete[:username] : nil
    @email    = requete ? requete[:email] : nil
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

  def add!(username, mdp, email, ip)
    add_val!({username:username, password: hash_mdp(mdp), email:email, ip:ip})
  end

end

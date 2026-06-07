from Script.Dot import *

def Connection (username, mdp):
    return GetMdp(username) == hash(mdp)

def Session(Ip):
    for user in GetIpIdAllList():
        if type(user[0]) == list and ipaddress.IPv4Address(Ip) in user[0]:
            return user[1]


def afficherProjetsRacine(Ip):
    return Get("SELECT P.Id, Nom FROM Pages P JOIN LinkinPark L ON P.Id = L.PageId JOIN Utilisateurs U ON U.Id = L.UserId WHERE Visibilite AND U.Id = %s AND P.Parent IS NULL ORDER BY P.id ASC;", (Ip,))

def getContent(IDPAGE):
    return Get("SELECT * FROM CATEGORIES C RIGHT JOIN PAGES P ON C.PageId = P.Id WHERE P.ID = %s;",(IDPAGE,))



def initProjets(Client):
    AddPage(None, "", "", "", [{"id": "b1", "type": "", "content": ""},
    {"id": "b2", "type": "", "content": ""}])
    AddLinkinPark(Client, Get("SELECT MAX(Id) FROM Pages;")[0][0], True)
    
def supprimerProjet(proj):
    Exec("DELETE FROM LinkinPark WHERE PageId = %s;",(proj,))
    Exec("DELETE FROM Pages WHERE Id = %s;",(proj,))
    
def afficherProjetsPriveRacine(Ip):
    return Get("SELECT P.Id, Nom FROM Pages P JOIN LinkinPark L ON P.Id = L.PageId JOIN Utilisateurs U ON U.Id = L.UserId WHERE NOT Visibilite AND U.Id = %s AND P.Parent IS NULL ORDER BY P.id ASC;", (Ip,))



def getContenu(Ip):
    return Get("SELECT Contenu FROM Pages WHERE Id = %s;", (Ip,))[0][0]


def get_Icon_Page(Id):
    return Get("SELECT Icon FROM Pages WHERE Id = %s", (Id,))[0][0]

def get_Ban_Page(Id):
    return Get("SELECT Banniere FROM Pages WHERE Id = %s", (Id,))[0][0]

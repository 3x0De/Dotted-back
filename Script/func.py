from Script.Dot import *

def Connection (username, mdp):
    return GetMdp(username) == hash(mdp)

def Session(Ip):
    for user in GetIpIdAllList():
        print(user)
        if type(user[0]) == list and ipaddress.IPv4Address(Ip) in user[0]:
            return user[1]


def afficherProjetrsRacine(Ip):
    return Get("SELECT P.Id, Nom FROM Pages P JOIN LinkinPark L ON P.Id = L.PageId JOIN Utilisateurs U ON U.Id = L.UserId WHERE Visibilite AND U.Id = %s AND P.Parent IS NULL", (Ip,))

def getContent(IDPAGE):
    return Get("SELECT * FROM CATEGORIES C RIGHT JOIN PAGES P ON C.PageId = P.Id WHERE P.ID = %s",(IDPAGE,))




from db.Connection import *
import json
import ipaddress
try:
    from Script.EncryptPv import hash
except:
    from Script.EncryptPub import hash



def AddUser(username, password, ip):
    if (Get("SELECT Username FROM Utilisateurs;")!= [] or username in [Nom[0][0] for Nom in Get("SELECT Username FROM Utilisateurs;")]):
        return False
    Exec("INSERT INTO Utilisateurs VALUES ((SELECT COALESCE(Max(Id), 0) FROM Utilisateurs) + 1, %s, %s, %s);", (username, hash(password), [ip]))
    return True



def AddPage(parent, nom, banniere, icon, contenu):
    Exec("INSERT INTO Pages VALUES ((SELECT COALESCE(Max(Id), 0) FROM Pages) + 1, %s, %s, %s, %s, %s);", (parent, nom, banniere, icon, json.dumps(contenu)))



def AddLinkinPark(UserId, PageId, Visibilite):
    Exec("INSERT INTO LinkinPark VALUES (%s, %s, %s);", (UserId, PageId, Visibilite))


def AddCategories(PageId, Icon, Nom, Val):
    Exec("INSERT INTO Categories VALUES ((SELECT COALESCE(Max(Id), 0) FROM Categories) + 1, %s, %s, %s, %s);", (PageId, Icon, Nom, Val))




def GetMdp(Nom):
    return Get("SELECT Password FROM Utilisateurs WHERE Username = %s", (Nom,))[0][0]

def GetIpList(Nom):
    return Get("SELECT IP FROM Utilisateurs WHERE Username = %s", (Nom,))[0][0]

def GetIpIdAllList():
    return Get("SELECT IP, Id FROM Utilisateurs")

def AddIp(Nom, Ip):
    if GetIpList(Nom) is None:
        Exec("UPDATE Utilisateurs SET IP = %s WHERE Username = %s", ([Ip], Nom))
    else:
        Exec("UPDATE Utilisateurs SET IP = %s WHERE Username = %s", (GetIpList(Nom) + [Ip], Nom))

def GetNom(Id):
    return Get("SELECT Username FROM Utilisateurs WHERE Id = %s", (Id,))[0][0]

def SupprIp(Nom, Ip):
    Exec("UPDATE Utilisateurs SET IP = %s WHERE Username = %s", (GetIpList(Nom).remove(ipaddress.IPv4Address(Ip)), Nom))
    
def GetRelativePath(Id):
    nom, id = Get("SELECT Nom, id FROM Pages WHERE Id = %s", (Id,))[0]
    if Get("SELECT Parent FROM Pages WHERE Id = %s", (Id,))[0][0] is None:
        return [{"nom" : nom, "path": id}]
    else: return [{"nom" : nom, "path": id}] + GetRelativePath(Get("SELECT Parent FROM Pages WHERE Id = %s", (Id,))[0][0])
    
# def UpdateContenu(IDPAGE, Contenu):
#     Exec("UPDATE Pages SET Nom = %s, Banniere = %s, Icon = %s, Contenu = %s WHERE Id=%s", (Contenu.nom, Contenu.banniere, Contenu.icon, Contenu.cont, IDPAGE))
    
def UpdateCategorie(Categorie):
    Exec("UPDATE Categories SET Icon = %s, Nom = %s, val = %s WHERE Id = %s", (Categorie.icon, Categorie.nom, Categorie.val, Categorie.id))


def UpdateNom(id, nom):
    Exec("UPDATE Pages SET Nom = %s WHERE Id=%s", (nom, id))


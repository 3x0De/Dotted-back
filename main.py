from fastapi import FastAPI, Request
from fastapi.responses import RedirectResponse
from Script.func import *

app = FastAPI()  


# @app.get("/")
# def read_root():
#     AddUser("ACAB", "Shaya", ["0.0.0.0"])
#     # AddPage(None, "Shaya", "Caca", "ACAB", ["0.0.0.0"])
#     # AddLinkinPark(1,1,False)
#     # AddCategories(1,"Shaya", "Caca", "ACAB")
    
#     return {"ACAB MDP Shaya" : Connection("ACAB", "Shaya"), "ACAB MDP Shatta" : Connection("ACAB", "Shatta")}

class User:
    def __init__(self, numero):
        pass

@app.get("/signUp")
def signUp(Nom: str, Mdp: str, request: Request):
    Ip = request.client.host
    if AddUser(Nom, Mdp, Ip):
        return "Compte créé"
    else:
        return "Ce nom est déjà pris"
    
@app.get("/logIn")
def login(Nom: str, Mdp: str, request: Request):
    Ip = request.client.host
    if Connection(Nom, Mdp):
        if GetIpList(Nom) is None or Ip not in GetIpList(Nom):
            AddIp(Nom, Ip)
        return "Connecté"
    else:
        return "Mauvais mot de passe"
    
@app.get("/logOut")
def login(request: Request):
    Client = Session(request.client.host)
    SupprIp(GetNom(Client), request.client.host)
    return "Déconnecté"

@app.get("/")
async def get_ip(request: Request):
    Client = Session(request.client.host)
    if len(Get("SELECT Username FROM Utilisateurs WHERE Id = %s", (Client,))) == 0:
        return RedirectResponse(url="/signUp")
    Nom = GetNom(Client)

    return f"Bonjour {Nom}"
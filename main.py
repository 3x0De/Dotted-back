from fastapi import FastAPI, Request, Body
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse
from Script.func import *

app = FastAPI()  

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "http://127.0.0.1:5173",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# TODO: Implementer les logs dans le front

# @app.get("/signUp")
# def signUp(Nom: str, Mdp: str, request: Request):
#     Ip = request.client.host
#     if AddUser(Nom, Mdp, Ip):
#         return "Compte créé"
#     else:
#         return "Ce nom est déjà pris"
    
# @app.get("/logIn")
# def login(Nom: str, Mdp: str, request: Request):
#     Ip = request.client.host
#     if Connection(Nom, Mdp):
#         if GetIpList(Nom) is None or Ip not in GetIpList(Nom):
#             AddIp(Nom, Ip)
#         return "Connecté"
#     else:
#         return "Mauvais mot de passe"
    
# @app.get("/logOut")
# def logout(request: Request):
#     Client = Session(request.client.host)
#     SupprIp(GetNom(Client), request.client.host)
#     return "Déconnecté"

@app.get("/con")
def con(mdp: str, request: Request) -> bool:
    Client = Session(request.client.host)
    return Connection(GetNom(Client), mdp)

@app.get("/")
async def root(request: Request):
    Client = Session(request.client.host)
    if len(Get("SELECT Username FROM Utilisateurs WHERE Id = %s", (Client,))) == 0:
        return RedirectResponse(url="/signUp")
    Nom = GetNom(Client)

    return f"Bonjour {Nom}"


@app.get("/Racine")
def racine(request: Request):
    Client = Session(request.client.host)
    return afficherProjetsRacine(Client)

@app.get("/Racine/prive")
def racine(request: Request):
    Client = Session(request.client.host)
    return afficherProjetsPriveRacine(Client)

@app.post('/initProj')
def initProj(request: Request):
    Client = Session(request.client.host)
    initProjets(Client)
    return "Envoyé"

@app.post('/initProj/prive')
def initProj(request: Request):
    Client = Session(request.client.host)
    AddPage(None, "", "", "", [])
    AddLinkinPark(Client, Get("SELECT MAX(Id) FROM Pages;")[0][0], False)
    return "Envoyé"

@app.post('/supprProj')
def supprProj(proj:int= Body(..., embed=True)):
    supprimerProjet(proj)
    return "Supprimé"

@app.post('/Change/Nom')
def changeNom(page:dict=Body(...)):
    UpdateNom(page["id"], page["nom"])
    return "Le nom a été changé"




@app.get("/Path/{IDPAGE}")
def getPath(IDPAGE: int):
    return GetRelativePath(IDPAGE)


# TODO:  Implementer la suite
    
    
# @app.get("/Page/{IDPAGE}")
# def getPage(IDPAGE: int, send: bool = False, Contenu = None, Categorie=None):
#     if not send:
#         return getContent(IDPAGE)
#     else:
#         if Contenu is not None:
#             UpdateContenu(IDPAGE, Contenu)
#         if Categorie is not None:
#             UpdateCategorie(Categorie)
    
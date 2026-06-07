from fastapi import FastAPI, Request, Body
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse
from fastapi.responses import FileResponse
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


# ================================
#     __    ____  ___________   __
#    / /   / __ \/ ____/  _/ | / /
#   / /   / / / / / __ / //  |/ /
#  / /___/ /_/ / /_/ // // /|  /
# /_____/\____/\____/___/_/ |_/
#
# ================================

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





# =========================
#     _____   ____________
#    /  _/ | / /  _/_  __/
#    / //  |/ // /  / /
#  _/ // /|  // /  / /
# /___/_/ |_/___/ /_/
#
# =========================


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
    AddPage(None, "", "", "", [{"id": "b1", "type": "", "content": ""},
    {"id": "b2", "type": "", "content": ""}])
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


# =====================================================
#     ____  ____  ____      _________________________
#    / __ \/ __ \/ __ \    / / ____/ ____/_  __/ ___/
#   / /_/ / /_/ / / / /_  / / __/ / /     / /  \__ \
#  / ____/ _, _/ /_/ / /_/ / /___/ /___  / /  ___/ /
# /_/   /_/ |_|\____/\____/_____/\____/ /_/  /____/
#
# =====================================================


@app.get("/Path/{IDPAGE}")
def getPath(IDPAGE: int):
    return GetRelativePath(IDPAGE)

@app.get("/titre/{IDPAGE}")
def getTitre(IDPAGE: int):
    return Get("SELECT nom FROM Pages WHERE Id = %s", (IDPAGE,))[0][0]


@app.get("/Cont/{IDPAGE}")
def getCont(IDPAGE: int):
    return getContenu(IDPAGE)

@app.post("/Modif/Cont/{IDPAGE}")
def modifCont(IDPAGE: int, page: list = Body(..., embed=True)):
    Exec("UPDATE Pages SET Contenu = %s WHERE Id = %s;", (json.dumps(page), IDPAGE))
    return "Le contenu est bien changé"


# =========================================
#     ______  ______   _________________
#    /  _/  |/  /   | / ____/ ____/ ___/
#    / // /|_/ / /| |/ / __/ __/  \__ \
#  _/ // /  / / ___ / /_/ / /___ ___/ /
# /___/_/  /_/_/  |_\____/_____//____/
#
# =========================================


@app.get("/Icon/Page/{IDPAGE}")
def getIconPage(IDPAGE: int):
    path = get_Icon_Page(IDPAGE)
    if path is None:
        return FileResponse('Image/Icon/Dotted_mini.svg', media_type="image/svg+xml")
    else:
        return FileResponse(path, media_type="image/svg+xml+png+jpg")

@app.get("/Banniere/Page/{IDPAGE}")
def getIconPage(IDPAGE: int):
    path = get_Ban_Page(IDPAGE)
    if path is None:
        return FileResponse('Image/Banniere/Dotted_full.svg', media_type="image/svg+xml")
    else:
        return FileResponse(path, media_type="image/svg+xml+png+jpg")
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



from fastapi import FastAPI, Request, Body, HTTPException

@app.get("/signUp")
def signUp(Nom: str, Mdp: str, request: Request):
    Ip = request.client.host
    result = AddUser(Nom, Mdp, Ip)
    Client = Session(request.client.host)
    initProjets(Client)
    if not result:
        raise HTTPException(status_code=409, detail="Nom déjà pris")
    return result

@app.get("/logIn")
def login(Nom: str, Mdp: str, request: Request):
    Ip = request.client.host
    if Connection(Nom, Mdp):
        existing = [str(ip) for ip in (GetIpList(Nom) or [])]
        if Ip not in existing:
            AddIp(Nom, Ip)
        return True
    raise HTTPException(status_code=401, detail="Mauvais identifiants")

@app.post("/logOut")
def logout(request: Request):
    Client = Session(request.client.host)
    Nom = GetNom(Client)
    if Nom:
        SupprIp(Nom, request.client.host)
    return "Déconnecté"

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



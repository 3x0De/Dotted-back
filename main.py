from fastapi import FastAPI, Request, Body, HTTPException, UploadFile, File, Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse
from fastapi.responses import FileResponse
from Script.func import *
import shutil, os

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



# ================================
#     __    ____  ___________   __
#    / /   / __ \/ ____/  _/ | / /
#   / /   / / / / / __ / //  |/ /
#  / /___/ /_/ / /_/ // // /|  /
# /_____/\____/\____/___/_/ |_/
#
# ================================

@app.get("/signUp")
def signUp(Nom: str, Mdp: str, request: Request):
    Ip = request.client.host
    result = AddUser(Nom, Mdp, Ip)
    Client = Session(Ip)
    if not result:
        raise HTTPException(status_code=409, detail="Nom déjà pris")

    AddLinkinPark(Client, 1, True)
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


@app.get("/maxId")
def maxId():
    return Get("SELECT COALESCE(max(Id), 0) FROM Pages;")[0][0]

@app.get("/peuxCon/{IDPAGE}")
def peuxCon(IDPAGE : int,request: Request):
    Client = Session(request.client.host)
    if Get("SELECT EXISTS (SELECT 1 FROM LinkinPark WHERE UserId = %s AND PageId = %s);", (Client, IDPAGE))[0][0]:
        return True
    return False

@app.get("/")
async def root(request: Request):
    Client = Session(request.client.host)
    if len(Get("SELECT Username FROM Utilisateurs WHERE Id = %s;", (Client,))) == 0:
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
    AddPage(None, "", None, None, [{"id": "b1", "type": "", "content": ""},
    {"id": "b2", "type": "", "content": ""}])
    AddLinkinPark(Client, Get("SELECT MAX(Id) FROM Pages;")[0][0], False)
    return "Envoyé"

@app.post('/initProj/enfant')
def initEnfant(parent:int = Body(..., embed=True)):
    AddPage(parent, "",  None, "Image/Icon/Document/file-3-line.svg", [{"id": "b1", "type": "", "content": ""},
    {"id": "b2", "type": "", "content": ""}])
    id = Get("SELECT MAX(Id) FROM Pages;")[0][0]
    for enfant in Get("SELECT UserId FROM Linkinpark WHERE PageId = %s;", (parent,)):
        AddLinkinPark(enfant[0], id, True)
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
    return FileResponse(path, media_type="image/svg+xml", headers={"Cache-Control": "no-store, no-cache, must-revalidate"})

@app.get("/Banniere/Page/{IDPAGE}")
def getIconPage(IDPAGE: int):
    path = get_Ban_Page(IDPAGE)
    return FileResponse(path, media_type="image/svg+xml", headers={"Cache-Control": "no-store, no-cache, must-revalidate"})

@app.post("/Icon/change")
def changeIcon(props: dict = Body(...)):
    if props.get("Icon") is None:
        Exec("UPDATE Pages SET Icon = NULL WHERE Id = %s;", (props["Id"],))
    else:
        Exec("UPDATE Pages SET Icon = %s WHERE Id = %s;", ("Image/Icon/" + props["Icon"], props["Id"]))
    return {"ok": True}



@app.post("/Banniere/change")
async def changeBanniere(file: UploadFile = File(...), id: int = Form(...)):
    dest_dir = f"Image/Banniere"
    os.makedirs(dest_dir, exist_ok=True)

    ext = file.filename.split(".")[-1]
    dest_path = f"{dest_dir}/{id}.{ext}"

    with open(dest_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    Exec("UPDATE Pages SET Banniere = %s WHERE Id = %s;", (dest_path, id))

    return {"ok": True, "path": dest_path}


@app.post("/Banniere/del")
def supprBanniere(props: dict = Body(...)):
    Exec("UPDATE Pages SET Banniere = NULL WHERE Id = %s;", (props["id"],))

    return {"ok": True}
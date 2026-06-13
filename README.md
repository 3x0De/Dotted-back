# Dotted-back

Ce repo fait partis du projet [Dotted](https://github.com/3x0De/Dotted-docs/)

## BASES DE DONNEE

- <details>
      <summary>Utilisateurs</summary>
      <ul>
          <li>Id (int, clé primaire)</li>
          <li>Username (str, unique dans la table)</li>
          <li>Password (str)</li>
          <li>IP (Liste d'IP)</li>
      </ul>
  </details>

- <details>
      <summary>Pages</summary>
      <ul>
          <li>Id (int, clé primaire)</li>
          <li>Parent (int, clé étrangère de Pages(Id))</li>
          <li>Nom (str)</li>
          <li>Banniere (str)</li>
          <li>Icon (str)</li>
          <li>Contenu (Objet JSON)</li>
      </ul>
  </details>

- <details>
      <summary>LinkinPark</summary>
      <ul>
          <li>UserId (int, clé primaire avec PageId, clé etrangère de Utilisateurs(Id))</li>
          <li>PageId (int, clé primaire avec UserId,clé étrangère de Pages(Id))</li>
          <li>Visibilite (bool)</li>
      </ul>
  </details>

- <details>
      <summary>Categories</summary>
      <ul>
          <li>Id (int, clé primaire)</li>
          <li>PageId (int, clé étrangère de Pages(Id))</li>
          <li>Icon (str)</li>
          <li>Nom (str)</li>
          <li>Val (str)</li>
      </ul>
  </details>

## ENDPOINT

| Endpoint                      | Utilisation                                                    |
| ----------------------------- | -------------------------------------------------------------- |
| `GET /signUp`                 | Créé un compte utilisateur                                     |
| `GET /logIn`                  | Verifier si l'utilisateur connecté a entré le bon mot de passe |
| `POST /logOut`                | Déconnecte l'utilisateur                                       |
| `GET /con`                    | Verifier si l'utilisateur connecté a entré le bon mot de passe |
| `GET /maxId`                  | Renvoie le plus grand ID de toutes les pages                   |
| `GET /peuxCon/{IDPAGE}`       | Verifier si l'utilisateurpux voir IDPAGE                       |
| `GET /`                       | Récupère le nom d'utilisateur du connecté                      |
| `GET /Racine`                 | Affiche La liste des projets de l'utilisateur                  |
| `GET /Racine/prive`           | Affiche La liste des projets privés de l'utilisateur           |
| `POST /initProj`              | Initialise un projet                                           |
| `POST /initProj/enfant`       | Initialise un enfant avec le nom du parent                     |
| `POST /initProj/prive`        | Initialise un projet privé                                     |
| `POST /supprProj`             | Supprime une page                                              |
| `POST /Change/Nom`            | Change le titre d'une page                                     |
| `GET /Path/{IDPAGE}`          | Récupère le chemin pour acceder a une page                     |
| `GET /titre/{IDPAGE}`         | Récupère le titre d'une page                                   |
| `GET /Cont/{IDPAGE}`          | Récupère le contenu d'une page                                 |
| `POST /Modif/Cont/{IDPAGE}`   | Modifie le contenu d'une page                                  |
| `GET /Icon/Page/{IDPAGE}`     | Renvoie le contenu de l'iconne correspondante                  |
| `GET /Banniere/Page/{IDPAGE}` | Renvoie le contenu de la banniere correspondante               |
| `POST /Icon/change`           | Modifie le contenu de l'iconne                                 |
| `POST /Banniere/change`       | Change le contenu de la banniere correspondante                |
| `POST /Banniere/del`          | Supprime le contenu de la banniere correspondante              |
| `GET /Image/charge/{Name}`    | Renvoie l'image demandée                                       |
| `POST /Image/get`             | Enregistre l'image                                             |

## Note

- Le principe pour le login est de stocker l'ip de l'utilisateur lors d'une connection.
- Les pages peuvent être publiques ou privées
- Les relations utilisateurs/pages sont gérées via la table LinkinPark
- Les images sont stokés dans des fichiers séparés

## Installation

Tout est détailé [ici](https://github.com/3x0De/Dotted-docs/blob/main/INSTALLATION.md).

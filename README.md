# Dotted-back

Ce repo fait partie du projet [Dotted](https://github.com/3x0De/Dotted-docs/)

## BASES DE DONNEE

- <details>
      <summary>Users</summary>
      <ul>
          <li>Id (INT, clé primaire)</li>
          <li>Username (TEXT, unique dans la table)</li>
          <li>Password (TEXT)</li>
          <li>Token (TEXT)</li>
      </ul>
  </details>

- <details>
      <summary>Pages</summary>
      <ul>
          <li>Id (INT, clé primaire)</li>
          <li>Parent (INT, clé étrangère de Pages(Id))</li>
          <li>Title (TEXT)</li>
          <li>Banniere (TEXT)</li>
          <li>Icon (TEXT)</li>
          <li>Contenu (JSONB)</li>
      </ul>
  </details>

- <details>
      <summary>LinkinPark</summary>
      <ul>
          <li>UserId (INT, clé primaire avec PageId, clé etrangère de Users(Id))</li>
          <li>PageId (INT, clé primaire avec UserId,clé étrangère de Pages(Id))</li>
          <li>Visibilite (BOOLEAN)</li>
      </ul>
  </details>

- <details>
      <summary>Categories</summary>
      <ul>
          <li>Id (INT, clé primaire)</li>
          <li>PageId (INT, clé étrangère de Pages(Id))</li>
          <li>Icon (TEXT)</li>
          <li>Nom (TEXT)</li>
          <li>Type (TEXT)</li>
          <li>Value (TEXT)</li>
      </ul>
  </details>

## ENDPOINTS

| Routes             | Description           |
| ------------------ | --------------------- |
| [`/User`](#user)   | Gère les utilisateurs |
| [`/Page`](#page)   | Gère les pages        |
| [`/Image`](#image) | Gère les images       |

### `/User`

| Endpoint             | Parametres                | Utilité                                                                                        |
| -------------------- | ------------------------- | ---------------------------------------------------------------------------------------------- |
| `GET /User/`         |                           | Obtenir la liste de tout les utilisateurs                                                      |
| `PUT /User/`         | `username`,`mdp`          | Ajouter un utilisateur                                                                         |
| `POST /User/login`   | `username`,`mdp`          | Créer un cookie avec le token de l'utilisateur                                                 |
| `POST /User/logout`  |                           | Supprime le cookie avec le token de l'utilisateur                                              |
| `GET /User/bonjour`  |                           | Renvoie la chaîne Bonjour suivis du nom d'utilisateur assocé au token                          |
| `POST /User/:name`   | `:name`,`type`, `nouveau` | Change la valeur du `type` ("username" ou "password") par `nouveau` pour l'utilisateur `:name` |
| `DELETE /User/:name` | `:name`                   | Supprime l'utilisateur `:name`                                                                 |

### `/Page`

| Endpoint                            | Parametres                      | Utilité                                                                                                      |
| ----------------------------------- | ------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `POST /Page`                        | `racine`, `prive`               | Récupère les pages public (ou privé si `prive` = true ) et uniquement les pages racines si `racine` = true   |
| `PUT /Page`                         | `visibilite`,`parent`           | Créé une page de parent `parent`et de visibilité `visibilite`                                                |
| `GET /Page/:id`                     | `:id`                           | Obtenir les informations sur la page `:id`                                                                   |
| `POST /Page/:id`                    | `:id`,`type`, `nouveau`         | Change la valeur de `type`("titre", "icon", "banniere" ou "contenu") en `nouveau` pour la page `:id`         |
| `DELETE /Page/:id`                  | `:id`                           | Supprime la page `:id`                                                                                       |
| `GET /Page/:id/Path`                | `:id`                           | Remonte les parents de `:id` jusqu'à une racine                                                              |
| `GET /Page/:id/Categories`          | `:id`                           | Récupère les catégories de la page `:id`                                                                     |
| `PUT /Page/:id/Categories`          | `:id`, `value`,`nom`,`type`     | Ajoute la catégorie `nom`, de type `type` et de valeur `value` a la page `:id`                               |
| `GET /Page/:id/Categories/:cate`    | `:id`,`:cate`                   | Renvoie les données de la catégorie `:cate` de la page `:id`                                                 |
| `POST /Page/:id/Categories/:cate`   | `:id`,`:cate`,`type`, `nouveau` | Change la valeur de `type`("nom", "type" ou "value") en `nouveau` pour la catégorie `:cate` de la page `:id` |
| `DELETE /Page/:id/Categories/:cate` | `:id`,`:cate`                   | Supprime la catégorie `:cate` de la page `:id`                                                               |

### `/Image`

| Endpoint              | Parametres | Utilité                                                   |
| --------------------- | ---------- | --------------------------------------------------------- |
| `PUT /Image`          | `:image`   | Ajoute l'image `:image` et renvoie le lien pour y acceder |
| `GET /Image/:name`    | `:name`    | Récupère l'image `:name`                                  |
| `DELETE /Image/:name` | `:name`    | Supprime l'image `:name`                                  |

## Notes

- Le principe pour le login est de stocker un token de session lors d'une connection.
- Les pages peuvent être publiques ou privées.
- Les relations utilisateurs/pages sont gérées via la table LinkinPark.

## Documentation

- [Architecture globale](https://github.com/3x0De/Dotted-docs/blob/main/ARCHITECTURE.md)
- [Installation détaillée](https://github.com/3x0De/Dotted-docs/blob/main/INSTALLATION.md)
- [Changelog](./CHANGELOG.md)

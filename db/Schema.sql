CREATE TABLE Utilisateurs (
    Id INT PRIMARY KEY,
    Username TEXT UNIQUE,
    Password TEXT,
    IP INET[]
);

CREATE TABLE Pages (
    Id INT PRIMARY KEY,
    Parent INT,
    Nom TEXT,
    Banniere TEXT,
    Icon TEXT,
    Contenu JSONB,

    FOREIGN KEY (Parent) REFERENCES Pages(Id)
);

CREATE TABLE LinkinPark (
    UserId INT,
    PageId INT,
    Visibilite BOOLEAN,

    PRIMARY KEY (UserId, PageId),
    FOREIGN KEY (UserId) REFERENCES Utilisateurs(Id),
    FOREIGN KEY (PageId) REFERENCES Pages(Id)
);

CREATE TABLE Categories (
    Id INT PRIMARY KEY,
    PageId INT,
    Icon TEXT,
    Nom TEXT,
    Val TEXT,

    FOREIGN KEY (PageId) REFERENCES Pages(Id)
);

INSERT INTO Pages VALUES (1, NULL, NULL, NULL, NULL, '[{"id": "b1", "type": "", "content": ""}, {"id": "b2", "type": "", "content": ""}]');
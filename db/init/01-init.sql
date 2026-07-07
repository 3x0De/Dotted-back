CREATE EXTENSION IF NOT EXISTS citext;

DROP TABLE IF EXISTS Users, Pages, LinkinPark, Categories;

CREATE TABLE Users (
    Id SERIAL PRIMARY KEY,
    Username TEXT UNIQUE NOT NULL,
    Password TEXT,
    Email CITEXT UNIQUE,
    Token TEXT
);

CREATE TABLE Pages (
    Id SERIAL PRIMARY KEY,
    Parent INT,
    Title TEXT,
    Icon TEXT,
    Banniere TEXT,
    Contenu JSONB,

    FOREIGN KEY (Parent) REFERENCES Pages(Id) ON DELETE SET NULL
);

CREATE TABLE LinkinPark (
    UserId INT,
    PageId INT,
    Visibilite BOOLEAN,

    PRIMARY KEY (UserId, PageId),
    FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE,
    FOREIGN KEY (PageId) REFERENCES Pages(Id) ON DELETE CASCADE
);

CREATE TABLE Categories (
    Id SERIAL PRIMARY KEY,
    PageId INT,
    Icon TEXT,
    Nom TEXT,
    Type TEXT,
    Value TEXT,

    FOREIGN KEY (PageId) REFERENCES Pages(Id) ON DELETE CASCADE
);
INSERT INTO "users" ("username", "password", "token") VALUES ('test', 'test', 'test');

INSERT INTO "pages" ("contenu", "parent") VALUES ('{"id": 0, "type": "column", "content": [{"id": 1, "type": null, "content": ""}]}', NULL);
INSERT INTO "pages" ("contenu", "parent") VALUES ('{"id": 0, "type": "column", "content": [{"id": 1, "type": null, "content": ""}]}', NULL);
INSERT INTO "pages" ("contenu", "parent") VALUES ('{"id": 0, "type": "column", "content": [{"id": 1, "type": null, "content": ""}]}', NULL);
INSERT INTO "pages" ("contenu", "parent") VALUES ('{"id": 0, "type": "column", "content": [{"id": 1, "type": null, "content": ""}]}', NULL);
INSERT INTO "pages" ("contenu", "parent") VALUES ('{"id": 0, "type": "column", "content": [{"id": 1, "type": null, "content": ""}]}', 1);
INSERT INTO "pages" ("contenu", "parent") VALUES ('{"id": 0, "type": "column", "content": [{"id": 1, "type": null, "content": ""}]}', 1);

INSERT INTO "linkinpark" ("userid", "pageid", "visibilite") VALUES (1, 1, false);
INSERT INTO "linkinpark" ("userid", "pageid", "visibilite") VALUES (1, 2, true);
INSERT INTO "linkinpark" ("userid", "pageid", "visibilite") VALUES (1, 3, false);
INSERT INTO "linkinpark" ("userid", "pageid", "visibilite") VALUES (1, 4, true);
INSERT INTO "linkinpark" ("userid", "pageid", "visibilite") VALUES (1, 5, false);
INSERT INTO "linkinpark" ("userid", "pageid", "visibilite") VALUES (1, 6, true);
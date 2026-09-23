BEGIN TRANSACTION;
CREATE TABLE avaliacoes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER,
    conteudo_id INTEGER,
    nota REAL NOT NULL,
    data_avaliacao DATE NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (conteudo_id) REFERENCES conteudos(id)
);
INSERT INTO "avaliacoes" VALUES(1,1,1,4.8,'2023-06-01');
INSERT INTO "avaliacoes" VALUES(2,2,1,4.5,'2023-06-02');
INSERT INTO "avaliacoes" VALUES(3,1,2,4.0,'2023-06-03');
INSERT INTO "avaliacoes" VALUES(4,3,2,3.5,'2023-06-04');
INSERT INTO "avaliacoes" VALUES(5,4,3,5.0,'2023-06-05');
INSERT INTO "avaliacoes" VALUES(6,5,4,3.0,'2023-06-06');
INSERT INTO "avaliacoes" VALUES(7,2,5,4.2,'2023-06-07');
CREATE TABLE conteudos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT NOT NULL,
    tipo TEXT NOT NULL,
    categoria TEXT NOT NULL,
    ano_lancamento INTEGER NOT NULL,
    classificacao_etaria TEXT NOT NULL,
    deletado INTEGER DEFAULT 0
);
INSERT INTO "conteudos" VALUES(1,'Stranger Mind','Série','Ficção Científica',2016,'16+',0);
INSERT INTO "conteudos" VALUES(2,'Aventuras no Espaço','Filme','Ação',2021,'12+',0);
INSERT INTO "conteudos" VALUES(3,'O Mistério da Ilha','Filme','Ação',2019,'14+',0);
INSERT INTO "conteudos" VALUES(4,'Comédia em Família','Filme','Comédia',2020,'Livre',0);
INSERT INTO "conteudos" VALUES(5,'Drama Urbano','Série','Drama',2022,'18+',0);
INSERT INTO "conteudos" VALUES(6,'Filme Antigo Removido','Filme','Ação',2010,'12+',1);
CREATE TABLE historico_visualizacao (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER,
    conteudo_id INTEGER,
    minutos_assistidos INTEGER NOT NULL,
    data_visualizacao DATE NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (conteudo_id) REFERENCES conteudos(id)
);
INSERT INTO "historico_visualizacao" VALUES(1,1,1,50,'2023-06-01');
INSERT INTO "historico_visualizacao" VALUES(2,1,2,120,'2023-06-03');
INSERT INTO "historico_visualizacao" VALUES(3,2,1,45,'2023-06-02');
INSERT INTO "historico_visualizacao" VALUES(4,3,2,90,'2023-06-04');
INSERT INTO "historico_visualizacao" VALUES(5,4,3,110,'2023-06-05');
INSERT INTO "historico_visualizacao" VALUES(6,5,4,85,'2023-06-06');
INSERT INTO "historico_visualizacao" VALUES(7,2,5,60,'2023-06-07');
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    email TEXT NOT NULL,
    senha TEXT NOT NULL,
    plano TEXT NOT NULL,
    data_cadastro DATE NOT NULL
);
INSERT INTO "usuarios" VALUES(1,'Ana Silva','ana@email.com','hash123','Premium','2023-01-15');
INSERT INTO "usuarios" VALUES(2,'Bruno Costa','bruno@email.com','pass456','Padrão','2023-02-20');
INSERT INTO "usuarios" VALUES(3,'Carla Souza','carla@email.com','secret789','Básico','2023-03-10');
INSERT INTO "usuarios" VALUES(4,'Diego Lima','diego@email.com','pwd000','Premium','2023-04-05');
INSERT INTO "usuarios" VALUES(5,'Elena Rocha','elena@email.com','pass111','Padrão','2023-05-12');
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('usuarios',5);
INSERT INTO "sqlite_sequence" VALUES('conteudos',6);
INSERT INTO "sqlite_sequence" VALUES('avaliacoes',7);
INSERT INTO "sqlite_sequence" VALUES('historico_visualizacao',7);
COMMIT;

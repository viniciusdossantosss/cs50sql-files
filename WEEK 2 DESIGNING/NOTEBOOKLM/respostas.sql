-- Questão 1 --
CREATE TABLE IF NOT EXISTS spacecraft (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT
);

-- Questão 2 -- 
CREATE TABLE IF NOT EXISTS spacecraft_novo (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

INSERT INTO spacecraft_novo (id, name)
SELECT id, name FROM spacecraft;

DROP TABLE spacecraft;

ALTER TABLE spacecraft_novo RENAME TO spacecraft;

-- Questão 3 --
ALTER TABLE spacecraft ADD COLUMN capacity INTEGER DEFAULT 4;

-- Questão 4 --
CREATE TABLE IF NOT EXISTS astronauts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    status TEXT CHECK( status IN ('Ativo', 'Aposentado', 'Em Treinamento')),
    email TEXT NOT NULL UNIQUE
);





-- =====================================================================
-- LOJA ONLINE (e-commerce) — banco para praticar otimização em SQLite
-- Uso:  sqlite3 loja.db < loja_pratica.sql
--   ou: DB Browser for SQLite > Novo banco > aba "Executar SQL" > colar > executar
-- Sem índices além das chaves primárias (de propósito!).
-- =====================================================================

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS "avaliacoes";
DROP TABLE IF EXISTS "itens_pedido";
DROP TABLE IF EXISTS "pedidos";
DROP TABLE IF EXISTS "produtos";
DROP TABLE IF EXISTS "clientes";
DROP TABLE IF EXISTS "categorias";

-- ---------------------------------------------------------------------
-- 1) SCHEMA
-- ---------------------------------------------------------------------

-- 1:N  categorias -> produtos
CREATE TABLE "categorias" (
    "id"   INTEGER,
    "nome" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "clientes" (
    "id"            INTEGER,
    "nome"          TEXT NOT NULL,
    "email"         TEXT NOT NULL,   -- sem UNIQUE: UNIQUE criaria um índice automático
    "cidade"        TEXT NOT NULL,
    "estado"        TEXT NOT NULL,
    "data_cadastro" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "produtos" (
    "id"           INTEGER,
    "nome"         TEXT NOT NULL,
    "categoria_id" INTEGER NOT NULL,
    "preco"        NUMERIC NOT NULL CHECK ("preco" > 0),
    "estoque"      INTEGER NOT NULL DEFAULT 0 CHECK ("estoque" >= 0),
    PRIMARY KEY ("id"),
    FOREIGN KEY ("categoria_id") REFERENCES "categorias" ("id")
);

-- 1:N  clientes -> pedidos
CREATE TABLE "pedidos" (
    "id"          INTEGER,
    "cliente_id"  INTEGER NOT NULL,
    "data_pedido" TEXT NOT NULL,
    "status"      TEXT NOT NULL CHECK ("status" IN ('pendente', 'pago', 'enviado', 'entregue', 'cancelado')),
    PRIMARY KEY ("id"),
    FOREIGN KEY ("cliente_id") REFERENCES "clientes" ("id")
);

-- N:N  pedidos <-> produtos (tabela de junção)
CREATE TABLE "itens_pedido" (
    "id"             INTEGER,   -- PK própria (uma PK composta criaria índice automático)
    "pedido_id"      INTEGER NOT NULL,
    "produto_id"     INTEGER NOT NULL,
    "quantidade"     INTEGER NOT NULL CHECK ("quantidade" > 0),
    "preco_unitario" NUMERIC NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("pedido_id")  REFERENCES "pedidos" ("id"),
    FOREIGN KEY ("produto_id") REFERENCES "produtos" ("id")
);

-- N:N  clientes <-> produtos
CREATE TABLE "avaliacoes" (
    "id"         INTEGER,
    "cliente_id" INTEGER NOT NULL,
    "produto_id" INTEGER NOT NULL,
    "nota"       INTEGER NOT NULL CHECK ("nota" BETWEEN 1 AND 5),
    "comentario" TEXT,
    "data"       TEXT NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("cliente_id") REFERENCES "clientes" ("id"),
    FOREIGN KEY ("produto_id") REFERENCES "produtos" ("id")
);

-- ---------------------------------------------------------------------
-- 2) POPULAÇÃO (CTEs recursivas, dentro de uma transação para ser rápido)
-- ---------------------------------------------------------------------
BEGIN TRANSACTION;

-- 12 categorias
INSERT INTO "categorias" ("id", "nome") VALUES
    (1, 'Eletrônicos'), (2, 'Livros'), (3, 'Roupas'), (4, 'Casa e Cozinha'),
    (5, 'Esportes'), (6, 'Brinquedos'), (7, 'Beleza'), (8, 'Informática'),
    (9, 'Games'), (10, 'Papelaria'), (11, 'Pet Shop'), (12, 'Ferramentas');

-- 20.000 clientes
WITH RECURSIVE "seq"("n") AS (
    SELECT 1 UNION ALL SELECT "n" + 1 FROM "seq" WHERE "n" < 20000
)
INSERT INTO "clientes" ("id", "nome", "email", "cidade", "estado", "data_cadastro")
SELECT
    "n",
    json_extract('["Ana","Bruno","Carla","Diego","Elisa","Felipe","Gabriela","Hugo","Isabela","João","Larissa","Marcos","Natália","Otávio","Paula","Rafael","Sofia","Thiago","Vanessa","Vinicius"]', '$[' || (abs(random()) % 20) || ']')
      || ' ' ||
    json_extract('["Silva","Santos","Oliveira","Souza","Lima","Pereira","Costa","Rodrigues","Almeida","Nascimento","Ferreira","Gomes","Martins","Araújo","Barbosa"]', '$[' || (abs(random()) % 15) || ']'),
    'cliente' || "n" || '@exemplo.com',
    json_extract('["São Paulo","Rio de Janeiro","Belo Horizonte","Curitiba","Porto Alegre","Salvador","Recife","Fortaleza","Brasília","Manaus"]', '$[' || ("n" % 10) || ']'),
    json_extract('["SP","RJ","MG","PR","RS","BA","PE","CE","DF","AM"]', '$[' || ("n" % 10) || ']'),
    date('2020-01-01', '+' || (abs(random()) % 1800) || ' days')
FROM "seq";

-- 5.000 produtos
WITH RECURSIVE "seq"("n") AS (
    SELECT 1 UNION ALL SELECT "n" + 1 FROM "seq" WHERE "n" < 5000
)
INSERT INTO "produtos" ("id", "nome", "categoria_id", "preco", "estoque")
SELECT
    "n",
    json_extract('["Kit","Conjunto","Modelo","Pacote","Edição","Linha"]', '$[' || (abs(random()) % 6) || ']')
      || ' ' ||
    json_extract('["Premium","Básico","Pro","Plus","Eco","Max","Lite","Classic"]', '$[' || (abs(random()) % 8) || ']')
      || ' #' || "n",
    (abs(random()) % 12) + 1,
    round(5 + (abs(random()) % 200000) / 100.0, 2),   -- R$ 5,00 a ~R$ 2.005,00
    abs(random()) % 500
FROM "seq";

-- 100.000 pedidos (status desbalanceado: ~70% 'entregue' — bom para testar índice parcial)
WITH RECURSIVE "seq"("n") AS (
    SELECT 1 UNION ALL SELECT "n" + 1 FROM "seq" WHERE "n" < 100000
)
INSERT INTO "pedidos" ("id", "cliente_id", "data_pedido", "status")
SELECT
    "n",
    (abs(random()) % 20000) + 1,
    date('2022-01-01', '+' || (abs(random()) % 1460) || ' days'),
    CASE
        WHEN "r" < 70 THEN 'entregue'
        WHEN "r" < 80 THEN 'enviado'
        WHEN "r" < 88 THEN 'pago'
        WHEN "r" < 95 THEN 'pendente'
        ELSE 'cancelado'
    END
FROM (SELECT "n", ("n" * 7919) % 100 AS "r" FROM "seq");  -- hash fixo: random() aqui seria reavaliado em cada WHEN

-- 300.000 itens (3 por pedido, inseridos fora de ordem de pedido)
WITH RECURSIVE "seq"("n") AS (
    SELECT 1 UNION ALL SELECT "n" + 1 FROM "seq" WHERE "n" < 300000
)
INSERT INTO "itens_pedido" ("id", "pedido_id", "produto_id", "quantidade", "preco_unitario")
SELECT
    "n",
    (("n" - 1) % 100000) + 1,
    "p",
    (abs(random()) % 5) + 1,
    (SELECT "preco" FROM "produtos" WHERE "id" = "p")
FROM (SELECT "n", (("n" * 2654435761) % 5000) + 1 AS "p" FROM "seq");  -- hash fixo para "p" ser o mesmo nas duas colunas

-- 60.000 avaliações
WITH RECURSIVE "seq"("n") AS (
    SELECT 1 UNION ALL SELECT "n" + 1 FROM "seq" WHERE "n" < 60000
)
INSERT INTO "avaliacoes" ("id", "cliente_id", "produto_id", "nota", "comentario", "data")
SELECT
    "n",
    (abs(random()) % 20000) + 1,
    (abs(random()) % 5000) + 1,
    "nota",
    CASE "nota"
        WHEN 5 THEN 'Excelente, recomendo!'
        WHEN 4 THEN 'Muito bom.'
        WHEN 3 THEN 'Ok, nada demais.'
        WHEN 2 THEN 'Deixou a desejar.'
        ELSE 'Péssimo, não comprem.'
    END,
    date('2022-01-15', '+' || (abs(random()) % 1460) || ' days')
FROM (SELECT "n", (("n" * 7919) % 997) % 5 + 1 AS "nota" FROM "seq");

COMMIT;

-- ---------------------------------------------------------------------
-- 3) VERIFICAÇÃO: contagem de linhas por tabela
-- ---------------------------------------------------------------------
SELECT 'categorias'   AS "tabela", COUNT(*) AS "linhas" FROM "categorias"
UNION ALL SELECT 'clientes',     COUNT(*) FROM "clientes"
UNION ALL SELECT 'produtos',     COUNT(*) FROM "produtos"
UNION ALL SELECT 'pedidos',      COUNT(*) FROM "pedidos"
UNION ALL SELECT 'itens_pedido', COUNT(*) FROM "itens_pedido"
UNION ALL SELECT 'avaliacoes',   COUNT(*) FROM "avaliacoes";

-- Esperado: 12 | 20000 | 5000 | 100000 | 300000 | 60000
-- Conferir que não há índices (deve vir vazio):
SELECT "name", "tbl_name" FROM "sqlite_master" WHERE "type" = 'index';

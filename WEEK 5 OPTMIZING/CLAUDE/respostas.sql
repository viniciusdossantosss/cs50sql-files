-- 1 -
SELECT * FROM clientes
WHERE "email" = 'cliente15000@exemplo.com';
-- tempo real 0.009894
-- saida do plano QUERY PLAN --SCAN clientes
-- Significa que a tabela toda vai ser scaneada linha por linha pra responder essa query, e o retorno será as linhas que correspondem a query que eu fiz

-- 2 -
SELECT * FROM "pedidos"
WHERE "id" = 4321;

SELECT * FROM "pedidos"
WHERE "cliente_id" = 4321;

-- QUERY PLAN
-- `--SEARCH pedidos USING INTEGER PRIMARY KEY (rowid=?)

-- QUERY PLAN
-- `--SCAN pedidos

-- Isso acontece pois as colunas id é uma chave primaria e no sqlite ela é o proprio rowid, e a tabela fica guardada numa B-Tree ordenada por ele, por isso ele usa search sem criarmos nada. Já a cliente id apesar de ser uma chave primaria, nessa tablea ela é estrangeira e não ganha esse indice automatico logo o banco tem que fazer o scanneamento de todas as linhas e achar correspondencia.

-- 3 -
CREATE INDEX "email_index" ON "clientes"("email");

-- QUERY PLAN `--SEARCH clientes USING INDEX email_index (email=?)
-- tempo real 0.007808

-- O tempo foi algo em torno de 20% menor

-- 4 -
SELECT COUNT(*) FROM "produtos"
WHERE "categoria_id" = 8;

SELECT SUM("quantidade") AS "Total de produtos id 1234"
FROM "itens_pedido"
WHERE "produto_id" = 1234;

CREATE INDEX "categoria_id_index" ON "produtos"("categoria_id");

CREATE INDEX "produto_id_index" ON "itens_pedido"("produto_id");

-- a - sem index - real 0.001571 - com index - real 0.001259
-- b - sem index - real 0.015443 - com index - real 0.002424

-- O ganho foi diferente por causa do tamanho da tabela a segunda tabela é muito maior o que faz o ganho do index ser muito maior, tambem ocorre que a primeira tabela só tem 12 valores pra categoria_id o que faz que mesmo indexado ela leia mais linhas e no segundo caso o produto_id possui 5000 valores possiveis o que faz com que se percorra menos linha diminuindo o tempo.

-- 5 - 
CREATE INDEX "data_pedido_index" ON "pedidos"("data_pedido");

EXPLAIN QUERY PLAN
SELECT * FROM pedidos
WHERE "data_pedido" BETWEEN '2023-01-01' AND '2023-01-31';
-- QUERY PLAN
-- `--SEARCH pedidos USING INDEX data_pedido_index (data_pedido>? AND data_pedido<?)
-- Run Time: real 0.001572 user 0.000000 sys 0.000000

EXPLAIN QUERY PLAN
SELECT * FROM pedidos
WHERE strftime('%Y-%m', data_pedido) = '2023-01';
-- QUERY PLAN
-- `--SCAN pedidos
-- Run Time: real 0.000532 user 0.000000 sys 0.000000

-- Isso acontece pois a segunda query usa uma comparação que não possui nos indices o que está sendo comparado no WHERE.

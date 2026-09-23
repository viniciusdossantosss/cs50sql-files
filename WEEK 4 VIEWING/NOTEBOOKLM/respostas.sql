CREATE VIEW filmes_acao AS
SELECT id, titulo, ano_lancamento
FROM conteudos
WHERE tipo = 'Filme' AND categoria = 'Ação';
  
CREATE VIEW usuarios_anonimos AS
SELECT id, plano, 'Oculto' AS email
FROM usuarios;

CREATE VIEW catalogo_alfabetico AS
SELECT titulo, tipo, categoria
FROM conteudos
ORDER BY titulo ASC;

CREATE VIEW historico_detalhado AS


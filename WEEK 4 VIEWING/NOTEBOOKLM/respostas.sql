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
SELECT usuarios.nome, conteudos.titulo, historico_visualizacao.minutos_assistidos
FROM usuarios
JOIN historico_visualizacao ON usuarios.id = historico_visualizacao.usuario_id
JOIN conteudos ON historico_visualizacao.conteudo_id = conteudos.id;

CREATE VIEW medias_conteudos AS
SELECT avaliacoes.conteudo_id, conteudos.titulo, ROUND(AVG(avaliacoes.nota), 2) AS media_nota
FROM avaliacoes
JOIN conteudos ON avaliacoes.conteudo_id = conteudos.id
GROUP BY avaliacoes.conteudo_id;

CREATE VIEW total_minutos_por_usuario AS
SELECT usuarios.nome, SUM(historico_visualizacao.minutos_assistidos) AS total_minutos
FROM usuarios
JOIN historico_visualizacao ON usuarios.id = historico_visualizacao.usuario_id
GROUP BY usuarios.id;
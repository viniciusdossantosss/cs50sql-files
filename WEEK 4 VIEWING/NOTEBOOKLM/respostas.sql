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

CREATE TEMPORARY VIEW medias_por_ano AS
SELECT conteudos.ano_lancamento, ROUND(AVG(avaliacoes.nota), 2) AS media_nota
FROM avaliacoes
JOIN conteudos ON avaliacoes.conteudo_id = conteudos.id
GROUP BY conteudos.ano_lancamento;

CREATE VIEW conteudos_ativos AS 
SELECT id, titulo, tipo, categoria, ano_lancamento, classificacao_etaria
FROM conteudos
WHERE deletado = 0;

WITH medias_temp AS (
    SELECT avaliacoes.conteudo_id, conteudos.titulo, ROUND(AVG(avaliacoes.nota), 2) AS media_nota
    FROM avaliacoes
    JOIN conteudos ON avaliacoes.conteudo_id = conteudos.id
    GROUP BY avaliacoes.conteudo_id
)
SELECT titulo, media_nota FROM medias_temp
WHERE media_nota > 4.5;

CREATE VIEW top_recomendados AS
SELECT * FROM medias_conteudos
WHERE media_nota >= 4;

CREATE VIEW desempenho_categorias AS 
SELECT conteudos.categoria, 
    COUNT(avaliacoes.conteudo_id) AS quantidade_avaliacoes,
    ROUND(AVG(avaliacoes.nota), 2) AS media_notas
FROM avaliacoes
JOIN conteudos ON avaliacoes.conteudo_id = conteudos.id
GROUP BY conteudos.categoria;

WITH minutos_por_usuario AS ( 
    SELECT usuarios.id AS usuario_id, 
        usuarios.nome, 
        SUM(historico_visualizacao.minutos_assistidos) AS total_minutos 
    FROM usuarios 
    JOIN historico_visualizacao ON usuarios.id = historico_visualizacao.usuario_id GROUP BY usuarios.id, usuarios.nome )
WITH usuarios_engajados AS ( 
    SELECT nome, total_minutos 
    FROM minutos_por_usuario 
    WHERE total_minutos > 120 )
SELECT nome, total_minutos FROM usuarios_engajados;

CREATE TRIGGER "trg_soft_delete"
INSTEAD OF DELETE ON conteudos_ativos
FOR EACH ROW
BEGIN 
    UPDATE conteudos
    SET deletado = 1
    WHERE id = OLD.id;
END;

CREATE TRIGGER "trg_insert_conteudo"
INSTEAD OF INSERT ON conteudos_ativos
FOR EACH ROW
WHEN NEW.titulo IN (
    SELECT titulo FROM conteudos
)
BEGIN
    UPDATE conteudos
    SET deletado = 0
    WHERE titulo = NEW.titulo;
END;

CREATE TRIGGER "trg_insert_conteudo"
INSTEAD OF INSERT ON conteudos_ativos
FOR EACH ROW
WHEN NEW.titulo NOT IN (
    SELECT titulo FROM conteudos
)
BEGIN
    INSERT INTO conteudos (titulo, tipo, cate)
END;
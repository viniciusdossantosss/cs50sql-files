SELECT id FROM diretores
WHERE nome = "Christopher Nolan";

SELECT titulo, ano_lancamento FROM filmes
WHERE ano_lancamento > 2015;

SELECT filme_id, nota FROM avaliacoes
WHERE critico_id = 3;

SELECT nome FROM diretores
WHERE pais_origem = 'EUA';

SELECT titulo FROM filmes
WHERE diretor_id = (
    SELECT id FROM diretores
    WHERE nome = 'Jordan Peele'
);

SELECT nome FROM atores
WHERE id IN (
    SELECT ator_id FROM elenco
    WHERE filme_id = (
        SELECT id FROM filmes
        WHERE titulo = 'Dune'
    )
);

SELECT titulo FROM filmes
WHERE id IN (
    SELECT filme_id FROM avaliacoes
    WHERE nota >= 9.5
);

SELECT titulo FROM filmes
WHERE id IN (
    SELECT filme_id FROM filme_generos
    WHERE genero_id = (
        SELECT id FROM generos
        WHERE nome = 'Ficção Científica'
    )
);

SELECT filmes.titulo AS "título do filme", diretores.nome AS "nome do diretor" FROM filmes
INNER JOIN diretores ON filmes.diretor_id = diretores.id;

SELECT atores.nome AS "nome do ator", elenco.papel AS "papel" FROM atores
LEFT JOIN elenco ON atores.id = elenco.ator_id;

SELECT * FROM filmes
FULL JOIN diretores ON filmes.diretor_id = diretores.id;

SELECT nome FROM atores
INTERSECT
SELECT nome FROM diretores;

SELECT nome, 'Ator' AS profissao FROM atores
UNION
SELECT nome, 'Diretor' AS profissao FROM diretores;

SELECT nome FROM diretores
EXCEPT
SELECT nome FROM atores;






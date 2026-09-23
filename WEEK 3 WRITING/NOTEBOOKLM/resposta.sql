CREATE TRIGGER impedir_delacao_autor_ativo
BEFORE DELETE ON autores
FOR EACH ROW
BEGIN
    SELECT RAISE (FAIL, 'Não é possivel deletar um autor que possui livros ativos!')
    WHERE EXISTS (
        SELECT 1 FROM autoria AS a
        JOIN livros AS l ON a.livro_id = l.id
        WHERE a.autor_id = OLD.id AND l.deletado = 0
    );
END;

CREATE TRIGGER log_soft_delete_livro
AFTER UPDATE OF deletado ON livros
FOR EACH ROW
WHEN NEW.deletado = 1 AND OLD.deletado = 0
BEGIN
    INSERT INTO historico_vendas(titulo_livro, acao, data_registro)
    VALUES (NEW.titulo, 'DESATIVADO', date('now'));
END;

CREATE TRIGGER log_vendas_trigger
AFTER INSERT ON vendas
FOR EACH ROW
BEGIN
    INSERT INTO historico_vendas (titulo_livro, acao, data_registro)
    VALUES ( (SELECT titulo FROM livros WHEREid = NEW.livro_id), 'VENDIDO', '2026-09-07' );
END;


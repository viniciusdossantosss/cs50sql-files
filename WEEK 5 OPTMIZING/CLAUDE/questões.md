Questões de otimização: banco loja.db

Antes de começar: rode .timer on no terminal (no DB Browser, o tempo aparece embaixo do resultado). Anote o tempo “real” de cada consulta. Se precisar recomeçar do zero, rode o script loja_pratica.sql de novo.

Básico (1–5)

1. Encontrando a consulta lenta
Busque o cliente com e-mail 'cliente15000@exemplo.com'. Rode a mesma consulta precedida de EXPLAIN QUERY PLAN.
Entregar: a query, o tempo “real” e a saída do plano. Explique em 1–2 frases o que a palavra que aparece no plano (SCAN ou SEARCH) significa aqui.

2. Por que uma é rápida e a outra não?
Compare o plano de SELECT * FROM "pedidos" WHERE "id" = 4321; com o de uma consulta que busca os pedidos do cliente_id 4321.
Entregar: as duas queries, os dois planos e uma justificativa de por que um já usa índice sem você ter criado nenhum.

3. Primeiro índice
Crie um índice que acelere a consulta da Questão 1.
Entregar: o CREATE INDEX, o plano e o tempo depois do índice, e a comparação antes/depois (quantas vezes mais rápido?).

4. Nem todo índice ajuda igual
Meça e compare, com e sem índice, duas consultas:

(a) contar os produtos da categoria_id 8;
(b) contar os itens vendidos do produto_id 1234.

Entregar: os índices, os tempos antes/depois de cada consulta e uma explicação de por que o ganho foi diferente. Dica: pense em quantos valores distintos cada coluna tem e em quantas linhas tem cada tabela.

5. O índice existe, mas não é usado
Crie um índice em pedidos("data_pedido"). Depois escreva duas consultas que retornem os pedidos de janeiro de 2023:

uma comparando "data_pedido" diretamente com um intervalo;
outra aplicando uma função (por exemplo strftime) sobre a coluna.

Entregar: as duas queries, os dois planos e uma explicação de por que só uma delas usa o índice.

Intermediário (6–10)

6. Ordem das colunas importa
A consulta é: pedidos de um cliente_id específico com status = 'pendente'.

Crie primeiro um índice composto ("cliente_id", "status") e, em outro teste, ("status", "cliente_id").
Para cada um, rode o EXPLAIN QUERY PLAN de três consultas: filtro por cliente + status, só por cliente e só por status.

Entregar: uma tabela “índice × consulta → usou ou não”, mais uma regra geral, com suas palavras, sobre como escolher a ordem das colunas.

7. Covering index
Para a consulta SELECT "produto_id", "quantidade" FROM "itens_pedido" WHERE "pedido_id" = 50000;, crie um índice que faça o plano mostrar USING COVERING INDEX.
Entregar: o índice, o plano e uma explicação de que passo o banco economiza com isso. Mostre também o plano com um índice só em "pedido_id", para comparar.

8. Índice parcial
A equipe de operações abre o tempo todo um painel com os pedidos pendentes, ordenados por data.
Entregar:

o CREATE INDEX parcial;
o plano da consulta do painel;
o plano de uma consulta por status = 'entregue', provando que ela não usa o índice;
uma justificativa de por que um índice parcial faz sentido aqui. Use a distribuição dos status.

9. O custo dos índices na escrita
Crie uma tabela itens_teste com a mesma estrutura de itens_pedido. Meça o tempo de copiar as 300 mil linhas para ela (INSERT INTO ... SELECT) em dois cenários: (a) sem índices e (b) com 3 índices criados antes da cópia. Depois meça um UPDATE que altera "quantidade" em todos os itens do produto_id 1234, com e sem um índice que contenha "quantidade".
Entregar: os comandos, os tempos e uma explicação usando a ideia da B-Tree.

10. .timer e ORDER BY
Rode 3 vezes seguidas uma consulta que lista os 10 pedidos mais recentes (ORDER BY "data_pedido" DESC LIMIT 10). Faça isso com e sem um índice adequado.
Entregar:

(a) os tempos das 3 execuções e uma explicação de por que a primeira pode ser diferente;
(b) o que significam real, user e sys;
(c) o que acontece com a linha USE TEMP B-TREE FOR ORDER BY no plano quando o índice existe.
Avançado (11–15)

Antes destas questões, apague todos os índices que você criou (DROP INDEX). Para listar o que existe: SELECT "name" FROM "sqlite_master" WHERE "type" = 'index';.

11. JOIN com várias tabelas
Escreva uma consulta que mostre, para o cliente 'cliente777@exemplo.com', cada pedido com a data, o nome dos produtos, a quantidade e o subtotal (quantidade × preço unitário).
Entregar:

a query;
o plano sem índices;
o menor conjunto de índices que elimina todos os SCANs;
o plano final e os tempos antes/depois.

Justifique cada índice.

12. Quais índices NÃO criar
Liste os 10 produtos da categoria 'Games' com a maior nota média, considerando só produtos com pelo menos 20 avaliações.
Entregar:

a query e os índices que você criou;
pelo menos dois índices que você decidiu não criar, com o porquê. Pense em tamanho de tabela, colunas consultadas por nome versus por id, e colunas que o plano já cobre.

13. Projeto de índices para uma carga real
A loja recebe cerca de 5 mil pedidos novos por hora, com 3 itens cada, e roda com frequência estas consultas:

(a) login pelo e-mail;
(b) histórico de pedidos de um cliente;
(c) itens de um pedido;
(d) avaliações de um produto;
(e) relatório mensal de vendas por categoria, rodado 1 vez por mês;
(f) painel de pedidos pendentes.

Você pode criar no máximo 5 índices.
Entregar:

a lista de índices escolhidos, cada um ligado à consulta que atende;
a query de cada item;
pelo menos 2 índices tentadores que você rejeitou, por exemplo em "status" sozinho ou em "nota", e por quê. Considere o volume de escrita.

14. VACUUM e tamanho do arquivo
Meça o tamanho do banco a cada etapa, com du -b loja.db ou com PRAGMA page_count; × PRAGMA page_size;, e anote também PRAGMA freelist_count;. As etapas são:

estado atual;
depois de criar 4 índices à sua escolha;
depois de apagar todos os pedidos 'cancelado' e seus itens, e de dar DROP nos índices;
depois de VACUUM.

Entregar: os comandos, uma tabela com tamanho e freelist por etapa, e uma explicação de por que o tamanho não caiu na etapa 3. Responda também: os dados apagados ainda poderiam ser recuperados antes do VACUUM?

15. Transações e race condition no estoque
Defina o estoque do produto 42 como 1. Dois clientes tentam comprar essa última unidade ao mesmo tempo.
Entregar:

(a) uma transação completa que cria o pedido, insere o item e diminui o estoque, terminando em COMMIT. Mostre que uma segunda compra falha pelo CHECK e que um ROLLBACK deixa o banco consistente, sem pedido “órfão”;
(b) a descrição de uma race condition que aconteceria se uma aplicação primeiro fizesse SELECT do estoque e só depois o UPDATE, fora de uma transação;
(c) uma simulação com dois terminais: um abre BEGIN EXCLUSIVE TRANSACTION; e o outro tenta ler. Anote o erro e explique-o usando os estados UNLOCKED, SHARED e EXCLUSIVE;
(d) qual propriedade do ACID cada parte demonstra.
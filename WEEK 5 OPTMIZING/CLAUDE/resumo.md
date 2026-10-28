A página da semana só listava os tópicos, então usei as notas da aula (o link “Notes” dessa página). Abri as notas na mesma aba. Se quiser voltar para a página anterior, é só usar o botão Voltar.

Resumo rápido: Week 5, Optimizing

Índice (CREATE INDEX): é uma estrutura que acelera a busca de linhas, como o índice de um livro. Sem ele, o banco faz um scan, que é ler a tabela inteira linha por linha. A chave primária já ganha um índice automaticamente.
EXPLAIN QUERY PLAN: mostra como o SQLite vai executar a consulta. Ele indica se vai fazer um SCAN (ler tudo) ou um SEARCH (usar um índice).
.timer on: mede quanto tempo a consulta leva. O tempo “real” é o que importa, e com ele dá para comparar a consulta com e sem índice.
Covering index: é quando o índice já contém tudo o que a consulta precisa, então ele resolve tudo em um passo, sem voltar à tabela. Exemplo: um índice em stars("person_id", "movie_id").
B-Tree: é a “árvore balanceada” em que o índice fica guardado. Ela tem uma raiz, nós intermediários que apontam o caminho e folhas com os valores ordenados.
Trade-offs: índices ocupam espaço extra. Também deixam INSERT mais lento, porque a cada inserção o banco precisa percorrer a B-Tree para encaixar o novo valor.
Partial index: é um índice só de uma parte das linhas, definida com WHERE, como WHERE "year" = 2023. Ele economiza espaço quando os usuários consultam sobretudo esse subconjunto.
VACUUM: quando você apaga dados, o espaço só fica marcado como livre e o arquivo continua do mesmo tamanho. O VACUUM libera esse espaço de fato e diminui o arquivo.
Transações e ACID (BEGIN TRANSACTION, COMMIT, ROLLBACK): uma transação é uma unidade de trabalho do tipo “tudo ou nada”, como tirar $10 da Alice e colocar na conta do Bob. ACID significa:
Atomicidade: não dá para dividir a transação em partes.
Consistência: a transação não viola nenhuma restrição do banco.
Isolamento: transações de usuários diferentes não interferem umas nas outras.
Durabilidade: o que foi gravado sobrevive a falhas.
O ROLLBACK desfaz tudo se algo falhar.
Concorrência, race conditions e locks: quando vários usuários acessam o mesmo dado ao mesmo tempo, podem surgir inconsistências, que dá até para explorar para “roubar o banco”. Para evitar isso, o SQLite usa travas (locks):
UNLOCKED: ninguém está acessando o banco.
SHARED: várias transações podem ler ao mesmo tempo.
EXCLUSIVE: uma única transação escreve e ninguém mais acessa. É o que acontece com BEGIN EXCLUSIVE TRANSACTION.
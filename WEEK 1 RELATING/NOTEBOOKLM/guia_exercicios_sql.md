# Guia Prático de Relacionamentos em SQL (Baseado na Aula do CS50)

Bem-vindo ao seu ambiente prático de testes! Para ajudar você a consolidar todos os conceitos ensinados na aula sobre **Relacionamentos em SQL (Relating)**, criamos um banco de dados SQLite real chamado `cinema_relacional.db` e esta lista exclusiva com **15 exercícios de dificuldade progressiva**.

Este guia contém:
1. **O Esquema do Banco de Dados**: Explicação das tabelas e chaves.
2. **O Diagrama de Relacionamento (ERD)** em formato textual/ASCII.
3. **Instruções de Configuração**: Como começar a praticar em seu computador.
4. **15 Exercícios**: Divididos por nível e focados nos temas da aula (Chaves Estrangeiras, Subqueries, JOINs, Sets e Groups).
5. **Dicas e Gabarito**: As consultas SQL de resposta e o resultado esperado para você se autoavaliar.

---

## 1. O Esquema do Banco de Dados (`cinema_relacional.db`)

Para praticar relacionamentos 1:1, 1:N e N:N, modelamos um **Sistema de Cinema e Críticas** composto pelas seguintes tabelas:

*   **`diretores`**: Armazena as mentes criativas por trás dos filmes.
    *   `id` (INTEGER, Chave Primária)
    *   `nome` (TEXT, não nulo)
    *   `pais_origem` (TEXT)
*   **`filmes`**: Lista de obras cinematográficas. Tem uma relação **1 para Muitos (1:N)** com diretores.
    *   `id` (INTEGER, Chave Primária)
    *   `titulo` (TEXT, não nulo)
    *   `ano_lancamento` (INTEGER)
    *   `diretor_id` (INTEGER, Chave Estrangeira que referencia `diretores(id)`)
*   **`atores`**: Lista de atores cadastrados.
    *   `id` (INTEGER, Chave Primária)
    *   `nome` (TEXT, não nulo)
    *   `ano_nascimento` (INTEGER)
*   **`elenco`**: Tabela de associação para a relação **Muitos para Muitos (N:N)** entre `atores` e `filmes`.
    *   `ator_id` (INTEGER, Chave Estrangeira que referencia `atores(id)`)
    *   `filme_id` (INTEGER, Chave Estrangeira que referencia `filmes(id)`)
    *   `papel` (TEXT) - Representa o personagem do ator no filme.
    *   *Chave Primária Composta:* `(ator_id, filme_id)`
*   **`criticos`**: Pessoas ou mídias que avaliam os filmes.
    *   `id` (INTEGER, Chave Primária)
    *   `nome` (TEXT, não nulo)
    *   `veiculo` (TEXT) - Ex: YouTube, Revista, Portal.
*   **`avaliacoes`**: Avaliações dadas por críticos aos filmes. Relação **Muitos para Muitos (N:N)** entre `criticos` e `filmes`.
    *   `filme_id` (INTEGER, Chave Estrangeira que referencia `filmes(id)`)
    *   `critico_id` (INTEGER, Chave Estrangeira que referencia `criticos(id)`)
    *   `nota` (REAL) - De 1.0 a 10.0.
    *   *Chave Primária Composta:* `(filme_id, critico_id)`
*   **`generos`**: Categorias cinematográficas.
    *   `id` (INTEGER, Chave Primária)
    *   `nome` (TEXT, não nulo)
*   **`filme_generos`**: Tabela de associação N:N entre `filmes` e `generos`.
    *   `filme_id` (INTEGER, Chave Estrangeira que referencia `filmes(id)`)
    *   `genero_id` (INTEGER, Chave Estrangeira que referencia `generos(id)`)
    *   *Chave Primária Composta:* `(filme_id, genero_id)`

---

## 2. Diagrama Entidade-Relacionamento (ERD)

Aqui está a representação visual de como as tabelas se conectam usando a lógica apresentada na aula:

```text
  +------------------+         +------------------+
  |    diretores     |         |     criticos     |
  +------------------+         +------------------+
  | id (PK)          |         | id (PK)          |
  | nome             |         | nome             |
  | pais_origem      |         | veiculo          |
  +------------------+         +------------------+
           | 1                          | 1
           |                            |
           | N                          | N
  +------------------+         +------------------+
  |      filmes      | 1     N |    avaliacoes    |
  +------------------+---------|------------------+
  | id (PK)          |         | filme_id (PFK)   |
  | titulo           |         | critico_id (PFK) |
  | ano_lancamento   |         | nota             |
  | diretor_id (FK)  |         +------------------+
  +------------------+
     | 1          | 1
     |            |
     | N          | N
+------------+  +------------------+
|   elenco   |  |  filme_generos   |
+------------+  +------------------+
| ator_id*   |  | filme_id (PFK)   |
| filme_id*  |  | genero_id (PFK)  |
| papel      |  +------------------+
+------------+           | N
     | N                 |
     |                   | 1
+------------+  +------------------+
|   atores   |  |     generos      |
+------------+  +------------------+
| id (PK)    |  | id (PK)          |
| nome       |  | nome             |
| ano_nasc.  |  +------------------+
+------------+
* (ator_id, filme_id) formam a Chave Primária Composta em elenco.
```

---

## 3. Instruções de Configuração

Como este ambiente do Gemini Notebook gerou o arquivo físico `cinema_relacional.db` na sua aba **Studio** (à direita), você pode:
1. **Baixar o arquivo** `cinema_relacional.db` diretamente do painel Studio.
2. Usar o terminal do seu computador (caso tenha o SQLite3 instalado) para rodar o banco:
   ```bash
   sqlite3 cinema_relacional.db
   ```
3. Se preferir rodar online ou em uma interface visual, você pode baixar o arquivo e importá-lo no excelente [DB Browser for SQLite](https://sqlitebrowser.org/) ou arrastar o arquivo para o [Sqlite Online](https://sqliteonline.com/).

---

## 4. Lista de 15 Exercícios (Dificuldade Progressiva)

### Nível Fácil: Filtros, Chaves Primárias e Consultas Básicas
**Objetivo**: Entender a estrutura individual das tabelas, localizar IDs específicos (chaves primárias) e filtrar dados simples.

1. **Questão 1**: Encontre o `id` do diretor **Christopher Nolan**.
2. **Questão 2**: Liste todos os títulos e anos dos filmes que foram lançados **depois de 2015**.
3. **Questão 3**: Selecione todas as notas e códigos de filmes (`filme_id`) avaliados pelo crítico cujo `critico_id` seja **3** (Roger Ebert).
4. **Questão 4**: Selecione o nome de todos os diretores cujo país de origem seja **'EUA'**.

---

### Nível Médio: Subqueries (Consultas Aninhadas) e Operador IN
**Objetivo**: Relacionar tabelas sem usar JOINs, resolvendo uma consulta interna para alimentar uma externa (como visto na aula para encontrar livros de um publicador).

5. **Questão 5**: Descubra os títulos de todos os filmes dirigidos por **"Jordan Peele"** usando uma **subquery** para descobrir o ID do diretor dinamicamente (sem fazer JOIN).
6. **Questão 6**: Encontre os nomes de todos os atores que atuaram no filme **"Dune"** usando **subqueries aninhadas** (você precisará buscar o ID do filme na tabela `filmes`, depois os IDs dos atores correspondentes na tabela `elenco`, e por fim os nomes na tabela `atores`). Não use JOIN.
7. **Questão 7**: Liste os títulos de todos os filmes que receberam pelo menos uma nota **maior ou igual a 9.5** na tabela `avaliacoes`, usando uma subquery com o operador `IN`.
8. **Questão 8**: Liste os títulos de todos os filmes categorizados sob o gênero **"Ficção Científica"**. Use subqueries e o operador `IN` (dica: você precisará anerar queries passando por `generos`, `filme_generos` e `filmes`).

---

### Nível Avançado: JOINs (Inner, Left, Right, Full)
**Objetivo**: Unir múltiplas tabelas fisicamente em um único conjunto de resultados, entendendo o comportamento de cada tipo de JOIN ao lidar com dados faltantes ou vazios.

9. **Questão 9**: Faça um `INNER JOIN` entre `filmes` e `diretores` para exibir uma tabela com duas colunas: o **título do filme** e o **nome do diretor** correspondente.
10. **Questão 10**: Faça um `LEFT JOIN` entre a tabela `atores` (tabela da esquerda) e `elenco` (tabela da direita). Exiba o **nome do ator** e seu **papel**. Observe que atores que não têm nenhum papel atribuído (como "Tom Hanks") aparecem com o papel igual a `NULL`, pois o `LEFT JOIN` preserva todos os registros da tabela da esquerda.
11. **Questão 11**: Realize um `FULL JOIN` entre `filmes` e `diretores` relacionando-os pelo ID do diretor. Essa consulta deve mostrar filmes sem diretores cadastrados (como "Metropolis") e diretores sem nenhum filme cadastrado (como "Akira Kurosawa" e "Clint Eastwood") em uma única tabela consolidada.

---

### Nível Sets: Operações de Conjunto (Union, Intersect, Except)
**Objetivo**: Combinar e filtrar resultados de múltiplos conjuntos de dados de forma vertical, exatamente como os diagramas de Venn apresentados na aula.

12. **Questão 12**: Descubra se existem profissionais que foram cadastrados tanto na tabela de `atores` quanto na tabela de `diretores` (interseção de conjuntos). Use o operador `INTERSECT` baseado na coluna `nome`.
13. **Questão 13**: Crie uma lista unificada de todos os profissionais cadastrados nas tabelas `atores` e `diretores` usando o operador `UNION`. Para cada profissional, crie uma coluna estática chamada `profissao` contendo as strings `'Ator'` ou `'Diretor'`, dependendo da tabela de origem (siga o modelo feito na aula para unificar autores e tradutores).
14. **Questão 14**: Liste os nomes de todos os diretores cadastrados que **NÃO** estão registrados como atores. Use o operador `EXCEPT`.

---

### Nível Expert: Agrupamentos e Agregações (Group By, Having, Order By)
**Objetivo**: Agrupar linhas duplicadas para calcular estatísticas agregadas (médias, contagens), filtrar esses grupos com condições especiais e ordenar o resultado final.

15. **Questão 15**: Escreva uma consulta para exibir o **título de cada filme** e sua **nota média de avaliação** arredondada para duas casas decimais (utilize a função `ROUND(..., 2)` combinada com `AVG(...)`). Para trazer os títulos, você precisará fazer um `JOIN` entre `filmes` e `avaliacoes`. Agrupe os resultados por filme (`GROUP BY`), filtre para exibir **apenas** filmes cuja nota média de avaliações seja **maior que 8.0** (use a cláusula `HAVING`) e ordene o resultado final do filme mais bem avaliado para o menos bem avaliado (`ORDER BY ... DESC`).

---

## 5. Gabarito e Soluções (Para Autoavaliação)

Não olhe antes de tentar fazer! Use o gabarito para verificar se sua lógica SQL bateu com a planejada.

<details>
<summary><b>Clique para expandir o Gabarito de Respostas</b></summary>

### Resposta 1
```sql
SELECT id FROM diretores WHERE nome = 'Christopher Nolan';
```
*   **Resultado esperado:**
    ```text
    id: 1
    ```

### Resposta 2
```sql
SELECT titulo, ano_lancamento FROM filmes WHERE ano_lancamento > 2015;
```
*   **Resultado esperado:**
    ```text
    Barbie | 2023
    Lady Bird | 2017
    Get Out | 2017
    Nope | 2022
    Dune | 2021
    Parasite | 2019
    ```

### Resposta 3
```sql
SELECT filme_id, nota FROM avaliacoes WHERE critico_id = 3;
```
*   **Resultado esperado:**
    ```text
    filme_id | nota
    1        | 9.0
    2        | 8.5
    3        | 9.5
    4        | 9.5
    9        | 10.0
    11       | 10.0
    12       | 10.0
    ```

### Resposta 4
```sql
SELECT nome FROM diretores WHERE pais_origem = 'EUA';
```
*   **Resultado esperado:**
    ```text
    Steven Spielberg
    Greta Gerwig
    Jordan Peele
    Quentin Tarantino
    Clint Eastwood
    ```

### Resposta 5
```sql
SELECT titulo FROM filmes 
WHERE diretor_id = (
    SELECT id FROM diretores WHERE nome = 'Jordan Peele'
);
```
*   **Resultado esperado:**
    ```text
    Get Out
    Nope
    ```

### Resposta 6
```sql
SELECT nome FROM atores 
WHERE id IN (
    SELECT ator_id FROM elenco 
    WHERE filme_id = (
        SELECT id FROM filmes WHERE titulo = 'Dune'
    )
);
```
*   **Resultado esperado:**
    ```text
    Timothée Chalamet
    Florence Pugh
    ```

### Resposta 7
```sql
SELECT titulo FROM filmes 
WHERE id IN (
    SELECT filme_id FROM avaliacoes WHERE nota >= 9.5
);
```
*   **Resultado esperado:**
    ```text
    Inception
    Jaws
    Jurassic Park
    Get Out
    Pulp Fiction
    Parasite
    Metropolis
    ```

### Resposta 8
```sql
SELECT titulo FROM filmes 
WHERE id IN (
    SELECT filme_id FROM filme_generos 
    WHERE genero_id = (
        SELECT id FROM generos WHERE nome = 'Ficção Científica'
    )
);
```
*   **Resultado esperado:**
    ```text
    Inception
    Interstellar
    Jurassic Park
    Nope
    Dune
    Metropolis
    ```

### Resposta 9
```sql
SELECT filmes.titulo, diretores.nome 
FROM filmes 
INNER JOIN diretores ON filmes.diretor_id = diretores.id;
```
*   **Resultado esperado:** (Lista de 11 filmes que possuem diretor mapeado, excluindo "Metropolis" que tem diretor NULL).

### Resposta 10
```sql
SELECT atores.nome, elenco.papel 
FROM atores 
LEFT JOIN elenco ON atores.id = elenco.ator_id;
```
*   **Resultado esperado:** (Lista de todos os 13 atores cadastrados, mostrando seus respectivos papéis. Observe que "Tom Hanks" e "Clint Eastwood" aparecerão com o papel igual a `NULL`).

### Resposta 11
```sql
SELECT filmes.titulo, diretores.nome 
FROM filmes 
FULL JOIN diretores ON filmes.diretor_id = diretores.id;
```
*   **Resultado esperado:** (Lista contendo todos os filmes com seus respectivos diretores, exibindo "Metropolis" com o diretor `NULL`, além de "Akira Kurosawa" e "Clint Eastwood" com títulos de filmes `NULL`).

### Resposta 12
```sql
SELECT nome FROM atores
INTERSECT
SELECT nome FROM diretores;
```
*   **Resultado esperado:**
    ```text
    Clint Eastwood
    Greta Gerwig
    Jordan Peele
    ```

### Resposta 13
```sql
SELECT 'Ator' AS profissao, nome FROM atores
UNION
SELECT 'Diretor' AS profissao, nome FROM diretores;
```
*   **Resultado esperado:** (Lista de 22 linhas mapeando de forma unificada os profissionais com suas respectivas profissões no banco).

### Resposta 14
```sql
SELECT nome FROM diretores
EXCEPT
SELECT nome FROM atores;
```
*   **Resultado esperado:**
    ```text
    Akira Kurosawa
    Bong Joon Ho
    Christopher Nolan
    Denis Villeneuve
    Quentin Tarantino
    Steven Spielberg
    ```

### Resposta 15
```sql
SELECT f.titulo, ROUND(AVG(a.nota), 2) AS media
FROM avaliacoes a
JOIN filmes f ON a.filme_id = f.id
GROUP BY f.id
HAVING media > 8.0
ORDER BY media DESC;
```
*   **Resultado esperado:**
    ```text
    Metropolis     | 10.0
    Parasite       | 9.88
    Pulp Fiction   | 9.83
    Jaws           | 9.33
    Get Out        | 9.25
    Inception      | 9.17
    Jurassic Park  | 9.0
    Lady Bird      | 8.83
    Dune           | 8.67
    Interstellar   | 8.67
    ```

</details>

---

Parabéns por concluir seu estudo! Continue praticando para dominar o poder das consultas relacionais.

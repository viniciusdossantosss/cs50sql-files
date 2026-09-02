# Novos Exercícios Práticos de SQL: Banco de Dados de Músicas (`songs.db`)

Para ajudar você a praticar e consolidar os conceitos de consulta a bancos de dados apresentados na **Aula 0 do CS50 SQL**, criamos um cenário totalmente novo! 

Neste cenário, você trabalhará com um banco de dados chamado `songs.db` que possui apenas uma única tabela chamada **`tracks`** (músicas). Esta tabela contém 60 faixas de áudio que misturam sucessos mundiais de pop, rock, rap, R&B, eletrônica, jazz, músicas latinas e singles recentes.

---

## 📊 Estrutura da Tabela `tracks`

A tabela `tracks` possui as seguintes colunas para você explorar:

| Coluna | Tipo de Dado | Descrição |
| :--- | :--- | :--- |
| `id` | `INTEGER` | Identificador único e chave primária da música. |
| `title` | `TEXT` | O título da música. |
| `artist` | `TEXT` | O nome do artista ou banda. |
| `album` | `TEXT` | O nome do álbum. Se a música for um *single* lançado sem álbum, o valor será `NULL` (nulo). |
| `genre` | `TEXT` | O gênero musical (ex: Pop, Rock, Hip Hop, Electronic, Latin, Jazz). Algumas músicas não possuem gênero definido (`NULL`). |
| `release_year` | `INTEGER` | O ano de lançamento da música. |
| `duration_seconds` | `INTEGER` | A duração da música em segundos. |
| `popularity` | `INTEGER` | A pontuação de popularidade da música no Spotify (escala de 0 a 100). |
| `tempo_bpm` | `INTEGER` | O andamento/tempo da música medido em batidas por minuto (BPM). |
| `explicit` | `INTEGER` | Indica se a letra da música é explícita: `1` para Sim, `0` para Não. |

---

## 🛠️ Como usar este Banco de Dados no SQLite

Se você estiver em seu terminal ou no VS Code local com o SQLite instalado:
1. Abra o arquivo do banco de dados:
   ```bash
   sqlite3 songs.db
   ```
2. Digite suas consultas utilizando letras maiúsculas para as palavras-chave do SQL e termine sempre com um ponto e vírgula (`;`).
3. Limpe a tela do console a qualquer momento usando o atalho `Ctrl + L`.
4. Saia do console do SQLite digitando `.quit`.

---

## 📋 Lista de Exercícios de Dificuldade Progressiva

---

### 🟢 Nível Fácil (Exercícios 1 a 5)

Estes exercícios cobrem o básico de seleção, limitação de resultados e filtros simples.

#### Exercício 1: Visão Geral das Músicas
* **Enunciado**: Selecione o título (`title`) e o artista (`artist`) de todas as músicas cadastradas na tabela.
* **Dica**: Utilize as palavras-chave fundamentais `SELECT` e `FROM`.
* **Solução**:
  ```sql
  SELECT title, artist FROM tracks;
  ```

#### Exercício 2: Lançamentos Específicos
* **Enunciado**: Selecione apenas os títulos (`title`) das músicas que foram lançadas exatamente no ano de `2022`.
* **Dica**: Use a cláusula `WHERE` para filtrar por uma igualdade numérica. Números não precisam de aspas!
* **Solução**:
  ```sql
  SELECT title FROM tracks WHERE release_year = 2022;
  ```

#### Exercício 3: Espiadinha Inicial
* **Enunciado**: Selecione os títulos (`title`) das primeiras `5` músicas inseridas na tabela `tracks` para testar se os dados estão corretos.
* **Dica**: Use o limite de exibição com a palavra-chave `LIMIT`.
* **Solução**:
  ```sql
  SELECT title FROM tracks LIMIT 5;
  ```

#### Exercício 4: Exclusão de Gêneros
* **Enunciado**: Selecione o título (`title`), o artista (`artist`) e o gênero (`genre`) de todas as músicas cujo gênero **não** seja `'Pop'`.
* **Dica**: Você pode usar os operadores de desigualdade `!=` ou `<>`. Lembre-se de colocar strings de texto entre aspas simples (`'Pop'`). *(Dica extra: no SQL padrão, valores nulos no gênero são omitidos nessa comparação, o que é o comportamento esperado aqui).*
* **Solução**:
  ```sql
  SELECT title, artist, genre FROM tracks WHERE genre != 'Pop';
  ```

#### Exercício 5: Músicas Iniciadas com Artigo
* **Enunciado**: Encontre o título (`title`) de todas as músicas que começam especificamente com as letras `'The '` seguidas de um espaço.
* **Dica**: Use o operador de correspondência parcial `LIKE` com o símbolo de porcentagem `%` logo após a palavra desejada.
* **Solução**:
  ```sql
  SELECT title FROM tracks WHERE title LIKE 'The %';
  ```

---

### 🟡 Nível Médio (Exercícios 6 a 10)

Estes exercícios envolvem operadores lógicos mais avançados (`AND`, `OR`), busca por valores nulos, intervalos e ordenação básica.

#### Exercício 6: Uma Era de Ouro Musical
* **Enunciado**: Encontre os títulos (`title`) e os anos de lançamento (`release_year`) de todas as músicas lançadas no intervalo de anos de `2010` a `2015` (inclusive).
* **Dica**: Em vez de fazer múltiplos filtros com `OR`, use o operador de intervalo inclusivo `BETWEEN ... AND ...`.
* **Solução**:
  ```sql
  SELECT title, release_year FROM tracks WHERE release_year BETWEEN 2010 AND 2015;
  ```

#### Exercício 7: Buscando o Amor
* **Enunciado**: Encontre os títulos (`title`) e os artistas (`artist`) de todas as músicas que possuam a palavra `'love'` em qualquer posição do título (início, meio ou fim), de forma insensível a maiúsculas/minúsculas.
* **Dica**: Use `LIKE` com o caractere curinga `%` antes e depois do termo procurado (`'%love%'`). Lembre-se de que o operador `LIKE` no SQLite é, por padrão, insensível ao caso!
* **Solução**:
  ```sql
  SELECT title, artist FROM tracks WHERE title LIKE '%love%';
  ```

#### Exercício 8: Caçando os *Singles* lançados
* **Enunciado**: Liste o título (`title`) e o artista (`artist`) de todas as músicas que foram lançadas como *singles* isolados, ou seja, aquelas cujo campo de álbum (`album`) está vazio/ausente no banco de dados.
* **Dica**: Valores vazios em bancos de dados são representados como `NULL`. Para verificar a ausência de valor, use o operador condicional `IS NULL`.
* **Solução**:
  ```sql
  SELECT title, artist FROM tracks WHERE album IS NULL;
  ```

#### Exercício 9: Curtas e Populares
* **Enunciado**: Selecione o título (`title`), o artista (`artist`), a popularidade (`popularity`) e a duração (`duration_seconds`) das músicas que possuem uma popularidade estritamente **maior que 85** e uma duração **menor que 200 segundos** (3 minutos e 20 segundos).
* **Dica**: Combine múltiplos critérios de filtragem na cláusula `WHERE` usando o operador lógico `AND`.
* **Solução**:
  ```sql
  SELECT title, artist, popularity, duration_seconds 
  FROM tracks 
  WHERE popularity > 85 AND duration_seconds < 200;
  ```

#### Exercício 10: Batidas Aceleradas por Minuto
* **Enunciado**: Selecione o título (`title`) e o andamento (`tempo_bpm`) de todas as músicas com ritmo acelerado (andamento acima de `120` batidas por minuto - BPM), organizando as linhas retornadas do andamento mais lento para o mais rápido.
* **Dica**: Use a cláusula `ORDER BY` combinada com a ordenação crescente padrão (`ASC`) ao final de sua consulta.
* **Solução**:
  ```sql
  SELECT title, tempo_bpm 
  FROM tracks 
  WHERE tempo_bpm > 120 
  ORDER BY tempo_bpm ASC;
  ```

---

### 🔴 Nível Difícil (Exercícios 11 a 15)

Estes exercícios exigem o uso de funções agregadas (`AVG`, `SUM`, `MIN`, `MAX`, `COUNT`), arredondamentos, apelidos de colunas (`AS`), remoção de duplicatas (`DISTINCT`) e múltiplos critérios de ordenação combinados.

#### Exercício 11: A Média das Faixas
* **Enunciado**: Calcule a duração média (em segundos) de todas as músicas cadastradas no banco de dados. O resultado deve ser arredondado para exatamente `2` casas decimais e a coluna resultante deve se chamar `duracao_media`.
* **Dica**: Combine a função agregada de média `AVG()` dentro de uma função de arredondamento `ROUND(..., 2)`. Para renomear a coluna de cabeçalho no resultado final, use a palavra-chave `AS`.
* **Solução**:
  ```sql
  SELECT ROUND(AVG(duration_seconds), 2) AS duracao_media FROM tracks;
  ```

#### Exercício 12: Extremos do Rock
* **Enunciado**: Descubra qual é a maior pontuação de popularidade e a menor pontuação de popularidade entre todas as músicas classificadas sob o gênero `'Rock'`. Nomeie as colunas de saída como `max_pop` e `min_pop`, respectivamente.
* **Dica**: Utilize as funções agregadas de valor extremo `MAX()` e `MIN()` em um único `SELECT`, adicionando um filtro para o gênero no `WHERE`.
* **Solução**:
  ```sql
  SELECT MAX(popularity) AS max_pop, MIN(popularity) AS min_pop 
  FROM tracks 
  WHERE genre = 'Rock';
  ```

#### Exercício 13: Variedade Musical
* **Enunciado**: Descubra a quantidade total de gêneros musicais distintos e válidos (não nulos) cadastrados no banco de dados. Dê o nome de `total_generos` à coluna de resposta.
* **Dica**: Use a função agregada `COUNT()` contendo o modificador de valores exclusivos `DISTINCT` aplicado à coluna `genre`.
* **Solução**:
  ```sql
  SELECT COUNT(DISTINCT genre) AS total_generos FROM tracks;
  ```

#### Exercício 14: Maratona Swiftie
* **Enunciado**: Calcule a soma total de tempo (em segundos) necessário para ouvir todas as músicas cadastradas da artista `'Taylor Swift'`. Nomeie a coluna de saída como `tempo_total_taylor`.
* **Dica**: Use a função de soma agregada `SUM()` e aplique o filtro de igualdade de texto sobre a coluna `artist`.
* **Solução**:
  ```sql
  SELECT SUM(duration_seconds) AS tempo_total_taylor 
  FROM tracks 
  WHERE artist = 'Taylor Swift';
  ```

#### Exercício 15: O Ranking dos Últimos Anos
* **Enunciado**: Selecione o título (`title`), o artista (`artist`), a popularidade (`popularity`) e o ano de lançamento (`release_year`) de todas as músicas lançadas especificamente nos anos de `2021` ou `2022`. Os resultados devem ser ordenados de forma que as músicas mais populares apareçam primeiro (ordem decrescente de popularidade). Caso haja empate em popularidade, ordene as músicas empatadas pelo título em ordem alfabética convencional (crescente). Limite o resultado final aos `5` primeiros registros do ranking.
* **Dica**: Use a cláusula `WHERE` combinada com o operador `IN (2021, 2022)`. Na cláusula `ORDER BY`, passe a primeira coluna de ordenação com o modificador `DESC` e, em seguida, uma vírgula `,` para definir o critério de desempate de forma padrão ou com `ASC`.
* **Solução**:
  ```sql
  SELECT title, artist, popularity, release_year 
  FROM tracks 
  WHERE release_year IN (2021, 2022) 
  ORDER BY popularity DESC, title ASC 
  LIMIT 5;
  ```

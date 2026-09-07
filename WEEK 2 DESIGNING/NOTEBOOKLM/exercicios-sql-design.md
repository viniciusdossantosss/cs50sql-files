# Exercícios Práticos de SQL: Design de Banco de Dados e Normalização

Bem-vindo(a) à sua lista de exercícios práticos! Para que você possa consolidar e praticar todos os conceitos apresentados na aula — incluindo a criação de tabelas, tipos de dados, afinidades, restrições de tabelas e colunas, comandos de alteração (`ALTER TABLE`), remoção (`DROP TABLE`) e normalização — criamos um cenário inédito focado em **Missões Espaciais (StarVoyage)**.

---

## 🚀 O Cenário: Banco de Dados "StarVoyage"

Você foi contratado(a) como Engenheiro(a) de Banco de Dados pela **StarVoyage**, uma agência aeroespacial fictícia que monitora missões interplanetárias. O seu objetivo é construir e refinar o banco de dados `starvoyage.db` para gerenciar com precisão as naves, astronautas e as missões que exploram o cosmos, evitando redundâncias e garantindo a integridade dos dados através de restrições rígidas.

---

## 📝 Lista de Exercícios (15 Questões de Dificuldade Progressiva)

### Nível: Fácil (Criação Básica, Tipos e Restrições Simples)

#### Questão 1: Criando a Primeira Nave
Crie uma tabela simples chamada `spacecraft` utilizando comandos SQL compatíveis com o SQLite. A tabela deve conter inicialmente duas colunas:
- `id` do tipo `INTEGER`.
- `name` do tipo `TEXT`.

#### Questão 2: Garantindo a Identidade da Nave
Toda nave precisa ter um nome. Modifique ou reescreva o comando de criação da tabela `spacecraft` adicionando a restrição de coluna `NOT NULL` à coluna `name`, garantindo que nenhuma nave seja cadastrada sem nome.

#### Questão 3: Definindo uma Capacidade Padrão
Adicione uma coluna chamada `capacity` (capacidade de tripulantes) à tabela `spacecraft`. Ela deve ter a afinidade de tipo `INTEGER`. Adicione uma restrição `DEFAULT` para que, caso a capacidade não seja informada, o sistema defina o valor padrão como `4`.

#### Questão 4: Filtrando Status com CHECK
Crie a tabela `astronauts` para registrar os astronautas. Ela deve conter as colunas:
- `id` (`INTEGER`)
- `name` (`TEXT`, não nulo)
- `status` (`TEXT`)
Adicione uma restrição de coluna `CHECK` na coluna `status` para garantir que ela só aceite os valores: `'Ativo'`, `'Aposentado'` ou `'Em Treinamento'`.

#### Questão 5: Emails Únicos
Adicione uma coluna chamada `email` (`TEXT`) na tabela `astronauts`. Aplique as restrições necessárias para garantir que o preenchimento do e-mail seja obrigatório (`NOT NULL`) e que nenhum astronauta tenha o mesmo e-mail que outro (`UNIQUE`).

---

### Nível: Médio (Relacionamentos, Chaves e Alteração de Tabelas)

#### Questão 6: Declarando Chaves Primárias Explícitas
Utilizando a convenção de restrições de tabela aprendida em aula, reescreva a definição das tabelas `spacecraft` e `astronauts` declarando explicitamente a coluna `id` como `PRIMARY KEY` na seção de restrições de tabela (no final da instrução).

#### Questão 7: Vinculando a Missão à Nave (Chave Estrangeira)
Crie uma tabela chamada `missions` com as seguintes colunas:
- `id` (`INTEGER`, chave primária)
- `name` (`TEXT`, não nulo, único)
- `destination` (`TEXT`, não nulo)
- `spacecraft_id` (`INTEGER`)
Adicione uma restrição de tabela de chave estrangeira (`FOREIGN KEY`) que conecte a coluna `spacecraft_id` à coluna `id` da tabela `spacecraft`.

#### Questão 8: A Tabela de Junção (Relacionamento Muitos-para-Muitos)
Uma missão pode conter vários astronautas e um astronauta pode participar de várias missões ao longo de sua carreira. Crie uma tabela de junção (associativa) chamada `mission_crew` com as seguintes características:
- `mission_id` (`INTEGER`)
- `astronaut_id` (`INTEGER`)
- Duas restrições de chave estrangeira apontando para as respectivas tabelas parentes (`missions` e `astronauts`).

#### Questão 9: Alterando a Tabela de Missões
A agência StarVoyage percebeu que esqueceu de registrar as datas de lançamento. Use o comando `ALTER TABLE` para adicionar a coluna `launch_date` (tipo de afinidade `NUMERIC`) à tabela `missions`. Defina o valor padrão (`DEFAULT`) como o marcador de tempo atual do SQLite (`current_timestamp`).

#### Questão 10: Corrigindo Erros de Digitação
Suponha que, ao criar a tabela `spacecraft`, você digitou incorretamente o nome da coluna de identificação do fabricante como `fabricator_idd`. Use o comando `ALTER TABLE` com a instrução `RENAME COLUMN` para corrigir o nome da coluna para `fabricator_id`.

---

### Nível: Avançado (Restrições Complexas, Engenharia de Design e Afinidades)

#### Questão 11: Chaves Compostas vs. IDs de Linha (rowid)
Na tabela de junção `mission_crew` (criada na Questão 8), podemos usar uma **chave primária composta** para garantir que um mesmo astronauta não seja adicionado duas vezes à mesma missão. 
1. Reescreva a instrução `CREATE TABLE` de `mission_crew` para implementar uma chave primária composta formada por `(mission_id, astronaut_id)`.
2. Explique em quais cenários essa abordagem seria inadequada em comparação a criar uma coluna de ID dedicada (`id INTEGER PRIMARY KEY`).

#### Questão 12: Regras de Validação com CHECK de Expressão
A agência StarVoyage estabeleceu uma regra: nenhuma nave pode ter capacidade de tripulantes (`capacity`) igual a zero ou negativa, e o orçamento de uma missão (`budget`, tipo `REAL`) deve ser estritamente maior que zero.
1. Escreva uma restrição `CHECK` para a coluna `capacity` de `spacecraft` garantindo que ela seja estritamente positiva (`> 0`).
2. Crie ou altere a tabela `missions` para incluir a coluna `budget` com uma restrição `CHECK` que assegure que o valor seja sempre positivo.

#### Questão 13: O Desafio das Afinidades do SQLite
O SQLite lida com tipos de dados usando "afinidades de tipo" em vez de tipos estáticos rígidos. Considere uma coluna `serial_number` configurada com a afinidade `INTEGER`.
Explique o que o SQLite fará fisicamente nos seguintes cenários de inserção:
1. Você insere o valor de texto `'98765'`.
2. Você insere o valor de texto `'Apollo11'`.
3. Você insere o valor real `12.00`.

#### Questão 14: Evitando Registros Órfãos (Comportamento de DROP e FK)
Por padrão, o SQLite não ativa a verificação de chaves estrangeiras de forma automática em todas as conexões (sendo necessário ativar usando `PRAGMA foreign_keys = ON;`). 
Se as chaves estrangeiras estiverem ativadas e você tentar executar o comando `DROP TABLE spacecraft`, o que acontecerá se houver missões associadas a naves na tabela `missions`? Como você solucionaria isso sem deixar dados inconsistentes (órfãos)?

#### Questão 15: Desafio de Normalização (Do Caos à Ordem)
Uma planilha desorganizada da agência continha a seguinte estrutura unificada para registrar as viagens cósmicas:

| ID_Voo | Nome_Astronauta | Planeta_Destino | Nome_Nave | Linha_Propulsor | Combustivel_Gasto |
|--------|-----------------|-----------------|-----------|-----------------|-------------------|
| 1      | Neil            | Marte           | Odyssey   | Químico         | 15000L            |
| 2      | Buzz            | Marte           | Odyssey   | Químico         | 15000L            |
| 3      | Neil            | Júpiter         | Explorer  | Iônico          | 45000L            |

Analise as redundâncias e responda:
1. Quais são as entidades distintas presentes nessa tabela desnormalizada?
2. Projete as instruções de `CREATE TABLE` normalizadas e completas em SQL (incluindo chaves primárias, estrangeiras e tipos/afinidades corretos) para armazenar esses dados sem qualquer redundância de texto.

---

## 🗝️ Gabarito e Orientações de Resposta

*(Não olhe as respostas antes de tentar resolver os exercícios no terminal SQLite!)*

<details>
<summary><b>Clique para expandir o Gabarito com as Resoluções Sugeridas</b></summary>

### Resolução da Questão 1
```sql
CREATE TABLE spacecraft (
    id INTEGER,
    name TEXT
);
```

### Resolução da Questão 2
```sql
CREATE TABLE spacecraft (
    id INTEGER,
    name TEXT NOT NULL
);
```

### Resolução da Questão 3
```sql
CREATE TABLE spacecraft (
    id INTEGER,
    name TEXT NOT NULL,
    capacity INTEGER DEFAULT 4
);
```

### Resolução da Questão 4
```sql
CREATE TABLE astronauts (
    id INTEGER,
    name TEXT NOT NULL,
    status TEXT CHECK (status IN ('Ativo', 'Aposentado', 'Em Treinamento'))
);
```

### Resolução da Questão 5
```sql
CREATE TABLE astronauts (
    id INTEGER,
    name TEXT NOT NULL,
    status TEXT CHECK (status IN ('Ativo', 'Aposentado', 'Em Treinamento')),
    email TEXT NOT NULL UNIQUE
);
```

### Resolução da Questão 6
```sql
-- Para spacecraft:
CREATE TABLE spacecraft (
    id INTEGER,
    name TEXT NOT NULL,
    capacity INTEGER DEFAULT 4,
    PRIMARY KEY (id)
);

-- Para astronauts:
CREATE TABLE astronauts (
    id INTEGER,
    name TEXT NOT NULL,
    status TEXT CHECK (status IN ('Ativo', 'Aposentado', 'Em Treinamento')),
    email TEXT NOT NULL UNIQUE,
    PRIMARY KEY (id)
);
```

### Resolução da Questão 7
```sql
CREATE TABLE missions (
    id INTEGER,
    name TEXT NOT NULL UNIQUE,
    destination TEXT NOT NULL,
    spacecraft_id INTEGER,
    PRIMARY KEY (id),
    FOREIGN KEY (spacecraft_id) REFERENCES spacecraft(id)
);
```

### Resolução da Questão 8
```sql
CREATE TABLE mission_crew (
    mission_id INTEGER,
    astronaut_id INTEGER,
    FOREIGN KEY (mission_id) REFERENCES missions(id),
    FOREIGN KEY (astronaut_id) REFERENCES astronauts(id)
);
```

### Resolução da Questão 9
```sql
ALTER TABLE missions ADD COLUMN launch_date NUMERIC DEFAULT current_timestamp;
```

### Resolução da Questão 10
*Nota: Para simular o erro, imagine que criamos a tabela com `fabricator_idd`. Corrigimos usando:*
```sql
ALTER TABLE spacecraft RENAME COLUMN fabricator_idd TO fabricator_id;
```

### Resolução da Questão 11
1. **Instrução SQL com Chave Composta:**
```sql
CREATE TABLE mission_crew (
    mission_id INTEGER,
    astronaut_id INTEGER,
    PRIMARY KEY (mission_id, astronaut_id),
    FOREIGN KEY (mission_id) REFERENCES missions(id),
    FOREIGN KEY (astronaut_id) REFERENCES astronauts(id)
);
```
2. **Explicação:** Uma chave primária composta `(mission_id, astronaut_id)` é inadequada se precisarmos registrar o mesmo astronauta participando múltiplas vezes da mesma missão em funções ou períodos diferentes. Nesse caso, um ID único sequencial (`id INTEGER PRIMARY KEY`) seria melhor para permitir duplicatas de pares, usando outras colunas como timestamp ou cargo para diferenciá-las.

### Resolução da Questão 12
1. **CHECK em spacecraft:**
```sql
CREATE TABLE spacecraft (
    id INTEGER,
    name TEXT NOT NULL,
    capacity INTEGER DEFAULT 4 CHECK (capacity > 0),
    PRIMARY KEY (id)
);
```
2. **CREATE TABLE de missions com budget positivo:**
```sql
CREATE TABLE missions (
    id INTEGER,
    name TEXT NOT NULL UNIQUE,
    destination TEXT NOT NULL,
    budget REAL CHECK (budget > 0),
    spacecraft_id INTEGER,
    PRIMARY KEY (id),
    FOREIGN KEY (spacecraft_id) REFERENCES spacecraft(id)
);
```

### Resolução da Questão 13
1. **Inserção de `'98765'`:** O SQLite tentará converter a string para inteiro devido à afinidade `INTEGER`. Como `'98765'` contém apenas dígitos numéricos válidos, ele será convertido e armazenado fisicamente como o número inteiro `98765`.
2. **Inserção de `'Apollo11'`:** O SQLite tentará fazer a conversão, mas como a string contém caracteres não numéricos (`'Apollo'`), a conversão falhará. Por ser flexível, o SQLite armazenará o valor exatamente como o texto `'Apollo11'`.
3. **Inserção do real `12.00`:** O SQLite identificará que o número real não possui parte fracionária significativa (`.00`) e o converterá de forma limpa para o inteiro correspondente `12`.

### Resolução da Questão 14
Se `PRAGMA foreign_keys = ON;` estiver ativo, o SQLite impedirá a remoção da tabela `spacecraft` (ou lançará erros ao tentar modificar registros que violam a integridade) se houver dados correspondentes ativos. Para solucionar de forma consistente e limpa, primeiro você deve excluir ou modificar os registros dependentes na tabela filha (`missions`) que referenciam as naves que deseja excluir, ou garantir que a definição da chave estrangeira utilize regras como `ON DELETE CASCADE` ou `ON DELETE SET NULL` (caso seu SGBD suporte plenamente), limpando as referências antes de derrubar as tabelas principais.

### Resolução da Questão 15
1. **Entidades identificadas:** Astronautas (`astronauts`), Missões (`missions`), Naves (`spacecraft`) e o relacionamento histórico da tripulação (`mission_crew`). O Combustível e propulsor estão associados às missões ou às naves. Assumindo que a propulsão é característica da nave e o combustível gasto é característico do voo/missão:
2. **Modelagem Normalizada:**
```sql
-- 1. Naves
CREATE TABLE spacecraft (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    propulsion_type TEXT NOT NULL CHECK (propulsion_type IN ('Químico', 'Iônico', 'Nuclear'))
);

-- 2. Astronautas
CREATE TABLE astronauts (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

-- 3. Missões
CREATE TABLE missions (
    id INTEGER PRIMARY KEY,
    destination TEXT NOT NULL,
    fuel_consumption REAL NOT NULL CHECK (fuel_consumption > 0),
    spacecraft_id INTEGER,
    FOREIGN KEY (spacecraft_id) REFERENCES spacecraft(id)
);

-- 4. Tripulação da Missão (Tabela de Junção)
CREATE TABLE mission_crew (
    mission_id INTEGER,
    astronaut_id INTEGER,
    PRIMARY KEY (mission_id, astronaut_id),
    FOREIGN KEY (mission_id) REFERENCES missions(id),
    FOREIGN KEY (astronaut_id) REFERENCES astronauts(id)
);
```

</details>

---

## 🛠️ Como Praticar no Terminal do Computador

Para praticar em tempo real com o SQLite:
1. Abra o terminal do seu sistema.
2. Inicie um banco de dados novo digitando:
   ```bash
   sqlite3 starvoyage.db
   ```
3. Crie um arquivo de texto chamado `schema.sql` e cole os comandos de criação.
4. Dentro do prompt do SQLite, execute:
   ```sql
   .read schema.sql
   ```
5. Para verificar as tabelas criadas e suas restrições, use:
   ```sql
   .schema
   ```
6. Ative a exibição em modo tabela para as futuras consultas:
   ```sql
   .mode table
   ```

Bons estudos e boa jornada rumo às estrelas da engenharia de dados! 🌌

CREATE TABLE bronze_netflix(
   	show_id      VARCHAR(5) NOT NULL PRIMARY KEY,
	type         VARCHAR(7) NOT NULL,
  	title        VARCHAR(104) NOT NULL,
  	director     VARCHAR(208),
  	desc_cast    VARCHAR(771),
  	country      VARCHAR(123),
	date_added   VARCHAR(19),
  	release_year VARCHAR(6) NOT NULL,
 	rating       VARCHAR(8),
  	duration     VARCHAR(10),
  	listed_in    VARCHAR(79) NOT NULL,
  	description  VARCHAR(248) NOT NULL
);

SELECT * FROM bronze_netflix;

COPY bronze_netflix(show_id,type,title,director,desc_cast,country,date_added,release_year,rating,duration,listed_in,description)
FROM '/home/silas/Documentos/Desenvolve_Isabel/Challenge_01/netflix_export.csv'
DELIMITER ';'
ENCODING 'UTF8'
CSV HEADER;

SELECT * FROM PUBLIC.bronze_netflix;

--criando uma cópia da tabela
CREATE TABLE prata_netflix AS
SELECT *
FROM bronze_netflix;

SELECT * FROM PUBLIC.prata_netflix;

--substituindo espaços em branco por 'Desconhecido'
UPDATE prata_netflix SET director = 'Desconhecido'
WHERE director = '';

UPDATE prata_netflix SET country = 'Desconhecido'
WHERE country = '';

UPDATE prata_netflix SET cast_desc = 'Desconhecido'
WHERE cast_desc = '';

--mudando o tamanho campo
ALTER TABLE prata_netflix
ALTER COLUMN description TYPE varchar(120);

--removendo caracteres acima de 120
UPDATE prata_netflix
SET description = LEFT(description, 120)
WHERE LENGTH(description) > 120;

SELECT description FROM prata_netflix;

--removendo caractere "s" 
UPDATE prata_netflix
SET show_id = REPLACE(show_id, 's', '');

--transformando campo show_id
ALTER TABLE prata_netflix
ALTER COLUMN show_id TYPE INTEGER
USING show_id::INTEGER;

--substituindo valores vazios de release_year
UPDATE prata_netflix SET release_year = '9999'
WHERE release_year = '';

-- NÃO TEM VALORES NULOS EM RELEASE_YEAR
SELECT release_year FROM prata_netflix
WHERE release_year = 9999;

--transformando campo release_year
ALTER TABLE prata_netflix
ALTER COLUMN release_year TYPE INTEGER
USING release_year::INTEGER;

-----------------------------------------------------------------
--Desafio 2--

--Criando Tabela ouro_netflix_relatorio_ano_lancamento --
CREATE TABLE ouro_netflix_relatorio_ano_lancamento AS
   SELECT release_year AS ano_lancamento, COUNT(*) AS qtd_titulos
     FROM prata_netflix
 GROUP BY release_year
 ORDER BY 1 DESC;
 
SELECT * FROM ouro_netflix_relatorio_ano_lancamento;

CREATE TABLE ouro_netflix_seriados AS
	  SELECT * FROM prata_netflix WHERE type = 'TV Show'
	ORDER BY release_year, title;

---------------------------------------------------------------------------

-- criando tabela ouro_netflix_seriados --
SELECT * FROM ouro_netflix_seriados;

CREATE TABLE ouro_netflix_filmes AS
	  SELECT * FROM prata_netflix WHERE type = 'Movie'
	ORDER BY release_year, title;

SELECT * FROM ouro_netflix_filmes;

--------------------------------------------------------------------------
--teste--
   SELECT type descricao_tipo,
   		  country nome_pais_origem,
		  rating categoria_classificacao_indicativa,
		  release_year ano_lancamento,
     FROM prata_netflix
 GROUP BY release_year
 ORDER BY ano_lancamento DESC, descricao_tipo, nome_pais_origem, qtd_titulos DESC;

------------------------------------------------------------------------------------------

 -- criando tabela ouro_netflix_relatorio_titulos --
 
 --teste--

  SELECT ouro_netflix_relatorio_ano_lancamento.ano_lancamento,
	     prata_netflix.type descricao_tipo,
	     prata_netflix.country nome_pais_origem,
	     prata_netflix.rating categoria_classificacao_indicativa,
	     ouro_netflix_relatorio_ano_lancamento.qtd_titulos
    FROM prata_netflix
    JOIN ouro_netflix_relatorio_ano_lancamento ON ouro_netflix_relatorio_ano_lancamento.ano_lancamento = prata_netflix.release_year
ORDER BY ano_lancamento DESC, descricao_tipo, nome_pais_origem, qtd_titulos DESC;

-- Tabela criada --
CREATE TABLE ouro_netflix_relatorio_titulos AS
  SELECT prata_netflix.release_year ano_lancamento,
	     prata_netflix.type descricao_tipo,
	     prata_netflix.country nome_pais_origem,
	     prata_netflix.rating categoria_classificacao_indicativa,
	     COUNT(*) qtd_titulos
    FROM prata_netflix
GROUP BY release_year, type, country, rating
ORDER BY ano_lancamento DESC, descricao_tipo, nome_pais_origem, qtd_titulos DESC;

SELECT * FROM ouro_netflix_relatorio_titulos;

--teste--
SELECT * FROM prata_netflix
WHERE release_year = 2021
AND type = 'Movie'
AND country = 'Spain'
AND rating = 'TV-MA';

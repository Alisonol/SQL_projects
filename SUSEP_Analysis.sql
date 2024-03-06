# Schema para criação da tabela 
	# Ressalto que no excel, foram substituídos valores ausentes pela string NULL, de modo que
    # o mysql reconhece como null e poderei seguir com as análises de modo mais eficaz
    
# Implementação do modelo lógico dimensional
    
-- Tabela dados_historicos 
DROP TABLE IF EXISTS dimensional.dados_historicos;
CREATE TABLE dimensional.dados_historicos (
    ano INT NULL,
    id_categoria INT NULL,
    id_sexo_condutor INT NULL,
    id_faixa_etaria INT,
    is_media_valor INT NULL,
    expostos INT NULL,
    premio_medio_valor INT NULL,
    freq_sinistro INT NULL,
    indice_sinistralidade_perc DECIMAL(10, 2) NULL,
    freq_incendio_e_roubo_perc DECIMAL(10, 2) NULL,
    freq_incendio_e_roubo INT NULL,
    indeniz_incendio_e_roubo_valor INT NULL,
    freq_colisao INT NULL,
    indeniz_colisao_valor INT NULL,
    freq_outras INT NULL,
    indeniz_outras_valor INT NULL
);

-- Tabela categoria_tarifaria
DROP TABLE IF EXISTS dimensional.categoria_tarifaria;
CREATE TABLE dimensional.categoria_tarifaria (
	id_categoria INT NULL,
    categoria VARCHAR(50) NULL
);

-- Tabela faixa_etaria_condutor 
DROP TABLE IF EXISTS dimensional.faixa_etaria_condutor;
CREATE TABLE dimensional.faixa_etaria_condutor (
	id_faixa_etaria INT NULL,
    faixa_etaria VARCHAR(50) NULL
);

-- Tabela sexo_condutor_e
DROP TABLE IF EXISTS dimensional.sexo_condutor_e;
CREATE TABLE dimensional.sexo_condutor_e (
	id_sexo_condutor INT NULL,
    sexo_condutor VARCHAR(50)
);

# Sumarizando os dados a fim de checar se está compatível com os dados que temos no Excel

SELECT 
 SUM(ano) AS ano,
 SUM(id_categoria) AS id_categoria,
 SUM(id_sexo_condutor) AS id_sexo_condutor, 
 SUM(id_faixa_etaria) AS id_faixa_etaria, 
 SUM(is_media_valor) AS is_media_valor, 
 SUM(expostos) AS expostos, 
 SUM(premio_medio_valor) AS premio_medio_valor, 
 SUM(freq_sinistro) AS freq_sinistro, 
 SUM(indice_sinistralidade_perc) AS indice_sinistralidade_perc, 
 SUM(freq_incendio_e_roubo_perc) AS freq_incendio_e_roubo_perc,
 SUM(freq_incendio_e_roubo) AS freq_incendio_e_roubo,
 SUM(indeniz_incendio_e_roubo_valor) AS indeniz_incendio_e_roubo_valor,
 SUM(freq_colisao) AS freq_colisao,
 SUM(indeniz_colisao_valor) AS indeniz_colisao_valor,
 SUM(freq_outras) AS freq_outras,
 SUM(indeniz_outras_valor) AS indeniz_outras_valor
 FROM dimensional.dados_historicos;
 
 
# Análise Exploratória

-- Quantidade de registros
SELECT COUNT(is_media_valor) AS contagem_registros FROM dimensional.dados_historicos;

-- Como temos poucos registros, é possível visualizar dentro do próprio result grid que as únicas colunas com valores NULOS são indice_sinistralidade_perc e freq_incendio_e_roubo_perc.
-- Portanto, checarei a quantidade de valores nulos que temos para estas colunas. Como método, utilizarei as subqueries vide que os dados não são demasiadamente expressivos
SELECT 
    ROUND((SUM(CASE WHEN indice_sinistralidade_perc IS NULL THEN 1 ELSE 0 END) * 100.0)/ COUNT(*), 2) AS perc_nulos_sinistralidade
FROM 
    dimensional.dados_historicos;
    
/* Os resultado percentual de valores nulos para esta coluna é de 48.90 e, com base nas colocações da Data Science Academy - professor Daniel Mendes -, é recomendável deletar os valores,
cujo percentual está acima de 30%. Contudo... Pelo dataset conter poucos valores, o adequado a meu ver seria buscar o proprietário destes dados, pois possivelmente houvera um erro de inserção
destes valores. */ 

-- Checando os valores nulos para a coluna freq_incendio_e_roubo_perc
SELECT 
    ROUND((SUM(CASE WHEN freq_incendio_e_roubo_perc IS NULL THEN 1 ELSE 0 END) * 100.0)/ COUNT(*), 2) AS perc_nulos_freq_incen_roubos
FROM 
    dimensional.dados_historicos;
    
/* O resultado percentual de nulos está em 75.55, de modo que o percentual é expressivo. Porém, não realizaria a deleção vide os poucos registros contidos no dataset, de modo que, como 
abordagem, buscaria inicialmente o proprietário dos dados para o modo de inserção/cálculo destes valores */

/* A partir da visualização das colunas indice_sinistralidade_perc e freq_incendio_e_roubo_perc é possível visualmente encontrar valores discrepantes, de modo que seguirei com o cálculo de
estatísticas descritivas (medidas de variabilidade e tendência central) para entender se hão desvios, com vistas a teoria do limite central */
	-- OBS: As colunas analisadas serão: 
    -- is_media_valor,	expostos, premio_medio_valor, freq_sinistro, indice_sinistralidade_perc, 
    -- freq_incendio_e_roubo_perc, freq_incendio_e_roubo, indeniz_incendio_e_roubo_valor, freq_colisao, 
    -- indeniz_colisao_valor, freq_outras, indeniz_outras_valor


# Medidas de tendência central
-- Média, Mínimo, Máximo Moda e mediana

SELECT 
    -- Média
    AVG(is_media_valor) AS media_is_media_valor,
    AVG(expostos) AS media_expostos,
    AVG(premio_medio_valor) AS media_premio_medio_valor,
    AVG(freq_sinistro) AS media_freq_sinistro,
    AVG(indice_sinistralidade_perc) AS media_indice_sinistralidade_perc,
    AVG(freq_incendio_e_roubo_perc) AS media_freq_incendio_e_roubo_perc,
    AVG(freq_incendio_e_roubo) AS media_freq_incendio_e_roubo,
    AVG(indeniz_incendio_e_roubo_valor) AS media_indeniz_incendio_e_roubo_valor,
    AVG(freq_colisao) AS media_freq_colisao,
    AVG(indeniz_colisao_valor) AS media_indeniz_colisao_valor,
    AVG(freq_outras) AS media_freq_outras,
    AVG(indeniz_outras_valor) AS media_indeniz_outras_valor,
    
        -- Valor mínimo
    MIN(is_media_valor) AS min_is_media_valor,
    MIN(expostos) AS min_expostos,
    MIN(premio_medio_valor) AS min_premio_medio_valor,
    MIN(freq_sinistro) AS min_freq_sinistro,
    MIN(indice_sinistralidade_perc) AS min_indice_sinistralidade_perc,
    MIN(freq_incendio_e_roubo_perc) AS min_freq_incendio_e_roubo_perc,
    MIN(freq_incendio_e_roubo) AS min_freq_incendio_e_roubo,
    MIN(indeniz_incendio_e_roubo_valor) AS min_indeniz_incendio_e_roubo_valor,
    MIN(freq_colisao) AS min_freq_colisao,
    MIN(indeniz_colisao_valor) AS min_indeniz_colisao_valor,
    MIN(freq_outras) AS min_freq_outras,
    MIN(indeniz_outras_valor) AS min_indeniz_outras_valor,
    
    -- Valor máximo
    MAX(is_media_valor) AS max_is_media_valor,
    MAX(expostos) AS max_expostos,
    MAX(premio_medio_valor) AS max_premio_medio_valor,
    MAX(freq_sinistro) AS max_freq_sinistro,
    MAX(indice_sinistralidade_perc) AS max_indice_sinistralidade_perc,
    MAX(freq_incendio_e_roubo_perc) AS max_freq_incendio_e_roubo_perc,
    MAX(freq_incendio_e_roubo) AS max_freq_incendio_e_roubo,
    MAX(indeniz_incendio_e_roubo_valor) AS max_indeniz_incendio_e_roubo_valor,
    MAX(freq_colisao) AS max_freq_colisao,
    MAX(indeniz_colisao_valor) AS max_indeniz_colisao_valor,
    MAX(freq_outras) AS max_freq_outras,
    MAX(indeniz_outras_valor) AS max_indeniz_outras_valor

FROM 
    dimensional.dados_historicos;
    
-- Mediana

-- Calculando a Mediana

-- Mediana de indice_sinistralidade_perc

SELECT ROUND(AVG(middle_values), 2) AS 'mediana_indice_sinistralidade_perc'
FROM (
  SELECT t1.indice_sinistralidade_perc AS 'middle_values'
  FROM (
    SELECT @row:=@row+1 as `row`, x.indice_sinistralidade_perc
    FROM dimensional.dados_historicos AS x, (SELECT @row:=0) AS r
    WHERE x.indice_sinistralidade_perc IS NOT NULL
    ORDER BY x.indice_sinistralidade_perc
  ) AS t1,
  (
    SELECT COUNT(*) as 'count'
    FROM dimensional.dados_historicos x
    WHERE x.indice_sinistralidade_perc IS NOT NULL
  ) AS t2
  WHERE t1.row >= t2.count/2 and t1.row <= ((t2.count/2) +1)
) AS t3;

-- Mediana de freq_incendio_e_roubo_perc

SELECT ROUND(AVG(middle_values), 2) AS 'mediana_freq_incendio_e_roubo_perc'
FROM (
  SELECT t1.freq_incendio_e_roubo_perc AS 'middle_values'
  FROM (
    SELECT @row:=@row+1 as `row`, x.freq_incendio_e_roubo_perc
    FROM dimensional.dados_historicos AS x, (SELECT @row:=0) AS r
    WHERE x.freq_incendio_e_roubo_perc IS NOT NULL
    ORDER BY x.freq_incendio_e_roubo_perc
  ) AS t1,
  (
    SELECT COUNT(*) as 'count'
    FROM dimensional.dados_historicos x
    WHERE x.freq_incendio_e_roubo_perc IS NOT NULL
  ) AS t2
  WHERE t1.row >= t2.count/2 and t1.row <= ((t2.count/2) +1)
) AS t3;

-- Moda

SELECT
    'is_media_valor' AS nome_coluna,
    is_media_valor AS moda,
    COUNT(*) AS contagem
FROM
    dimensional.dados_historicos
GROUP BY
    is_media_valor
HAVING
    COUNT(*) >= ALL (SELECT COUNT(*) FROM dimensional.dados_historicos GROUP BY is_media_valor)
UNION ALL
SELECT
    'expostos' AS nome_coluna,
    expostos AS moda,
    COUNT(*) AS contagem
FROM
    dimensional.dados_historicos
GROUP BY
    expostos
HAVING
    COUNT(*) >= ALL (SELECT COUNT(*) FROM dimensional.dados_historicos GROUP BY expostos)
UNION ALL
SELECT
    'premio_medio_valor' AS nome_coluna,
    premio_medio_valor AS moda,
    COUNT(*) AS contagem
FROM
    dimensional.dados_historicos
GROUP BY
    premio_medio_valor
HAVING
    COUNT(*) >= ALL (SELECT COUNT(*) FROM dimensional.dados_historicos GROUP BY premio_medio_valor)
UNION ALL
SELECT
    'freq_sinistro' AS nome_coluna,
    freq_sinistro AS moda,
    COUNT(*) AS contagem
FROM
    dimensional.dados_historicos
GROUP BY
    freq_sinistro
HAVING
    COUNT(*) >= ALL (SELECT COUNT(*) FROM dimensional.dados_historicos GROUP BY freq_sinistro)
UNION ALL
SELECT
    'indice_sinistralidade_perc' AS nome_coluna,
    indice_sinistralidade_perc AS moda,
    COUNT(*) AS contagem
FROM
    dimensional.dados_historicos
GROUP BY
    indice_sinistralidade_perc
HAVING
    COUNT(*) >= ALL (SELECT COUNT(*) FROM dimensional.dados_historicos GROUP BY indice_sinistralidade_perc)
UNION ALL
SELECT
    'freq_incendio_e_roubo_perc' AS nome_coluna,
    freq_incendio_e_roubo_perc AS moda,
    COUNT(*) AS contagem
FROM
    dimensional.dados_historicos
GROUP BY
    freq_incendio_e_roubo_perc
HAVING
    COUNT(*) >= ALL (SELECT COUNT(*) FROM dimensional.dados_historicos GROUP BY freq_incendio_e_roubo_perc)
UNION ALL
SELECT
    'freq_incendio_e_roubo' AS nome_coluna,
    freq_incendio_e_roubo AS moda,
    COUNT(*) AS contagem
FROM
    dimensional.dados_historicos
GROUP BY
    freq_incendio_e_roubo
HAVING
    COUNT(*) >= ALL (SELECT COUNT(*) FROM dimensional.dados_historicos GROUP BY freq_incendio_e_roubo)
UNION ALL
SELECT
    'indeniz_incendio_e_roubo_valor' AS nome_coluna,
    indeniz_incendio_e_roubo_valor AS moda,
    COUNT(*) AS contagem
FROM
    dimensional.dados_historicos
GROUP BY
    indeniz_incendio_e_roubo_valor
HAVING
    COUNT(*) >= ALL (SELECT COUNT(*) FROM dimensional.dados_historicos GROUP BY indeniz_incendio_e_roubo_valor)
UNION ALL
SELECT
    'freq_colisao' AS nome_coluna,
    freq_colisao AS moda,
    COUNT(*) AS contagem
FROM
    dimensional.dados_historicos
GROUP BY
    freq_colisao
HAVING
    COUNT(*) >= ALL (SELECT COUNT(*) FROM dimensional.dados_historicos GROUP BY freq_colisao)
UNION ALL
SELECT
    'indeniz_colisao_valor' AS nome_coluna,
    indeniz_colisao_valor AS moda,
    COUNT(*) AS contagem
FROM
    dimensional.dados_historicos
GROUP BY
    indeniz_colisao_valor
HAVING
    COUNT(*) >= ALL (SELECT COUNT(*) FROM dimensional.dados_historicos GROUP BY indeniz_colisao_valor)
UNION ALL
SELECT
    'freq_outras' AS nome_coluna,
    freq_outras AS moda,
    COUNT(*) AS contagem
FROM
    dimensional.dados_historicos
GROUP BY
    freq_outras
HAVING
    COUNT(*) >= ALL (SELECT COUNT(*) FROM dimensional.dados_historicos GROUP BY freq_outras)
UNION ALL
SELECT
    'indeniz_outras_valor' AS nome_coluna,
    indeniz_outras_valor AS moda,
    COUNT(*) AS contagem
FROM
    dimensional.dados_historicos
GROUP BY
    indeniz_outras_valor
HAVING
    COUNT(*) >= ALL (SELECT COUNT(*) FROM dimensional.dados_historicos GROUP BY indeniz_outras_valor);

/* Dentre os valores representados, observei que existem colunas Trimodais, bimodais e unimodais. Portanto, em caso posterior fosse utilizado a imputação dos valores ausentes, possivelmente
eu não seguiria com a moda como forma de imputação */

# Medidas de variabilidade

-- Outliers

USE dimensional;

SET GLOBAL wait_timeout = 36000;
SET GLOBAL interactive_timeout = 36000;


/* Realizarei o slicing da query para que seja possível rodar sem que não seja necessário uma mudança drástica
nos timeouts, de modo que tenha problemas no tempo de conexão com o servidor */

# Criando a primeira CTE dentro da view

CREATE OR REPLACE VIEW outlier1 AS
WITH CTE1 AS (
    SELECT
        freq_incendio_e_roubo_perc,
        ROW_NUMBER() OVER (ORDER BY freq_incendio_e_roubo_perc) AS row_n
    FROM dimensional.dados_historicos
    WHERE freq_incendio_e_roubo_perc IS NOT NULL
), quartile_breaks AS (
    SELECT
        freq_incendio_e_roubo_perc,
        (SELECT freq_incendio_e_roubo_perc AS quartile_break
         FROM CTE1
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_incendio_e_roubo_perc IS NOT NULL) * 0.75)
        ) AS q_three_lower,
        (SELECT freq_incendio_e_roubo_perc AS quartile_break
         FROM CTE1
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_incendio_e_roubo_perc IS NOT NULL) * 0.75) + 1
        ) AS q_three_upper,
        (SELECT freq_incendio_e_roubo_perc AS quartile_break
         FROM CTE1
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_incendio_e_roubo_perc IS NOT NULL) * 0.25)
        ) AS q_one_lower,
        (SELECT freq_incendio_e_roubo_perc AS quartile_break
         FROM CTE1
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_incendio_e_roubo_perc IS NOT NULL) * 0.25) + 1
        ) AS q_one_upper
    FROM CTE1
), iqr AS (
    SELECT
        freq_incendio_e_roubo_perc,
        (    
			(SELECT MAX(q_three_lower) FROM quartile_breaks) +
            (SELECT MAX(q_three_upper) FROM quartile_breaks)         
		) / 2 AS q_three_iqr,
        (    
			(SELECT MAX(q_one_lower) FROM quartile_breaks) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks)         
		) / 2 AS q_one_iqr,
        1.5 * (
        (  
			(SELECT MAX(q_three_lower) FROM quartile_breaks) +
            (SELECT MAX(q_three_upper) FROM quartile_breaks)   
		) / 2 - (
			(SELECT MAX(q_one_lower) FROM quartile_breaks) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks)   
		) / 2) AS outlier_range_iqr
    FROM quartile_breaks
), 

indice_sinistralidade_perc_cte AS (
    SELECT
        indice_sinistralidade_perc,
        ROW_NUMBER() OVER (ORDER BY indice_sinistralidade_perc) AS row_n
    FROM dimensional.dados_historicos
    WHERE indice_sinistralidade_perc IS NOT NULL
), quartile_breaks2 AS (
    SELECT
        indice_sinistralidade_perc,
        (SELECT indice_sinistralidade_perc AS quartile_break
         FROM indice_sinistralidade_perc_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indice_sinistralidade_perc IS NOT NULL) * 0.75)
        ) AS q_three_lower,
        (SELECT indice_sinistralidade_perc AS quartile_break
         FROM indice_sinistralidade_perc_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indice_sinistralidade_perc IS NOT NULL) * 0.75) + 1
        ) AS q_three_upper,
        (SELECT indice_sinistralidade_perc AS quartile_break
         FROM indice_sinistralidade_perc_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indice_sinistralidade_perc IS NOT NULL) * 0.25)
        ) AS q_one_lower,
        (SELECT indice_sinistralidade_perc AS quartile_break
         FROM indice_sinistralidade_perc_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indice_sinistralidade_perc IS NOT NULL) * 0.25) + 1
        ) AS q_one_upper
    FROM indice_sinistralidade_perc_cte
), iqr2 AS (
    SELECT
        indice_sinistralidade_perc,
        (    
			(SELECT MAX(q_three_lower) FROM quartile_breaks2) + 
			(SELECT MAX(q_three_upper) FROM quartile_breaks2)            
        ) / 2 AS q_three_iqr2,
        (    
			(SELECT MAX(q_one_lower) FROM quartile_breaks2) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks2)
		) / 2 AS q_one_iqr2,
        1.5 * (
        ( 
			(SELECT MAX(q_three_lower) FROM quartile_breaks2) +
            (SELECT MAX(q_three_upper) FROM quartile_breaks2)   
		) / 2 - (
			(SELECT MAX(q_one_lower) FROM quartile_breaks2) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks2)
		) / 2) AS outlier_range_iqr2
    FROM quartile_breaks2
), 

is_media_valor_cte AS (
    SELECT
        is_media_valor,
        ROW_NUMBER() OVER (ORDER BY is_media_valor) AS row_n
    FROM dimensional.dados_historicos
    WHERE is_media_valor IS NOT NULL
), quartile_breaks3 AS (
    SELECT
        is_media_valor,
        (SELECT is_media_valor AS quartile_break
         FROM is_media_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE is_media_valor IS NOT NULL) * 0.75)
        ) AS q_three_lower,
        (SELECT is_media_valor AS quartile_break
         FROM is_media_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE is_media_valor IS NOT NULL) * 0.75) + 1
        ) AS q_three_upper,
        (SELECT is_media_valor AS quartile_break
         FROM is_media_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE is_media_valor IS NOT NULL) * 0.25)
        ) AS q_one_lower,
        (SELECT is_media_valor AS quartile_break
         FROM is_media_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE is_media_valor IS NOT NULL) * 0.25) + 1
        ) AS q_one_upper
    FROM is_media_valor_cte
), iqr3 AS (
    SELECT
        is_media_valor,
        (    
			(SELECT MAX(q_three_lower) FROM quartile_breaks3) + 
			(SELECT MAX(q_three_upper) FROM quartile_breaks3)            
        ) / 2 AS q_three_iqr3,
        (    
			(SELECT MAX(q_one_lower) FROM quartile_breaks3) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks3)
		) / 2 AS q_one_iqr3,
        1.5 * (
        ( 
			(SELECT MAX(q_three_lower) FROM quartile_breaks3) +
            (SELECT MAX(q_three_upper) FROM quartile_breaks3)   
		) / 2 - (
			(SELECT MAX(q_one_lower) FROM quartile_breaks3) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks3)
		) / 2) AS outlier_range_iqr3
    FROM quartile_breaks3
)

SELECT
    ROUND(MAX(q_one_iqr - outlier_range_iqr), 2) AS lower_fence_q1_freq_incendio_e_roubo_perc,
    ROUND(MAX(q_three_iqr + outlier_range_iqr), 2) AS upper_fence_q3_freq_incendio_e_roubo_perc,
    MAX(freq_incendio_e_roubo_perc) AS max_outlier_freq_incendio_e_roubo_perc,
    ROUND(MAX(q_one_iqr2 - outlier_range_iqr2), 2) AS lower_fence_q1_indice_sinistralidade_perc,
    ROUND(MAX(q_three_iqr2 + outlier_range_iqr2), 2) AS upper_fence_q3_indice_sinistralidade_perc,
    MAX(indice_sinistralidade_perc) AS max_outlier_indice_sinistralidade_perc,
    ROUND(MAX(q_one_iqr3 - outlier_range_iqr3), 2) AS lower_fence_q1_is_media_valor,
    ROUND(MAX(q_three_iqr3 + outlier_range_iqr3), 2) AS upper_fence_q3_is_media_valor,
    MAX(is_media_valor) AS max_outlier_is_media_valor
FROM iqr, iqr2, iqr3;

/*-------------------------------------------------------------------------------------*/

# Segunda CTE dentro da view

CREATE OR REPLACE VIEW outlier2 AS
WITH CTE2 AS (
    SELECT
        expostos,
        ROW_NUMBER() OVER (ORDER BY expostos) AS row_n
    FROM dimensional.dados_historicos
    WHERE expostos IS NOT NULL
), quartile_breaks4 AS (
    SELECT
        expostos,
        (SELECT expostos AS quartile_break
         FROM CTE2
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE expostos IS NOT NULL) * 0.75)
        ) AS q_three_lower,
        (SELECT expostos AS quartile_break
         FROM CTE2
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE expostos IS NOT NULL) * 0.75) + 1
        ) AS q_three_upper,
        (SELECT expostos AS quartile_break
         FROM CTE2
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE expostos IS NOT NULL) * 0.25)
        ) AS q_one_lower,
        (SELECT expostos AS quartile_break
         FROM CTE2
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE expostos IS NOT NULL) * 0.25) + 1
        ) AS q_one_upper
    FROM CTE2
), iqr4 AS (
    SELECT
        expostos,
        (    
			(SELECT MAX(q_three_lower) FROM quartile_breaks4) + 
			(SELECT MAX(q_three_upper) FROM quartile_breaks4)            
        ) / 2 AS q_three_iqr4,
        (    
			(SELECT MAX(q_one_lower) FROM quartile_breaks4) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks4)
		) / 2 AS q_one_iqr4,
        1.5 * (
        ( 
			(SELECT MAX(q_three_lower) FROM quartile_breaks4) +
            (SELECT MAX(q_three_upper) FROM quartile_breaks4)   
		) / 2 - (
			(SELECT MAX(q_one_lower) FROM quartile_breaks4) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks4)
		) / 2) AS outlier_range_iqr4
    FROM quartile_breaks4
)
, premio_medio_valor_cte AS (
    SELECT
        premio_medio_valor,
        ROW_NUMBER() OVER (ORDER BY premio_medio_valor) AS row_n
    FROM dimensional.dados_historicos
    WHERE premio_medio_valor IS NOT NULL
), quartile_breaks5 AS (
    SELECT
        premio_medio_valor,
        (SELECT premio_medio_valor AS quartile_break
         FROM premio_medio_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE premio_medio_valor IS NOT NULL) * 0.75)
        ) AS q_three_lower,
        (SELECT premio_medio_valor AS quartile_break
         FROM premio_medio_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE premio_medio_valor IS NOT NULL) * 0.75) + 1
        ) AS q_three_upper,
        (SELECT premio_medio_valor AS quartile_break
         FROM premio_medio_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE premio_medio_valor IS NOT NULL) * 0.25)
        ) AS q_one_lower,
        (SELECT premio_medio_valor AS quartile_break
         FROM premio_medio_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE premio_medio_valor IS NOT NULL) * 0.25) + 1
        ) AS q_one_upper
    FROM premio_medio_valor_cte
), iqr5 AS (
    SELECT
        premio_medio_valor,
        (    
			(SELECT MAX(q_three_lower) FROM quartile_breaks5) + 
			(SELECT MAX(q_three_upper) FROM quartile_breaks5)            
        ) / 2 AS q_three_iqr5,
        (    
			(SELECT MAX(q_one_lower) FROM quartile_breaks5) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks5)
		) / 2 AS q_one_iqr5,
        1.5 * (
        ( 
			(SELECT MAX(q_three_lower) FROM quartile_breaks5) +
            (SELECT MAX(q_three_upper) FROM quartile_breaks5)   
		) / 2 - (
			(SELECT MAX(q_one_lower) FROM quartile_breaks5) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks5)
		) / 2) AS outlier_range_iqr5
    FROM quartile_breaks5
)

, freq_sinistro_cte AS (
    SELECT
        freq_sinistro,
        ROW_NUMBER() OVER (ORDER BY freq_sinistro) AS row_n
    FROM dimensional.dados_historicos
    WHERE freq_sinistro IS NOT NULL
), quartile_breaks6 AS (
    SELECT
        freq_sinistro,
        (SELECT freq_sinistro AS quartile_break
         FROM freq_sinistro_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_sinistro IS NOT NULL) * 0.75)
        ) AS q_three_lower,
        (SELECT freq_sinistro AS quartile_break
         FROM freq_sinistro_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_sinistro IS NOT NULL) * 0.75) + 1
        ) AS q_three_upper,
        (SELECT freq_sinistro AS quartile_break
         FROM freq_sinistro_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_sinistro IS NOT NULL) * 0.25)
        ) AS q_one_lower,
        (SELECT freq_sinistro AS quartile_break
         FROM freq_sinistro_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_sinistro IS NOT NULL) * 0.25) + 1
        ) AS q_one_upper
    FROM freq_sinistro_cte
), iqr6 AS (
    SELECT
        freq_sinistro,
        (    
			(SELECT MAX(q_three_lower) FROM quartile_breaks6) + 
			(SELECT MAX(q_three_upper) FROM quartile_breaks6)            
        ) / 2 AS q_three_iqr6,
        (    
			(SELECT MAX(q_one_lower) FROM quartile_breaks6) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks6)
		) / 2 AS q_one_iqr6,
        1.5 * (
        ( 
			(SELECT MAX(q_three_lower) FROM quartile_breaks6) +
            (SELECT MAX(q_three_upper) FROM quartile_breaks6)   
		) / 2 - (
			(SELECT MAX(q_one_lower) FROM quartile_breaks6) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks6)
		) / 2) AS outlier_range_iqr6
    FROM quartile_breaks6
)
SELECT  
	ROUND(MAX(q_one_iqr4 - outlier_range_iqr4), 2) AS lower_fence_q1_expostos,
    ROUND(MAX(q_three_iqr4 + outlier_range_iqr4), 2) AS upper_fence_q3_expostos,
    MAX(expostos) AS max_outlier_expostos,
    ROUND(MAX(q_one_iqr5 - outlier_range_iqr5), 2) AS lower_fence_q1_premio_medio_valor,
    ROUND(MAX(q_three_iqr5 + outlier_range_iqr5), 2) AS upper_fence_q3_premio_medio_valor,
    MAX(premio_medio_valor) AS max_outlier_premio_medio_valor,
    ROUND(MAX(q_one_iqr6 - outlier_range_iqr6), 2) AS lower_fence_q1_freq_sinistro,
    ROUND(MAX(q_three_iqr6 + outlier_range_iqr6), 2) AS upper_fence_q3_freq_sinistro,
    MAX(freq_sinistro) AS max_outlier_freq_sinistro
FROM iqr4, iqr5, iqr6;

/*-------------------------------------------------------------------------------------*/

# Terceira CTE dentro da view

CREATE OR REPLACE VIEW outlier3 AS
WITH CTE3 AS (
    SELECT
        freq_incendio_e_roubo,
        ROW_NUMBER() OVER (ORDER BY freq_incendio_e_roubo) AS row_n
    FROM dimensional.dados_historicos
    WHERE freq_incendio_e_roubo IS NOT NULL
), quartile_breaks7 AS (
    SELECT
        freq_incendio_e_roubo,
        (SELECT freq_incendio_e_roubo AS quartile_break
         FROM CTE3
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_incendio_e_roubo IS NOT NULL) * 0.75)
        ) AS q_three_lower,
        (SELECT freq_incendio_e_roubo AS quartile_break
         FROM CTE3
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_incendio_e_roubo IS NOT NULL) * 0.75) + 1
        ) AS q_three_upper,
        (SELECT freq_incendio_e_roubo AS quartile_break
         FROM CTE3
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_incendio_e_roubo IS NOT NULL) * 0.25)
        ) AS q_one_lower,
        (SELECT freq_incendio_e_roubo AS quartile_break
         FROM CTE3
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_incendio_e_roubo IS NOT NULL) * 0.25) + 1
        ) AS q_one_upper
    FROM CTE3
), iqr7 AS (
    SELECT
        freq_incendio_e_roubo,
        (    
			(SELECT MAX(q_three_lower) FROM quartile_breaks7) + 
			(SELECT MAX(q_three_upper) FROM quartile_breaks7)            
        ) / 2 AS q_three_iqr7,
        (    
			(SELECT MAX(q_one_lower) FROM quartile_breaks7) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks7)
		) / 2 AS q_one_iqr7,
        1.5 * (
        ( 
			(SELECT MAX(q_three_lower) FROM quartile_breaks7) +
            (SELECT MAX(q_three_upper) FROM quartile_breaks7)   
		) / 2 - (
			(SELECT MAX(q_one_lower) FROM quartile_breaks7) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks7)
		) / 2) AS outlier_range_iqr7
    FROM quartile_breaks7
)

, indeniz_incendio_e_roubo_valor_cte AS (
    SELECT
        indeniz_incendio_e_roubo_valor,
        ROW_NUMBER() OVER (ORDER BY indeniz_incendio_e_roubo_valor) AS row_n
    FROM dimensional.dados_historicos
    WHERE indeniz_incendio_e_roubo_valor IS NOT NULL
), quartile_breaks8 AS (
    SELECT
        indeniz_incendio_e_roubo_valor,
        (SELECT indeniz_incendio_e_roubo_valor AS quartile_break
         FROM indeniz_incendio_e_roubo_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indeniz_incendio_e_roubo_valor IS NOT NULL) * 0.75)
        ) AS q_three_lower,
        (SELECT indeniz_incendio_e_roubo_valor AS quartile_break
         FROM indeniz_incendio_e_roubo_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indeniz_incendio_e_roubo_valor IS NOT NULL) * 0.75) + 1
        ) AS q_three_upper,
        (SELECT indeniz_incendio_e_roubo_valor AS quartile_break
         FROM indeniz_incendio_e_roubo_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indeniz_incendio_e_roubo_valor IS NOT NULL) * 0.25)
        ) AS q_one_lower,
        (SELECT indeniz_incendio_e_roubo_valor AS quartile_break
         FROM indeniz_incendio_e_roubo_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indeniz_incendio_e_roubo_valor IS NOT NULL) * 0.25) + 1
        ) AS q_one_upper
    FROM indeniz_incendio_e_roubo_valor_cte
), iqr8 AS (
    SELECT
        indeniz_incendio_e_roubo_valor,
        (    
			(SELECT MAX(q_three_lower) FROM quartile_breaks8) + 
			(SELECT MAX(q_three_upper) FROM quartile_breaks8)            
        ) / 2 AS q_three_iqr8,
        (    
			(SELECT MAX(q_one_lower) FROM quartile_breaks8) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks8)
		) / 2 AS q_one_iqr8,
        1.5 * (
        ( 
			(SELECT MAX(q_three_lower) FROM quartile_breaks8) +
            (SELECT MAX(q_three_upper) FROM quartile_breaks8)   
		) / 2 - (
			(SELECT MAX(q_one_lower) FROM quartile_breaks8) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks8)
		) / 2) AS outlier_range_iqr8
    FROM quartile_breaks8
)

, freq_colisao_cte AS (
    SELECT
        freq_colisao,
        ROW_NUMBER() OVER (ORDER BY freq_colisao) AS row_n
    FROM dimensional.dados_historicos
    WHERE freq_colisao IS NOT NULL
), quartile_breaks9 AS (
    SELECT
        freq_colisao,
        (SELECT freq_colisao AS quartile_break
         FROM freq_colisao_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_colisao IS NOT NULL) * 0.75)
        ) AS q_three_lower,
        (SELECT freq_colisao AS quartile_break
         FROM freq_colisao_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_colisao IS NOT NULL) * 0.75) + 1
        ) AS q_three_upper,
        (SELECT freq_colisao AS quartile_break
         FROM freq_colisao_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_colisao IS NOT NULL) * 0.25)
        ) AS q_one_lower,
        (SELECT freq_colisao AS quartile_break
         FROM freq_colisao_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_colisao IS NOT NULL) * 0.25) + 1
        ) AS q_one_upper
    FROM freq_colisao_cte
), iqr9 AS (
    SELECT
        freq_colisao,
        (    
			(SELECT MAX(q_three_lower) FROM quartile_breaks9) + 
			(SELECT MAX(q_three_upper) FROM quartile_breaks9)            
        ) / 2 AS q_three_iqr9,
        (    
			(SELECT MAX(q_one_lower) FROM quartile_breaks9) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks9)
		) / 2 AS q_one_iqr9,
        1.5 * (
        ( 
			(SELECT MAX(q_three_lower) FROM quartile_breaks9) +
            (SELECT MAX(q_three_upper) FROM quartile_breaks9)   
		) / 2 - (
			(SELECT MAX(q_one_lower) FROM quartile_breaks9) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks9)
		) / 2) AS outlier_range_iqr9
    FROM quartile_breaks9
)
SELECT
    ROUND(MAX(q_one_iqr7 - outlier_range_iqr7), 2) AS lower_fence_q1_freq_incendio_e_roubo,
    ROUND(MAX(q_three_iqr7 + outlier_range_iqr7), 2) AS upper_fence_q3_freq_incendio_e_roubo,
    MAX(freq_incendio_e_roubo) AS max_outlier_freq_incendio_e_roubo,
    ROUND(MAX(q_one_iqr8 - outlier_range_iqr8), 2) AS lower_fence_q1_indeniz_incendio_e_roubo_valor,
    ROUND(MAX(q_three_iqr8 + outlier_range_iqr8), 2) AS upper_fence_q3_indeniz_incendio_e_roubo_valor,
    MAX(indeniz_incendio_e_roubo_valor) AS max_outlier_indeniz_incendio_e_roubo_valor,
    ROUND(MAX(q_one_iqr9 - outlier_range_iqr9), 2) AS lower_fence_q1_freq_colisao,
    ROUND(MAX(q_three_iqr9 + outlier_range_iqr9), 2) AS upper_fence_q3_freq_colisao,
    MAX(freq_colisao) AS max_outlier_freq_colisao
FROM iqr7, iqr8, iqr9;

/*-------------------------------------------------------------------------------------*/

# Quarta CTE dentro da view

CREATE OR REPLACE VIEW outlier4 AS
WITH CTE4 AS (
    SELECT
        indeniz_colisao_valor,
        ROW_NUMBER() OVER (ORDER BY indeniz_colisao_valor) AS row_n
    FROM dimensional.dados_historicos
    WHERE indeniz_colisao_valor IS NOT NULL
), quartile_breaks10 AS (
    SELECT
        indeniz_colisao_valor,
        (SELECT indeniz_colisao_valor AS quartile_break
         FROM CTE4
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indeniz_colisao_valor IS NOT NULL) * 0.75)
        ) AS q_three_lower,
        (SELECT indeniz_colisao_valor AS quartile_break
         FROM CTE4
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indeniz_colisao_valor IS NOT NULL) * 0.75) + 1
        ) AS q_three_upper,
        (SELECT indeniz_colisao_valor AS quartile_break
         FROM CTE4
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indeniz_colisao_valor IS NOT NULL) * 0.25)
        ) AS q_one_lower,
        (SELECT indeniz_colisao_valor AS quartile_break
         FROM CTE4
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indeniz_colisao_valor IS NOT NULL) * 0.25) + 1
        ) AS q_one_upper
    FROM CTE4
), iqr10 AS (
    SELECT
        indeniz_colisao_valor,
        (    
			(SELECT MAX(q_three_lower) FROM quartile_breaks10) + 
			(SELECT MAX(q_three_upper) FROM quartile_breaks10)            
        ) / 2 AS q_three_iqr10,
        (    
			(SELECT MAX(q_one_lower) FROM quartile_breaks10) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks10)
		) / 2 AS q_one_iqr10,
        1.5 * (
        ( 
			(SELECT MAX(q_three_lower) FROM quartile_breaks10) +
            (SELECT MAX(q_three_upper) FROM quartile_breaks10)   
		) / 2 - (
			(SELECT MAX(q_one_lower) FROM quartile_breaks10) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks10)
		) / 2) AS outlier_range_iqr10
    FROM quartile_breaks10
)

, freq_outras_cte AS (
    SELECT
        freq_outras,
        ROW_NUMBER() OVER (ORDER BY freq_outras) AS row_n
    FROM dimensional.dados_historicos
    WHERE freq_outras IS NOT NULL
), quartile_breaks11 AS (
    SELECT
        freq_outras,
        (SELECT freq_outras AS quartile_break
         FROM freq_outras_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_outras IS NOT NULL) * 0.75)
        ) AS q_three_lower,
        (SELECT freq_outras AS quartile_break
         FROM freq_outras_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_outras IS NOT NULL) * 0.75) + 1
        ) AS q_three_upper,
        (SELECT freq_outras AS quartile_break
         FROM freq_outras_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_outras IS NOT NULL) * 0.25)
        ) AS q_one_lower,
        (SELECT freq_outras AS quartile_break
         FROM freq_outras_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE freq_outras IS NOT NULL) * 0.25) + 1
        ) AS q_one_upper
    FROM freq_outras_cte
), iqr11 AS (
    SELECT
        freq_outras,
        (    
			(SELECT MAX(q_three_lower) FROM quartile_breaks11) + 
			(SELECT MAX(q_three_upper) FROM quartile_breaks11)            
        ) / 2 AS q_three_iqr11,
        (    
			(SELECT MAX(q_one_lower) FROM quartile_breaks11) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks11)
		) / 2 AS q_one_iqr11,
        1.5 * (
        ( 
			(SELECT MAX(q_three_lower) FROM quartile_breaks11) +
            (SELECT MAX(q_three_upper) FROM quartile_breaks11)   
		) / 2 - (
			(SELECT MAX(q_one_lower) FROM quartile_breaks11) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks11)
		) / 2) AS outlier_range_iqr11
    FROM quartile_breaks11
)

, indeniz_outras_valor_cte AS (
    SELECT
        indeniz_outras_valor,
        ROW_NUMBER() OVER (ORDER BY indeniz_outras_valor) AS row_n
    FROM dimensional.dados_historicos
    WHERE indeniz_outras_valor IS NOT NULL
), quartile_breaks12 AS (
    SELECT
        indeniz_outras_valor,
        (SELECT indeniz_outras_valor AS quartile_break
         FROM indeniz_outras_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indeniz_outras_valor IS NOT NULL) * 0.75)
        ) AS q_three_lower,
        (SELECT indeniz_outras_valor AS quartile_break
         FROM indeniz_outras_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indeniz_outras_valor IS NOT NULL) * 0.75) + 1
        ) AS q_three_upper,
        (SELECT indeniz_outras_valor AS quartile_break
         FROM indeniz_outras_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indeniz_outras_valor IS NOT NULL) * 0.25)
        ) AS q_one_lower,
        (SELECT indeniz_outras_valor AS quartile_break
         FROM indeniz_outras_valor_cte
         WHERE row_n = FLOOR((SELECT COUNT(*) FROM dimensional.dados_historicos WHERE indeniz_outras_valor IS NOT NULL) * 0.25) + 1
        ) AS q_one_upper
    FROM indeniz_outras_valor_cte
), iqr12 AS (
    SELECT
        indeniz_outras_valor,
        (    
			(SELECT MAX(q_three_lower) FROM quartile_breaks12) + 
			(SELECT MAX(q_three_upper) FROM quartile_breaks12)            
        ) / 2 AS q_three_iqr12,
        (    
			(SELECT MAX(q_one_lower) FROM quartile_breaks12) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks12)
		) / 2 AS q_one_iqr12,
        1.5 * (
        ( 
			(SELECT MAX(q_three_lower) FROM quartile_breaks12) +
            (SELECT MAX(q_three_upper) FROM quartile_breaks12)   
		) / 2 - (
			(SELECT MAX(q_one_lower) FROM quartile_breaks12) +
            (SELECT MAX(q_one_upper) FROM quartile_breaks12)
		) / 2) AS outlier_range_iqr12
    FROM quartile_breaks12
)

SELECT
    ROUND(MAX(q_one_iqr10 - outlier_range_iqr10), 2) AS lower_fence_q1_indeniz_colisao_valor,
    ROUND(MAX(q_three_iqr10 + outlier_range_iqr10), 2) AS upper_fence_q3_indeniz_colisao_valor,
    MAX(indeniz_colisao_valor) AS max_outlier_indeniz_colisao_valor,
    ROUND(MAX(q_one_iqr11 - outlier_range_iqr11), 2) AS lower_fence_q1_freq_outras,
    ROUND(MAX(q_three_iqr11 + outlier_range_iqr11), 2) AS upper_fence_q3_freq_outras,
    MAX(freq_outras) AS max_outlier_freq_outras,
    ROUND(MAX(q_one_iqr12 - outlier_range_iqr12), 2) AS lower_fence_q1_indeniz_outras_valor,
    ROUND(MAX(q_three_iqr12 + outlier_range_iqr12), 2) AS upper_fence_q3_indeniz_outras_valor,
    MAX(indeniz_outras_valor) AS max_outlier_indeniz_outras_valor
FROM iqr10, iqr11, iqr12;

/* Pensei em uma elaboração de relacionamento dentro das tabelas, de modo que seja resumido o cálculo destes 
outliers e permita uma análise mais completa. Portanto, realizarei a inserção de uma nova coluna, de nome ID
inserindo o 1 como primitivo INT e posteriormente a criação das tabelas com ID e então criar a integridade
referencial */

# Primeira tabela com o ID - usando windows functions
DROP TABLE IF EXISTS outlier1_with_id;
CREATE TABLE outlier1_with_id AS
SELECT
    ROW_NUMBER() OVER () AS id,
    lower_fence_q1_freq_incendio_e_roubo_perc,
    upper_fence_q3_freq_incendio_e_roubo_perc,
    max_outlier_freq_incendio_e_roubo_perc,
    lower_fence_q1_indice_sinistralidade_perc,
    upper_fence_q3_indice_sinistralidade_perc,
    max_outlier_indice_sinistralidade_perc,
    lower_fence_q1_is_media_valor,
    upper_fence_q3_is_media_valor,
    max_outlier_is_media_valor
FROM outlier1;

# Segunda tabela com o ID 

DROP TABLE IF EXISTS outlier2_with_id;
CREATE TABLE outlier2_with_id AS
SELECT
    ROW_NUMBER() OVER () AS id,
    lower_fence_q1_expostos,
    upper_fence_q3_expostos,
    max_outlier_expostos,
    lower_fence_q1_premio_medio_valor,
    upper_fence_q3_premio_medio_valor,
    max_outlier_premio_medio_valor,
    lower_fence_q1_freq_sinistro,
    upper_fence_q3_freq_sinistro,
    max_outlier_freq_sinistro
FROM outlier2;

# Terceira tabela com o ID 
DROP TABLE IF EXISTS outlier3_with_id;
CREATE TABLE outlier3_with_id AS
SELECT
    ROW_NUMBER() OVER () AS id,
    lower_fence_q1_freq_incendio_e_roubo,
    upper_fence_q3_freq_incendio_e_roubo,
    max_outlier_freq_incendio_e_roubo,
    lower_fence_q1_indeniz_incendio_e_roubo_valor,
    upper_fence_q3_indeniz_incendio_e_roubo_valor,
    max_outlier_indeniz_incendio_e_roubo_valor,
    lower_fence_q1_freq_colisao,
    upper_fence_q3_freq_colisao,
    max_outlier_freq_colisao
FROM outlier3;

# Quarta tabela com o ID 

DROP TABLE IF EXISTS outlier4_with_id;
CREATE TABLE outlier4_with_id AS
SELECT
    ROW_NUMBER() OVER () AS id,
    lower_fence_q1_indeniz_colisao_valor,
    upper_fence_q3_indeniz_colisao_valor,
    max_outlier_indeniz_colisao_valor,
    lower_fence_q1_freq_outras,
    upper_fence_q3_freq_outras,
    max_outlier_freq_outras,
    lower_fence_q1_indeniz_outras_valor,
    upper_fence_q3_indeniz_outras_valor,
    max_outlier_indeniz_outras_valor
FROM outlier4;

/* Dada a criação das respectivas tabelas, bem como a integridade referencial, basta unirmos em uma consulta,
tendo a coluna id como relação */ 

# Checando o lower, upper fence e o max dos outliers para cada coluna da tabela dados_historicos
DROP TABLE IF EXISTS dimensional.outliers_table;
CREATE TABLE dimensional.outliers_table AS 
SELECT
    o1.id,
    o1.lower_fence_q1_freq_incendio_e_roubo_perc,
    o1.upper_fence_q3_freq_incendio_e_roubo_perc,
    o1.max_outlier_freq_incendio_e_roubo_perc,
    o1.lower_fence_q1_indice_sinistralidade_perc,
    o1.upper_fence_q3_indice_sinistralidade_perc,
    o1.max_outlier_indice_sinistralidade_perc,
    o1.lower_fence_q1_is_media_valor,
    o1.upper_fence_q3_is_media_valor,
    o1.max_outlier_is_media_valor,
    o2.lower_fence_q1_expostos,
    o2.upper_fence_q3_expostos,
    o2.max_outlier_expostos,
    o2.lower_fence_q1_premio_medio_valor,
    o2.upper_fence_q3_premio_medio_valor,
    o2.max_outlier_premio_medio_valor,
    o2.lower_fence_q1_freq_sinistro,
    o2.upper_fence_q3_freq_sinistro,
    o2.max_outlier_freq_sinistro,
    o3.lower_fence_q1_freq_incendio_e_roubo,
    o3.upper_fence_q3_freq_incendio_e_roubo,
    o3.max_outlier_freq_incendio_e_roubo,
    o3.lower_fence_q1_indeniz_incendio_e_roubo_valor,
    o3.upper_fence_q3_indeniz_incendio_e_roubo_valor,
    o3.max_outlier_indeniz_incendio_e_roubo_valor,
    o3.lower_fence_q1_freq_colisao,
    o3.upper_fence_q3_freq_colisao,
    o3.max_outlier_freq_colisao,
    o4.lower_fence_q1_indeniz_colisao_valor,
    o4.upper_fence_q3_indeniz_colisao_valor,
    o4.max_outlier_indeniz_colisao_valor,
    o4.lower_fence_q1_freq_outras,
    o4.upper_fence_q3_freq_outras,
    o4.max_outlier_freq_outras,
    o4.lower_fence_q1_indeniz_outras_valor,
    o4.upper_fence_q3_indeniz_outras_valor,
    o4.max_outlier_indeniz_outras_valor
FROM
    outlier1_with_id o1
JOIN
    outlier2_with_id o2 ON o1.id = o2.id
JOIN
    outlier3_with_id o3 ON o1.id = o3.id
JOIN
    outlier4_with_id o4 ON o1.id = o4.id;

# Observei que as colunas:
	# max_outlier_freq_incendio_e_roubo_perc - freq_incendio_e_roubo_perc
	# max_outlier_indice_sinistralidade_perc - indice_sinistralidade_perc
    # max_outlier_expostos - expostos
    # max_outlier_premio_medio_valor - premio_medio_valor
    
/* Possuem valores notadamente altos, portanto, umas das possibilidades é substituir os valores
extremos pela upper fence e seguirei esta técnica */

# Como usei a tabela outliers_table apenas para aramzenar, abaixo terão as colunas adequadas para a coluna dados_historicos.
# Contudo, como no mysql tem o safe_update, desabilitarei rapidamente para alterar a tabela

SET SQL_SAFE_UPDATES = 0;

UPDATE dimensional.dados_historicos
SET freq_incendio_e_roubo_perc = 2.95
WHERE freq_incendio_e_roubo_perc > 2.95;

UPDATE dimensional.dados_historicos
SET indice_sinistralidade_perc = 61.32
WHERE indice_sinistralidade_perc > 61.32;

UPDATE dimensional.dados_historicos
SET expostos = 468208.50
WHERE expostos > 468208.50;

UPDATE dimensional.dados_historicos
SET premio_medio_valor = 3571.50
WHERE premio_medio_valor > 3571.50;

SET SQL_SAFE_UPDATES = 1;

# Checando novamente os outliers, a fim de verificar se os valores foram modificados 

# Primeiro, preciso criar as tabelas de manipulação que seguirão o mesmo padrão anterior 

DROP TABLE IF EXISTS outlier1_m;
CREATE TABLE outlier1_m AS
SELECT
    ROW_NUMBER() OVER () AS id,
    lower_fence_q1_freq_incendio_e_roubo_perc,
    upper_fence_q3_freq_incendio_e_roubo_perc,
    max_outlier_freq_incendio_e_roubo_perc,
    lower_fence_q1_indice_sinistralidade_perc,
    upper_fence_q3_indice_sinistralidade_perc,
    max_outlier_indice_sinistralidade_perc,
    lower_fence_q1_is_media_valor,
    upper_fence_q3_is_media_valor,
    max_outlier_is_media_valor
FROM outlier1;

# Segunda tabela com o ID 

DROP TABLE IF EXISTS outlier2_m;
CREATE TABLE outlier2_m AS
SELECT
    ROW_NUMBER() OVER () AS id,
    lower_fence_q1_expostos,
    upper_fence_q3_expostos,
    max_outlier_expostos,
    lower_fence_q1_premio_medio_valor,
    upper_fence_q3_premio_medio_valor,
    max_outlier_premio_medio_valor,
    lower_fence_q1_freq_sinistro,
    upper_fence_q3_freq_sinistro,
    max_outlier_freq_sinistro
FROM outlier2;

# Terceira tabela com o ID 

DROP TABLE IF EXISTS outlier3_m;
CREATE TABLE outlier3_m AS
SELECT
    ROW_NUMBER() OVER () AS id,
    lower_fence_q1_freq_incendio_e_roubo,
    upper_fence_q3_freq_incendio_e_roubo,
    max_outlier_freq_incendio_e_roubo,
    lower_fence_q1_indeniz_incendio_e_roubo_valor,
    upper_fence_q3_indeniz_incendio_e_roubo_valor,
    max_outlier_indeniz_incendio_e_roubo_valor,
    lower_fence_q1_freq_colisao,
    upper_fence_q3_freq_colisao,
    max_outlier_freq_colisao
FROM outlier3;

# Quarta tabela com o ID 

DROP TABLE IF EXISTS outlier4_m;
CREATE TABLE outlier4_m AS
SELECT
    ROW_NUMBER() OVER () AS id,
    lower_fence_q1_indeniz_colisao_valor,
    upper_fence_q3_indeniz_colisao_valor,
    max_outlier_indeniz_colisao_valor,
    lower_fence_q1_freq_outras,
    upper_fence_q3_freq_outras,
    max_outlier_freq_outras,
    lower_fence_q1_indeniz_outras_valor,
    upper_fence_q3_indeniz_outras_valor,
    max_outlier_indeniz_outras_valor
FROM outlier4;

/* Então, faço a consulta para checar se o valor max das colunas modificadas estão iguais ao fence.
	# Detalhe: em um análise de risco, estaríamos estudando o outlier, contudo como não é objeto da nossa 
    análise, irei manter as técnicas de engenharia de atributos empregadas */
    
SELECT
    o1.id,
    o1.lower_fence_q1_freq_incendio_e_roubo_perc,
    o1.upper_fence_q3_freq_incendio_e_roubo_perc,
    o1.max_outlier_freq_incendio_e_roubo_perc,
    o1.lower_fence_q1_indice_sinistralidade_perc,
    o1.upper_fence_q3_indice_sinistralidade_perc,
    o1.max_outlier_indice_sinistralidade_perc,
    o1.lower_fence_q1_is_media_valor,
    o1.upper_fence_q3_is_media_valor,
    o1.max_outlier_is_media_valor,
    o2.lower_fence_q1_expostos,
    o2.upper_fence_q3_expostos,
    o2.max_outlier_expostos,
    o2.lower_fence_q1_premio_medio_valor,
    o2.upper_fence_q3_premio_medio_valor,
    o2.max_outlier_premio_medio_valor,
    o2.lower_fence_q1_freq_sinistro,
    o2.upper_fence_q3_freq_sinistro,
    o2.max_outlier_freq_sinistro,
    o3.lower_fence_q1_freq_incendio_e_roubo,
    o3.upper_fence_q3_freq_incendio_e_roubo,
    o3.max_outlier_freq_incendio_e_roubo,
    o3.lower_fence_q1_indeniz_incendio_e_roubo_valor,
    o3.upper_fence_q3_indeniz_incendio_e_roubo_valor,
    o3.max_outlier_indeniz_incendio_e_roubo_valor,
    o3.lower_fence_q1_freq_colisao,
    o3.upper_fence_q3_freq_colisao,
    o3.max_outlier_freq_colisao,
    o4.lower_fence_q1_indeniz_colisao_valor,
    o4.upper_fence_q3_indeniz_colisao_valor,
    o4.max_outlier_indeniz_colisao_valor,
    o4.lower_fence_q1_freq_outras,
    o4.upper_fence_q3_freq_outras,
    o4.max_outlier_freq_outras,
    o4.lower_fence_q1_indeniz_outras_valor,
    o4.upper_fence_q3_indeniz_outras_valor,
    o4.max_outlier_indeniz_outras_valor
FROM
    outlier1_m o1
JOIN
    outlier2_m o2 ON o1.id = o2.id
JOIN
    outlier3_m o3 ON o1.id = o3.id
JOIN
    outlier4_m o4 ON o1.id = o4.id;
    
# Valores estão concisos e dentro do do nosso dataset, não hão valores tangentes ao intervalo interquartílico superior

-- Desvio padrão

SELECT  
ROUND(STDDEV(is_media_valor), 2) AS std_is_media_valor,
ROUND(STDDEV(expostos), 2) AS std_expostos,
ROUND(STDDEV(premio_medio_valor), 2) AS std_premio_medio_valor,
ROUND(STDDEV(freq_sinistro), 2) AS std_freq_sinistro,
ROUND(STDDEV(indice_sinistralidade_perc), 2) AS std_indice_sinistralidade_perc,
ROUND(STDDEV(freq_incendio_e_roubo_perc), 2) AS std_freq_incendio_e_roubo_perc,
ROUND(STDDEV(freq_incendio_e_roubo), 2) AS std_freq_incendio_e_roubo,
ROUND(STDDEV(indeniz_incendio_e_roubo_valor), 2) AS std_indeniz_incendio_e_roubo_valor,
ROUND(STDDEV(freq_colisao), 2) AS std_freq_colisao,
ROUND(STDDEV(indeniz_colisao_valor), 2) AS std_indeniz_colisao_valor,
ROUND(STDDEV(freq_outras), 2) AS std_freq_outras,
ROUND(STDDEV(indeniz_outras_valor), 2) AS std_indeniz_outras_valor
FROM dimensional.dados_historicos;
    
-- Variância

SELECT
ROUND(VARIANCE(is_media_valor), 2) AS var_is_media_valor,
ROUND(VARIANCE(expostos), 2) AS var_expostos,
ROUND(VARIANCE(premio_medio_valor), 2) AS var_premio_medio_valor,
ROUND(VARIANCE(freq_sinistro), 2) AS var_freq_sinistro,
ROUND(VARIANCE(indice_sinistralidade_perc), 2) AS var_indice_sinistralidade_perc,
ROUND(VARIANCE(freq_incendio_e_roubo_perc), 2) AS var_freq_incendio_e_roubo_perc,
ROUND(VARIANCE(freq_incendio_e_roubo), 2) AS var_freq_incendio_e_roubo,
ROUND(VARIANCE(indeniz_incendio_e_roubo_valor), 2) AS var_indeniz_incendio_e_roubo_valor,
ROUND(VARIANCE(freq_colisao), 2) AS var_freq_colisao,
ROUND(VARIANCE(indeniz_colisao_valor), 2) AS var_indeniz_colisao_valor,
ROUND(VARIANCE(freq_outras), 2) AS var_freq_outras,
ROUND(VARIANCE(indeniz_outras_valor), 2) AS var_indeniz_outras_valor
FROM dimensional.dados_historicos;

/* A meu ver, o desvio padrão e variância não seriam enfaticamente adequados para este conjunto, pois nosso dataset
possui uma faixa de valores muito amplas, de modo que o uso da imputação usando o desvio padrão ou variância
manteriam a dispersão dos dados. Portanto, um dos caminhos possíveis é seguir com a mediana, interpolação linear
forward filling ou backward filling vide que são menos sensíveis a esta amplitude */

-- Calculando novamente a mediana, porém somente para as colunas que possuem valores ausentes

-- Mediana de indice_sinistralidade_perc

SELECT ROUND(AVG(middle_values), 2) AS 'mediana_indice_sinistralidade_perc'
FROM (
  SELECT t1.indice_sinistralidade_perc AS 'middle_values'
  FROM (
    SELECT @row:=@row+1 as `row`, x.indice_sinistralidade_perc
    FROM dimensional.dados_historicos AS x, (SELECT @row:=0) AS r
    WHERE x.indice_sinistralidade_perc IS NOT NULL
    ORDER BY x.indice_sinistralidade_perc
  ) AS t1,
  (
    SELECT COUNT(*) as 'count'
    FROM dimensional.dados_historicos x
    WHERE x.indice_sinistralidade_perc IS NOT NULL
  ) AS t2
  WHERE t1.row >= t2.count/2 and t1.row <= ((t2.count/2) +1)
) AS t3;

-- Mediana de freq_incendio_e_roubo_perc

SELECT ROUND(AVG(middle_values), 2) AS 'mediana_freq_incendio_e_roubo_perc'
FROM (
  SELECT t1.freq_incendio_e_roubo_perc AS 'middle_values'
  FROM (
    SELECT @row:=@row+1 as `row`, x.freq_incendio_e_roubo_perc
    FROM dimensional.dados_historicos AS x, (SELECT @row:=0) AS r
    WHERE x.freq_incendio_e_roubo_perc IS NOT NULL
    ORDER BY x.freq_incendio_e_roubo_perc
  ) AS t1,
  (
    SELECT COUNT(*) as 'count'
    FROM dimensional.dados_historicos x
    WHERE x.freq_incendio_e_roubo_perc IS NOT NULL
  ) AS t2
  WHERE t1.row >= t2.count/2 and t1.row <= ((t2.count/2) +1)
) AS t3;

# Como abordagem, optarei pela utilização do backward filling

-- Backward Filling

SET SQL_SAFE_UPDATES = 0;

UPDATE dimensional.dados_historicos AS t1
JOIN (
    SELECT 
        ano, 
        id_categoria, 
        id_sexo_condutor, 
        id_faixa_etaria,
        COALESCE(indice_sinistralidade_perc, @last_indice_sinistralidade_perc) AS indice_sinistralidade_perc,
        COALESCE(freq_incendio_e_roubo_perc, @last_freq_incendio_e_roubo_perc) AS freq_incendio_e_roubo_perc,
        (@last_indice_sinistralidade_perc := indice_sinistralidade_perc) AS dummy_indice,
        (@last_freq_incendio_e_roubo_perc := freq_incendio_e_roubo_perc) AS dummy_freq
    FROM dimensional.dados_historicos
    CROSS JOIN (SELECT @last_indice_sinistralidade_perc := NULL, @last_freq_incendio_e_roubo_perc := NULL) AS vars
    ORDER BY ano, id_categoria, id_sexo_condutor, id_faixa_etaria
) AS t2 ON t1.ano = t2.ano
    AND t1.id_categoria = t2.id_categoria
    AND t1.id_sexo_condutor = t2.id_sexo_condutor
    AND t1.id_faixa_etaria = t2.id_faixa_etaria
SET t1.indice_sinistralidade_perc = t2.indice_sinistralidade_perc,
    t1.freq_incendio_e_roubo_perc = t2.freq_incendio_e_roubo_perc
WHERE t1.indice_sinistralidade_perc IS NULL
   OR t1.freq_incendio_e_roubo_perc IS NULL;
   
SET SQL_SAFE_UPDATES = 1;

/*Pergunta 1: Qual o índice de sinistralidade dos condutores entre 26 e 35 anos do sexo Feminino e em um 
determinado período? */

-- Calculando o índice de sinistralidade, com filtragens

WITH CTE AS (
    SELECT *
    FROM dimensional.dados_historicos AS H
    LEFT JOIN dimensional.faixa_etaria_condutor C
    USING (id_faixa_etaria)
    WHERE faixa_etaria = 'Entre 26 e 35 anos'
    AND ano = '2018'
)
SELECT 
ano,
faixa_etaria,
sexo_condutor,
ROUND(SUM(expostos)/SUM(premio_medio_valor) * 100, 2) AS indice_sinistralidade_anual
FROM CTE AS T1
JOIN dimensional.sexo_condutor_e AS T2
USING (id_sexo_condutor)
GROUP BY 1, 2, 3
HAVING sexo_condutor = 'Feminino';

/* Pergunta 2:  Quais as Categorias Tarifarias com mais frequência de roubo por ano?  */

WITH CTE2 AS (
    SELECT 
        ano,
        categoria,
        total_roubos,
        ROW_NUMBER() OVER (PARTITION BY ano ORDER BY total_roubos DESC) AS ranking
    FROM (
        SELECT 
            ano,
            categoria,
            SUM(expostos) AS total_roubos
        FROM 
            dimensional.dados_historicos AS H
        LEFT JOIN 
            dimensional.categoria_tarifaria AS C
        USING 
            (id_categoria)
        WHERE 
            freq_incendio_e_roubo > 0
        GROUP BY 
            ano, id_categoria, categoria
    ) AS subquery
)
SELECT 
    ano,
    categoria,
    total_roubos,
    CASE
        WHEN ranking <= 5 THEN ranking
        ELSE NULL
    END AS ranking
FROM 
    CTE2
ORDER BY 
    1 DESC, 3 DESC;

/* Meu objetivo foi rankear as categorias tarifárias com base no total_roubos e, para tal, utilizei da windows_function para realizar o particionamento do dataframe. Em outras linguagens, pode ser compreendido como slice*/

-- Indicador 1: Índice de sinistralidade anual

WITH CTE3 AS (
    SELECT *
    FROM dimensional.dados_historicos AS H
    LEFT JOIN dimensional.faixa_etaria_condutor C
    USING (id_faixa_etaria)
)
SELECT 
    IF(GROUPING(ano), 'Total', ano) AS ano,
    IF(GROUPING(faixa_etaria), 'Total', faixa_etaria) AS faixa_etaria,
    ROUND(SUM(expostos)/SUM(premio_medio_valor) * 100, 2) AS indice_sinistralidade_anual_perc
FROM 
    CTE3 AS T1
JOIN 
    dimensional.sexo_condutor_e AS T2
USING 
    (id_sexo_condutor)
GROUP BY 
    ano, faixa_etaria, sexo_condutor WITH ROLLUP;
    
-- Indicador 2:  Média móvel acumulativa

SELECT 
    ano,
    ROUND(AVG(is_media_valor) OVER (ORDER BY ano ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) , 2) AS media_is_media_valor,
    ROUND(AVG(expostos) OVER (ORDER BY ano ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS media_expostos,
    ROUND(AVG(premio_medio_valor) OVER (ORDER BY ano ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS media_premio_medio_valor,
    ROUND(AVG(freq_sinistro) OVER (ORDER BY ano ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS media_freq_sinistro,
    ROUND(AVG(indice_sinistralidade_perc) OVER (ORDER BY ano ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS media_indice_sinistralidade_perc,
    ROUND(AVG(freq_incendio_e_roubo_perc) OVER (ORDER BY ano ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS media_freq_incendio_e_roubo_perc,
    ROUND(AVG(freq_incendio_e_roubo) OVER (ORDER BY ano ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS media_freq_incendio_e_roubo,
    ROUND(AVG(indeniz_incendio_e_roubo_valor) OVER (ORDER BY ano ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS media_indeniz_incendio_e_roubo_valor,
    ROUND(AVG(freq_colisao) OVER (ORDER BY ano ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS media_freq_colisao,
    ROUND(AVG(indeniz_colisao_valor) OVER (ORDER BY ano ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS media_indeniz_colisao_valor,
    ROUND(AVG(freq_outras) OVER (ORDER BY ano ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS media_freq_outras,
    ROUND(AVG(indeniz_outras_valor) OVER (ORDER BY ano ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS media_indeniz_outras_valor
FROM 
    dimensional.dados_historicos
ORDER BY 
    ano;
    
-- Indicador 3: Variação YoY para indice_sinistralidade_anual

WITH CTE4 AS (
    SELECT *
    FROM dimensional.dados_historicos AS H
    LEFT JOIN dimensional.faixa_etaria_condutor C
    USING (id_faixa_etaria)
)
SELECT 
    ano,
    faixa_etaria,
    sexo_condutor,
    ROUND(SUM(expostos)/SUM(premio_medio_valor) * 100, 2) AS indice_sinistralidade_anual,
    ROUND(ROUND(SUM(expostos)/SUM(premio_medio_valor) * 100, 2) - LAG(ROUND(SUM(CAST(expostos AS FLOAT))/SUM(CAST(premio_medio_valor AS FLOAT)) * 100, 2), 1, 0) OVER (ORDER BY ano), 2) AS delta_indice_sinistralidade_anual
FROM 
    CTE4 AS T1
JOIN 
    dimensional.sexo_condutor_e AS T2
USING 
    (id_sexo_condutor)
GROUP BY 
    1, 2, 3;
    
-- Indicador 4: Sinistros anuais, por faixa_etaria, sexo_condutor

WITH CTE5 AS (
    SELECT *
    FROM dimensional.dados_historicos AS H
    LEFT JOIN dimensional.faixa_etaria_condutor C
    USING (id_faixa_etaria)
)
SELECT 
    ano,
    faixa_etaria,
    sexo_condutor,
    SUM(freq_sinistro) AS total_sinistros,
    ROW_NUMBER() OVER (PARTITION BY ano ORDER BY SUM(freq_sinistro) DESC) AS ranking
FROM 
    CTE5 AS T1
JOIN 
    dimensional.sexo_condutor_e AS T2
USING 
    (id_sexo_condutor)
WHERE 
    freq_colisao > 0
GROUP BY 1, 2, 3;








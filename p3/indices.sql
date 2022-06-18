--7.1
CREATE INDEX resp_cat_idx ON responsible_for(category_name)
/*Indice de Hash otimiza a operação de seleção de relações em P cuja categoria 
é 'Frutos'*/
/*Plano de ação:
1. Encontrar rows com P.nome_cat = 'Frutos' no Hash Index
2. Gerar a tabela correspondente a responsavel_por restringida a essas entradas
3. Para cada entrada nessa tabela, encontrar entrada no indice (criado implicitamente) da tabela retalhista sobre o atributo tin e obter o nome de tal entrada
(4. Não é preciso ter extra cuidados com o SELECT DISTINCT uma vez que o atributo nome é unico para retalhistas)*/

--7.2
CREATE INDEX prod_desc_idx ON product(descr)
/*Indice Btree para preservar ordem otimiza a seleção de produtos cuja descrição
começar por 'A'*/
/*Plano de ação:
1. Observamos que a união entre P e T não acrescenta informação, pelo que corrigimos a query para
    SELECT P.cat, count(P.ean)
    FROM produto P
    WHERE P.desc LIKE 'A%'
    GROUP BY P.cat
2. Encontrar rows com P.desc a começar por 'A' no Btree Index
3. Gerar a tabela correspondente a produto restringida a essas entradas*/

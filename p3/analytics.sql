/* 1 */

SELECT week_day, county, SUM(units) AS total_units
FROM Vendas
WHERE (year BETWEEN value1 AND value2 AND month_day BETWEEN value3 AND value 4)
GROUP BY
    ROLLUP (week_day, county)

/* nao tenho a certeza da cena entre duas datas */

/* 2 */

SELECT county, cat, week_day, SUM(units) AS total_units
FROM Vendas
WHERE district = 'Lisboa'
GROUP BY
    ROLLUP(county, cat, week_day)
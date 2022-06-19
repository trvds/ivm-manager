/* 1 - BETWEEN 01-01-2021 AND 30-04-2022*/
SELECT week_day, county, SUM(units) as total_units
FROM sales NATURAL JOIN resupply_event
WHERE instant BETWEEN '2021-01-01 00:00:00' AND '2022-04-30 00:00:00'
GROUP BY
    GROUPING SETS ((week_day), (county), ());

/* 2 */
SELECT county, cat, week_day, SUM(units) as total_units
FROM sales
WHERE district = 'Lisboa'
GROUP BY
    GROUPING SETS ((county), (cat), (week_day), ());

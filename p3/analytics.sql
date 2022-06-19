/* 1 - BETWEEN 01-01-2022 AND 30-04-2022*/
SELECT week_day, county, SUM(units) as total_units
FROM sales
WHERE (year BETWEEN 2021 AND 2022)
    AND (month BETWEEN 01 AND 04)
    AND (month_day BETWEEN 01 AND 31)
GROUP BY
    GROUPING SETS ((week_day), (county), ());

/* 2 */
SELECT county, cat, week_day, SUM(units) as total_units
FROM sales
WHERE district = 'Lisboa'
GROUP BY
    GROUPING SETS ((county), (cat), (week_day), ());

/* 1 */
SELECT week_day, county, SUM(units) as total_units
FROM sales
WHERE (year BETWEEN year_x AND year_y)
    AND (month BETWEEN month_x AND month_y)
    AND (day BETWEEN day_x AND day_y)
GROUP BY
    GROUPING SETS ((week_day), (county), ());

/* 2 */
SELECT county, cat, week_day, SUM(units) as total_units
FROM sales
WHERE district = 'Lisboa'
GROUP BY
    GROUPING SETS ((county), (cat), (week_day), ());

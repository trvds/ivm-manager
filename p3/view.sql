DROP VIEW IF EXISTS sales;

CREATE VIEW 
    sales(ean, cat, year, quarter, month, month_day, week_day, district, county, units)
AS
SELECT ean, has_category.name AS cat, 
    EXTRACT(YEAR FROM instant) AS year,
    EXTRACT(QUARTER FROM instant) AS quarter,
    EXTRACT(MONTH FROM instant) AS month,
    EXTRACT(DAY FROM instant) AS month_day,
    EXTRACT(DOW FROM instant) AS week_day,
    district, county, units
FROM resupply_event NATURAL JOIN has_category NATURAL JOIN installed_in INNER JOIN retail_point ON installed_in.local = retail_point.name;

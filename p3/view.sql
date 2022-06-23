DROP VIEW IF EXISTS sales;

CREATE VIEW 
    sales(ean, cat, year, quarter, month, month_day, week_day, district, county, units)
AS
SELECT resupply_event.ean, has_category.name AS cat, 
    EXTRACT(YEAR FROM resupply_event.instant) AS year,
    EXTRACT(QUARTER FROM resupply_event.instant) AS quarter,
    EXTRACT(MONTH FROM resupply_event.instant) AS month,
    EXTRACT(DAY FROM resupply_event.instant) AS month_day,
    EXTRACT(ISODOW FROM resupply_event.instant) AS week_day,
    retail_point.district, retail_point.county, resupply_event.units
FROM resupply_event 
    NATURAL JOIN has_category 
    NATURAL JOIN installed_in 
    INNER JOIN retail_point 
    ON installed_in.local = retail_point.name;

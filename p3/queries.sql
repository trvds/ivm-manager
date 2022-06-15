SELECT name
FROM retailer NATURAL JOIN (
    SELECT tin
    FROM responsible_for
    GROUP BY tin
    HAVING COUNT(category) >= ALL (
        SELECT COUNT(category)
        FROM responsible_for
        GROUP BY tin
    )
);

SELECT name FROM retailer
NATURAL JOIN(
    SELECT tin FROM responsible_for
    WHERE name IN SELECT
        (name FROM simple_category)
)

SELECT name
FROM retailer NATURAL JOIN responsible_for NATURAL JOIN simple_category
GROUP BY tin
HAVING COUNT(*) = (
    SELECT COUNT(*)
    FROM simple_category
);

SELECT ean FROM product
WHERE ean NOT IN SELECT
    (ean FROM resupply_event)

SELECT ean from resupply_event 
    WHERE(
        COUNT(DISTINCT tin) = 1
    )   
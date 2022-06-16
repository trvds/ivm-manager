/* 1 */
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

/* 2 */
SELECT name FROM retailer
NATURAL JOIN(
    SELECT tin FROM responsible_for
    WHERE name IN (
        SELECT name 
        FROM simple_category
    )
)

SELECT name
FROM retailer NATURAL JOIN responsible_for NATURAL JOIN simple_category
GROUP BY tin
HAVING COUNT(tin) = (
    SELECT COUNT(*)
    FROM simple_category
);

/* 3 */
SELECT ean FROM product
WHERE ean NOT IN (
    SELECT ean
    FROM resupply_event
);

/* 4 */
SELECT ean
FROM resupply_event 
WHERE COUNT(DISTINCT tin) = 1;
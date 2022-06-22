/* 1 */
SELECT name
FROM retailer NATURAL JOIN (
    SELECT tin
    FROM responsible_for
    GROUP BY tin
    HAVING COUNT(*) >= ALL (
        SELECT COUNT(*)
        FROM responsible_for
        GROUP BY tin
    )
) AS C;

/* 2 */
SELECT name
FROM retailer NATURAL JOIN responsible_for
WHERE category_name IN simple_category
GROUP BY tin
HAVING COUNT(DISTINCT category_name) = (
    SELECT COUNT(*)
    FROM simple_category
);

/* 3 */
SELECT ean 
FROM product
WHERE ean NOT IN (
    SELECT DISTINCT ean
    FROM resupply_event
);

/* 4 */
SELECT ean
FROM resupply_event 
GROUP BY ean
HAVING COUNT(DISTINCT tin) = 1;

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
);

/* 2 */
-- TOOD: e se não existir?
SELECT name
FROM retailer NATURAL JOIN responsible_for
WHERE nome_cat IN simple_category
GROUP BY tin
HAVING COUNT(*) = (
    SELECT COUNT(*)
    FROM simple_category
);

/* 3 */
SELECT ean 
FROM product
WHERE ean NOT IN (
    SELECT ean
    FROM resupply_event
);

/* 4 */
SELECT ean
FROM resupply_event 
GROUP BY ean
HAVING COUNT(DISTINCT tin) = 1;

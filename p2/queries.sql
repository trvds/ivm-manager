/* 1) */

    SELECT DISTINCT ean, descr
    FROM product NATURAL JOIN replenishment_event NATURAL JOIN has
    WHERE instant > '2021/12/31' AND units > 10 AND name = 'Barras Energeticas';

/* 2) */

    SELECT DISTINCT serial_number, manuf
    FROM planogram
    WHERE ean = 9002490100070;

/* 3) */

    SELECT COUNT(*)
    FROM has_other
    WHERE super_category_name = 'Sopas Take-Away';

/* 4) */

    SELECT ean, descr
    FROM product NATURAL JOIN (
        SELECT ean
        FROM replenishment_event
        GROUP BY ean
        HAVING SUM(units) >= ALL (
            SELECT SUM(units)
            FROM replenishment_event
            GROUP BY ean
        )
    );
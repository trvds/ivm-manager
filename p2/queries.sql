/* 1) (Tiago) */

SELECT ean, descr
FROM products NATURAL JOIN replenishment_event NATURAL JOIN category
WHERE units > 10, instant > '2021/12/31', category = 'Barras Energéticas';

/* 1) (Melita) */

SELECT * 
FROM HAS INNER JOIN CATEGORY ON CATEGORY.name 
WHERE CATEGORY.name = "Barras Energéticas" INNER JOIN SHELVE ON SHELVE.name INNER JOIN REPLENISHMENT EVENT ON shelve.nr WHERE UNITS > 10 AND INSTANT > 2021/12/31

/* 2) (Melita)*/

SELECT IVM 
FROM OF INNER JOIN PLANOGRAM ON nr 
WHERE EAN = 9002490100070

/* 3) (Melita)*/

SELECT COUNT(SUPER_CATEGORY)
FROM has-other
WHERE SUPER_CATEGORY.name = "SOPAS TAKE-AWAY"

/* 4) (Melita) */

SELECT 
FROM PRODUCT INNER JOIN replenishment ON ean INNER JOIN replenisment_event ON instant 
GROUP BY units 
ORDER BY COUNT(units) DESC

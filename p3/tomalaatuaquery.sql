CREATE OR REPLACE FUNCTION get_subcategories_recursive(cat_name VARCHAR(255))
RETURNS TABLE (subcat VARCHAR(255)) AS
$$
BEGIN
    WITH RECURSIVE recursive_subcategories AS (
        SELECT name
        FROM category
        WHERE name = cat_name
    UNION
        SELECT category
        FROM recursive_subcategories s INNER JOIN has_other r
            ON s.name = r.super_category
    )
    SELECT *
    FROM recursive_subcategories;
END;
$$ LANGUAGE plpgsql;

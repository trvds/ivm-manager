CREATE OR REPLACE FUNCTION get_subcategories_recursive(cat_name VARCHAR(255))
RETURNS TABLE AS
$$
DECLARE subcategories TABLE;
DECLARE new_subcat TABLE;
BEGIN
    subcategories := (
        SELECT name
        FROM category
        WHERE name = cat_name
    );        
    IF NOT EXISTS subcategories THEN
        RAISE EXCEPTION 'That category does not exist';
    END IF;
    LOOP
        new_subcat := (
            SELECT category
            FROM has_other
            WHERE super_category IN subcategories 
                AND category NOT IN subcategories
        );

        IF EXISTS new_subcat THEN
            subcategories := subcategories UNION new_subcat;
        ELSE
            RETURN subcategories;
        ENDIF;
    END LOOP;

    RAISE EXCEPTION 'Something went wrong!';
END;
$$ LANGUAGE plpgsql;



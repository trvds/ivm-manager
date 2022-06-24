CREATE OR REPLACE PROCEDURE insert_simple_category(cat_name VARCHAR(255))
AS $$
BEGIN
    INSERT INTO category VALUES(cat_name);
    INSERT INTO simple_category VALUES(cat_name);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE delete_simple_category(cat_name VARCHAR(255))
AS $$
BEGIN
    DELETE FROM resupply_event WHERE ean IN (SELECT ean FROM product WHERE cat = cat_name);
    DELETE FROM responsible_for WHERE category_name = cat_name;
    DELETE FROM planogram WHERE ean IN (SELECT ean FROM product WHERE cat = cat_name);
    DELETE FROM shelf WHERE name = cat_name;
    DELETE FROM has_category WHERE name = cat_name;
    DELETE FROM product WHERE cat = cat_name;
    DELETE FROM has_other WHERE category = cat_name or super_category = cat_name;
    DELETE FROM simple_category WHERE name = cat_name;
    DELETE FROM category WHERE name = cat_name;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE insert_super_category(cat_name VARCHAR(255))
AS $$
BEGIN
    INSERT INTO category VALUES(cat_name);
    INSERT INTO super_category VALUES(cat_name);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE delete_super_category(cat_name VARCHAR(255))
AS $$
BEGIN
    DELETE FROM resupply_event WHERE ean IN (SELECT ean FROM product WHERE cat = cat_name);
    DELETE FROM responsible_for WHERE category_name = cat_name;
    DELETE FROM planogram WHERE ean IN (SELECT ean FROM product WHERE cat = cat_name);
    DELETE FROM shelf WHERE name = cat_name;
    DELETE FROM has_category WHERE name = cat_name;
    DELETE FROM product WHERE cat = cat_name;
    DELETE FROM has_other WHERE category = cat_name or super_category = cat_name;
    DELETE FROM super_category WHERE name = cat_name;
    DELETE FROM category WHERE name = cat_name;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE insert_subcategory(super_cat VARCHAR(255), cat_name VARCHAR(255))
AS $$
BEGIN
    if super_cat NOT IN (SELECT name FROM super_category) THEN
        INSERT INTO super_category VALUES(super_cat);
    END IF;
    IF cat_name NOT IN (SELECT name FROM category) THEN
        INSERT INTO simple_category VALUES(cat_name);
    END IF;
    INSERT INTO has_other VALUES(super_cat, cat_name);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE delete_subcategory(cat_name VARCHAR(255))
AS $$
BEGIN
    DELETE FROM has_other WHERE category = cat_name;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE insert_retailer(tin CHAR(9),retailer_name VARCHAR(255))
AS $$
BEGIN
    INSERT INTO retailer VALUES(tin, retailer_name);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE delete_retailer(tin_number CHAR(9))
AS $$
BEGIN
    DELETE FROM resupply_event WHERE tin = tin_number;
    DELETE FROM responsible_for WHERE tin = tin_number;
    DELETE FROM retailer WHERE tin = tin_number;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE insert_responsible_for(tin CHAR(9), category VARCHAR(255), serial_number CHAR(20), manuf VARCHAR(255))
AS $$
BEGIN
    INSERT INTO responsible_for VALUES(category, tin, serial_number, manuf);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE delete_responsible_for(tin_number CHAR(9), s_number CHAR(20), manuf_number VARCHAR(255))
AS $$
BEGIN
    DELETE FROM responsible_for WHERE tin = tin_number AND serial_number = s_number AND manuf = manuf_number;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION list_subcategories(cat_name VARCHAR(255))
RETURNS SETOF has_other AS
$$
DECLARE 
    hasother_row has_other%ROWTYPE;
BEGIN
    FOR hasother_row IN (SELECT * FROM has_other WHERE super_category = name)
    LOOP
        RETURN NEXT hasother_row;
        FOR hasother_row IN (SELECT * FROM all_subcats(hasother_row.category)) 
        LOOP
            RETURN NEXT hasother_row;
        END LOOP;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;

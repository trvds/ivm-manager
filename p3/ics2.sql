CREATE OR REPLACE FUNCTION add_simple_category()
RETURNS TRIGGER AS
$$
BEGIN

    IF NEW.name NOT IN (SELECT name FROM super_category) AND NEW.name NOT IN(SELECT name FROM category) THEN
            INSERT INTO category VALUES(NEW.name);

    ELSEIF NEW.name IN (SELECT name FROM super_category) THEN
        RAISE EXCEPTION 'Category already exists and it is a super category';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_simple_category_trigger ON simple_category;
CREATE TRIGGER check_simple_category_trigger
BEFORE UPDATE OR INSERT ON simple_category
FOR EACH ROW EXECUTE PROCEDURE add_simple_category();

------------------------------------------------------------

CREATE OR REPLACE FUNCTION add_super_category()
RETURNS TRIGGER AS
$$
BEGIN

    IF NEW.name NOT IN (SELECT name FROM simple_category) AND NEW.name NOT IN(SELECT name FROM category) THEN
            INSERT INTO category VALUES(NEW.name);

    ELSEIF NEW.name IN (SELECT name FROM simple_category) THEN
        DELETE FROM simple_category WHERE name = NEW.name;
    END IF;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_super_category_trigger ON super_category;
CREATE TRIGGER check_super_category_trigger
BEFORE UPDATE OR INSERT ON super_category
FOR EACH ROW EXECUTE PROCEDURE add_super_category();

------------------------------------------------------------
--IC-6
CREATE OR REPLACE FUNCTION product_category()
RETURNS TRIGGER AS
$$
BEGIN

    IF NEW.cat NOT IN (SELECT name FROM category) THEN
        INSERT INTO simple_category VALUES(NEW.cat);
    
    END IF;
    INSERT INTO has_category VALUES(NEW.ean, NEW.cat);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_product_category_trigger ON product;
CREATE TRIGGER check_product_category_trigger
AFTER UPDATE OR INSERT ON product
FOR EACH ROW EXECUTE PROCEDURE product_category();

-------------------------------------------------------------
CREATE OR REPLACE FUNCTION add_category_retailer()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.category_name NOT IN (SELECT name FROM category) THEN
        INSERT INTO simple_category VALUES (NEW.category_name);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS add_category_retailer_trigger ON responsible_for;
CREATE TRIGGER add_category_retailer_trigger
BEFORE UPDATE OR INSERT ON responsible_for
FOR EACH ROW EXECUTE PROCEDURE add_category_retailer();

------------------------------------------------------------
CREATE OR REPLACE FUNCTION add_super_cat()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.super_category NOT IN (SELECT name FROM category) THEN
        RETURN NEW;
    ELSEIF NEW.super_category NOT IN (SELECT name FROM super_category) THEN
        DELETE FROM simple_category WHERE name = NEW.super_category;
        INSERT INTO super_category VALUES (NEW.super_category);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS add_super_cat_trigger ON has_other;
CREATE TRIGGER add_super_cat_trigger
BEFORE UPDATE OR INSERT ON has_other
FOR EACH ROW EXECUTE PROCEDURE add_super_cat();
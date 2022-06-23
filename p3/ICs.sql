--IC-4

CREATE OR REPLACE FUNCTION check_replenished_units()
RETURNS TRIGGER AS
$$
DECLARE max_units INTEGER;
BEGIN
    SELECT units INTO max_units
    FROM planogram 
    WHERE ean = NEW.ean AND number = NEW.number AND manuf = NEW.manuf
        AND serial_number = NEW.serial_number;

    IF NEW.units > max_units THEN
        RAISE EXCEPTION 'The number of replenished units from a resupply event
        can not exceed the number of units specified in the planogram';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS replenished_units_trigger ON resupply_event;

CREATE TRIGGER replenished_units_trigger
BEFORE INSERT ON resupply_event
FOR EACH ROW EXECUTE PROCEDURE check_replenished_units();

--IC-5

CREATE OR REPLACE FUNCTION check_replenished_product()
RETURNS TRIGGER AS
$$
DECLARE shelf_cat VARCHAR(255);
BEGIN
    SELECT name INTO shelf_cat
    FROM shelf
    WHERE number = NEW.number AND manuf = NEW.manuf
        AND serial_number = NEW.serial_number;

    IF shelf_cat NOT IN (
        SELECT name
        FROM has_category
        WHERE ean = NEW.ean
    ) THEN
        RAISE EXCEPTION 'A product can only be replenished in a shelf that shows
        at least one of that products category';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS replenished_product_trigger ON resupply_event;

CREATE TRIGGER replenished_product_trigger
BEFORE INSERT ON resupply_event
FOR EACH ROW EXECUTE PROCEDURE check_replenished_product();

-----------------------  EXTRA INTEGRITY CONSTRAINTS ------------------------------

CREATE OR REPLACE FUNCTION add_simple_category()
RETURNS TRIGGER AS
$$
BEGIN

    IF NEW.name NOT IN (SELECT name FROM super_category) 
        AND NEW.name NOT IN(SELECT name FROM category) THEN
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

    IF NEW.name NOT IN (SELECT name FROM simple_category) 
        AND NEW.name NOT IN(SELECT name FROM category) THEN
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

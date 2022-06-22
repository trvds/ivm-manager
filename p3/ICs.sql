--IC-1

CREATE OR REPLACE FUNCTION check_category_loop()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.category = NEW.super_category THEN
        RAISE EXCEPTION 'A category can not be contained in itself';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_category_loop_trigger ON has_other;

CREATE TRIGGER check_category_loop_trigger
BEFORE UPDATE OR INSERT ON has_other
FOR EACH ROW EXECUTE PROCEDURE check_category_loop();

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
        WHERE ean = NEW.ean;
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

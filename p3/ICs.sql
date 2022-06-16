--IC-1

CREATE OR REPLACE FUNCTION check_category_loop()
RETURNS TRIGGER AS
$$
DECLARE cat_name VARCHAR(255) DEFAULT NEW.category;
BEGIN
    LOOP
        IF NEW.category = cat_name
            RAISE EXCEPTION 'A category can not be contained it itself'
        ELSEIF cat_name IN (SELECT category FROM has_other)
            SELECT super_category INTO cat_name
            FROM has_other
            WHERE category = cat_name
        ELSE
            EXIT
        END IF
    END LOOP
    RETURN NEW
END
$$ LANGUAGE plpgsql

DROP TRIGGER check_category_loop_trigger ON has_other IF EXISTS

CREATE TRIGGER check_category_loop_trigger
BEFORE UPDATE OR INSERT ON has_other
FOR EACH ROW EXECUTE PROCEDURE check_category_loop()

--IC-4

CREATE OR REPLACE FUNCTION check_replenished_units()
RETURNS TRIGGER AS
$$
DECLARE max_units INTEGER
BEGIN
    SELECT units INTO max_units
    FROM planogram 
    WHERE ean = NEW.ean AND nr = NEW.nr AND producer = NEW.producer
        AND serial_number = NEW.serial_number

    IF NEW.units > max_units
        RAISE EXCEPTION 'The number of replenished units from a resupply event
        can not exceed the number of units specified in the planogram'
    END IF

    RETURN NEW
END
$$ LANGUAGE plpgsql

DROP TRIGGER replenished_units_trigger ON resupply_event IF EXISTS

CREATE TRIGGER replenished_units_trigger
BEFORE INSERT ON resuply_event
FOR EACH ROW EXECUTE PROCEDURE check_replenished_units()

--IC-5

CREATE OR REPLACE FUNCTION check_replenished_product()
RETUNS TRIGGER AS
$$
DECLARE prod_cat VARCHAR(255);
DECLARE shelf_cat VARCHAR(255);
BEGIN
    SELECT name INTO prod_cat
    FROM has_category
    WHERE ean = NEW.ean

    SELECT name INTO shelf_cat
    FROM shelf
    WHERE nr = NEW.nr AND producer = NEW.producer
        AND serial_number = NEW.serial_number

    IF prod_cat != shelf_cat
        RAISE EXCEPTION 'A product can only be replenished in a shelf that shows
        at least one of that products category'
    END IF

    RETURN NEW
END
$$ LANGUAGE plpgsql

DROP TRIGGER replenished_product_trigger ON resupply_event IF EXISTS

CREATE TRIGGER replenished_product_trigger
BEFORE INSERT ON resuply_event
FOR EACH ROW EXECUTE PROCDEURE check_replenished_product()

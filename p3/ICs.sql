%IC-1

CREATE OR REPLACE FUNCTION check_category_loop()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.category = NEW.super_category
        RAISE EXCEPTION 'A category can not be contained it itself'
    END IF

    RETURN NEW
END
$$ LANGUAGE plpgsql

CREATE TRIGGER check_category_loop_trigger
BEFORE UPDATE OR INSERT ON has_other
FOR EACH ROW EXECUTE PROCEDURE check_category_loop()

%IC-4

CREATE OR REPLACE FUNCTION check_replenished_units(units INTEGER, serial_number CHAR)
RETURNS TRIGGER AS
$$
DECLARE max_units INTEGER
BEGIN
    FROM planogram 
    SELECT units INTO max_units
    WHERE planogram.serial_number = serial_number

    IF units > max_units
        RAISE EXCEPTION 'The number of replenished units from a resupply event
        can not exceed the number of units specified in the planogram'
    END IF

    RETURN %???
END
$$ LANGUAGE plpgsql


CREATE TRIGGER replenished_units_trigger
BEFORE UPDATE OR INSERT ON resuply_event
FOR EACH ROW EXECUTE PROCEDURE check_replenished_units(resuply_event.units, resuply_event.serial_number)

%IC-5

CREATE OR REPLACE FUNCTION heck_replenished_product(serial_nr CHAR, p_ean CHAR)
RETUNS TRIGGER AS
$$
DECLARE shelf_nr INTEGER
BEGIN
    FROM shelf
    NATURAL JOIN planogram
    SELECT number INTO shelf_nr
    WHERE serial_number = serial_nr AND ean = p_ean

    IF p_ean.cat != shelf_nr.name
        RAISE EXCEPTION 'A product can only be replenished in a shelf that shows
        at least one of that products category'
    END IF

    RETURN %???
END
$$ LANGUAGE plpgsql

CREATE TRIGGER replenished_product_trigger
BEFORE UPDATE OR INSERT ON resuply_event
FOR EACH ROW EXECUTE PROCDEURE check_replenished_product(resuply_event.serial_number, resuply_event.ean)

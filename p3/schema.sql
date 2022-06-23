DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS simple_category CASCADE;
DROP TABLE IF EXISTS super_category CASCADE;
DROP TABLE IF EXISTS has_other CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS has_category CASCADE;
DROP TABLE IF EXISTS ivm CASCADE;
DROP TABLE IF EXISTS retail_poINT CASCADE;
DROP TABLE IF EXISTS installed_in CASCADE;
DROP TABLE IF EXISTS shelf CASCADE;
DROP TABLE IF EXISTS planogram CASCADE;
DROP TABLE IF EXISTS retailer CASCADE;
DROP TABLE IF EXISTS responsible_for CASCADE;
DROP TABLE IF EXISTS resupply_event CASCADE;

CREATE TABLE category (
    name VARCHAR(255) NOT NULL PRIMARY KEY,
);

CREATE TABLE simple_category (
    name VARCHAR(255) NOT NULL PRIMARY KEY,
    FOREIGN KEY (name) REFERENCES category(name)
);

CREATE TABLE super_category (
    name VARCHAR(255) NOT NULL PRIMARY KEY,
    FOREIGN KEY (name) REFERENCES category(name)
);

CREATE TABLE has_other (
    super_category VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL PRIMARY KEY,
    FOREIGN KEY (super_category) REFERENCES super_category(name),
    FOREIGN KEY (category) REFERENCES category(name),
    CHECK super_category != category
);

CREATE TABLE product (
    ean CHAR(13) NOT NULL PRIMARY KEY,
    cat VARCHAR(255) NOT NULL,
    descr VARCHAR(255) NOT NULL,
    FOREIGN KEY (cat) REFERENCES category(name)
);

CREATE TABLE has_category(
    ean CHAR(13) NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY(ean, name),
    FOREIGN KEY (ean) REFERENCES product(ean),
    FOREIGN KEY (name) REFERENCES category(name)
);

CREATE TABLE ivm(
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    PRIMARY KEY(serial_number, manuf)
);

CREATE TABLE retail_poINT (
    name VARCHAR(255) NOT NULL PRIMARY KEY,
    district VARCHAR(255) NOT NULL,
    county VARCHAR(255) NOT NULL,
);


CREATE TABLE installed_in (
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    local VARCHAR(255) NOT NULL,
    PRIMARY KEY(serial_number, manuf),
    FOREIGN KEY (serial_number, manuf) REFERENCES ivm(serial_number, manuf),
    FOREIGN KEY (local) REFERENCES retail_point(name)
);

CREATE TABLE shelf (
    number INT NOT NULL,
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    height REAL NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY(number, serial_number, manuf),
    FOREIGN KEY (serial_number, manuf) REFERENCES ivm(serial_number, manuf),
    FOREIGN KEY (name) REFERENCES category(name)
);

CREATE TABLE planogram (
    ean CHAR(13) NOT NULL,
    number INT NOT NULL,
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    faces INT NOT NULL,
    units INT NOT NULL,
    loc INT NOT NULL,
    PRIMARY KEY(ean, number, serial_number, manuf),
    FOREIGN KEY (ean) REFERENCES product(ean),
    FOREIGN KEY (number, serial_number, manuf) 
        REFERENCES shelf(number, serial_number, manuf)
);

CREATE TABLE retailer (
    tin CHAR(9) NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL unique,
);

CREATE TABLE responsible_for (
    category_name VARCHAR(255) NOT NULL,
    tin CHAR(9) NOT NULL,
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    PRIMARY KEY(serial_number, manuf),
    FOREIGN KEY (serial_number, manuf) REFERENCES ivm(serial_number, manuf),
    FOREIGN KEY (tin) REFERENCES retailer(tin),
    FOREIGN KEY (category_name) REFERENCES category(name)
);

CREATE TABLE resupply_event(
    ean CHAR(13) NOT NULL,
    number INT NOT NULL,
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    instant TIMESTAMP NOT NULL,
    units INT NOT NULL,
    tin CHAR(9) NOT NULL,
    PRIMARY KEY(ean, number, serial_number, manuf, instant),
    FOREIGN KEY (ean, number, serial_number, manuf) 
        REFERENCES planogram(ean, number, serial_number, manuf),
    FOREIGN KEY (tin) REFERENCES retailer(tin)
);

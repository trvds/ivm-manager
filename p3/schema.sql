DROP TABLE IF EXISTS category cascade;
DROP TABLE IF EXISTS simple_category cascade;
DROP TABLE IF EXISTS super_category cascade;
DROP TABLE IF EXISTS has_other cascade;
DROP TABLE IF EXISTS product cascade;
DROP TABLE IF EXISTS has_category cascade;
DROP TABLE IF EXISTS ivm cascade;
DROP TABLE IF EXISTS retail_poINT cascade;
DROP TABLE IF EXISTS installed_in cascade;
DROP TABLE IF EXISTS shelf cascade;
DROP TABLE IF EXISTS planogram cascade;
DROP TABLE IF EXISTS retailer cascade;
DROP TABLE IF EXISTS responsible_for cascade;
DROP TABLE IF EXISTS resupply_event cascade;


CREATE TABLE category (
    name VARCHAR(255) NOT NULL,
    CONSTRAINT pk_category PRIMARY KEY(name)
);

CREATE TABLE simple_category (
    name VARCHAR(255) NOT NULL,
    CONSTRAINT pk_simple_category PRIMARY KEY(name),
    CONSTRAINT fk_simple_category FOREIGN KEY(name) references category(name)
);

CREATE TABLE super_category (
    name VARCHAR(255) NOT NULL,
    CONSTRAINT pk_super_category PRIMARY KEY(name),
    CONSTRAINT fk_super_category FOREIGN KEY(name) references category(name)
);

CREATE TABLE has_other (
    super_category VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL,
    CHECK (super_category != category),
    CONSTRAINT pk_has_other PRIMARY KEY(category),
    CONSTRAINT fk_has_other_super_category FOREIGN KEY(super_category) 
        references super_category(name),
    CONSTRAINT fk_has_other_category FOREIGN KEY(category) 
        references category(name)
);

CREATE TABLE product (
    ean CHAR(13) NOT NULL,
    cat VARCHAR(255) NOT NULL,
    descr VARCHAR(255) NOT NULL,
    CONSTRAINT pk_product PRIMARY KEY(ean),
    CONSTRAINT fk_product_category FOREIGN KEY(cat) references category(name)
);

CREATE TABLE has_category(
    ean CHAR(13) NOT NULL,
    name VARCHAR(255) NOT NULL,
    CONSTRAINT pk_has_category PRIMARY KEY(ean, name),
    CONSTRAINT fk_has_category_product FOREIGN KEY(ean) 
        references product(ean),
    CONSTRAINT fk_has_category_category FOREIGN KEY(name) 
        references category(name)
);

CREATE TABLE ivm(
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    CONSTRAINT pk_ivm PRIMARY KEY(serial_number, manuf)
);

CREATE TABLE retail_poINT (
    name VARCHAR(255) NOT NULL,
    district VARCHAR(255) NOT NULL,
    county VARCHAR(255) NOT NULL,
    CONSTRAINT pk_retail_point PRIMARY KEY(name)
);


CREATE TABLE installed_in (
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    local VARCHAR(255) NOT NULL,
    CONSTRAINT pk_installed_in PRIMARY KEY(serial_number, manuf),
    CONSTRAINT fk_installed_in_ivm FOREIGN KEY(serial_number, manuf) 
        references ivm(serial_number, manuf),
    CONSTRAINT fk_installed_in_retail_point FOREIGN KEY(local) 
        references retail_point(name)
);

CREATE TABLE shelf (
    number INT NOT NULL,
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    height real NOT NULL,
    name VARCHAR(255) NOT NULL,
    CONSTRAINT pk_shelf PRIMARY KEY(number, serial_number, manuf),
    CONSTRAINT fk_shelf_ivm FOREIGN KEY(serial_number, manuf) 
        references ivm(serial_number, manuf),
    CONSTRAINT fk_shelf_category FOREIGN KEY(name) references category(name)
);

CREATE TABLE planogram (
    ean CHAR(13) NOT NULL,
    number INT NOT NULL,
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    faces INT NOT NULL,
    units INT NOT NULL,
    loc INT NOT NULL,
    CONSTRAINT pk_planogram PRIMARY KEY(ean, number, serial_number, manuf),
    CONSTRAINT fk_planogram_product FOREIGN KEY(ean) references product(ean),
    CONSTRAINT fk_planogram_shelf FOREIGN KEY(number, serial_number, manuf) 
        references shelf(number, serial_number, manuf)
);

CREATE TABLE retailer (
    tin CHAR(9) NOT NULL,
    name VARCHAR(255) NOT NULL unique,
    CONSTRAINT pk_retailer PRIMARY KEY(tin)
);

CREATE TABLE responsible_for (
    category_name VARCHAR(255) NOT NULL,
    tin CHAR(9) NOT NULL,
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    CONSTRAINT pk_responsible_for PRIMARY KEY(serial_number, manuf),
    CONSTRAINT fk_responsible_for_ivm FOREIGN KEY(serial_number, manuf) 
        references ivm(serial_number, manuf),
    CONSTRAINT fk_responsible_for_retailer FOREIGN KEY(tin) 
        references retailer(tin),
    CONSTRAINT fk_responsible_for_category FOREIGN KEY(category_name) 
        references category(name)
);

CREATE TABLE resupply_event(
    ean CHAR(13) NOT NULL,
    number INT NOT NULL,
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    instant TIMESTAMP NOT NULL,
    units INT NOT NULL,
    tin CHAR(9) NOT NULL,
    CONSTRAINT pk_resuply_event PRIMARY KEY(ean, number, serial_number, manuf, instant),
    CONSTRAINT fk_resuply_event_planogram FOREIGN KEY(ean, number, serial_number, manuf) 
        references planogram(ean, number, serial_number, manuf),
    CONSTRAINT fk_resuply_event_retailer FOREIGN KEY(tin) references retailer(tin)
);

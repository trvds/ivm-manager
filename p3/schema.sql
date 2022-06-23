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
    constraint pk_category primary key(name)
);

CREATE TABLE simple_category (
    name VARCHAR(255) NOT NULL,
    constraint pk_simple_category primary key(name),
    constraint fk_simple_category foreign key(name) references category(name)
);

CREATE TABLE super_category (
    name VARCHAR(255) NOT NULL,
    constraint pk_super_category primary key(name),
    constraint fk_super_category foreign key(name) references category(name)
);

CREATE TABLE has_other (
    super_category VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL,
    CHECK (super_category != category),
    constraint pk_has_other primary key(category),
    constraint fk_has_other_super_category foreign key(super_category) references super_category(name),
    constraint fk_has_other_category foreign key(category) references category(name)
);

CREATE TABLE product (
    ean CHAR(13) NOT NULL,
    cat VARCHAR(255) NOT NULL,
    descr VARCHAR(255) NOT NULL,
    constraint pk_product primary key(ean),
    constraint fk_product_category foreign key(cat) references category(name)
);

CREATE TABLE has_category(
    ean CHAR(13) NOT NULL,
    name VARCHAR(255) NOT NULL,
    constraint pk_has_category primary key(ean, name),
    constraint fk_has_category_product foreign key(ean) references product(ean),
    constraint fk_has_category_category foreign key(name) references category(name)
);

CREATE TABLE ivm(
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    constraint pk_ivm primary key(serial_number, manuf)
);

CREATE TABLE retail_poINT (
    name VARCHAR(255) NOT NULL,
    district VARCHAR(255) NOT NULL,
    county VARCHAR(255) NOT NULL,
    constraint pk_retail_point primary key(name)
);


CREATE TABLE installed_in (
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    local VARCHAR(255) NOT NULL,
    constraint pk_installed_in primary key(serial_number, manuf),
    constraint fk_installed_in_ivm foreign key(serial_number, manuf) references ivm(serial_number, manuf),
    constraint fk_installed_in_retail_point foreign key(local) references retail_point(name)
);

CREATE TABLE shelf (
    number INT NOT NULL,
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    height real NOT NULL,
    name VARCHAR(255) NOT NULL,
    constraint pk_shelf primary key(number, serial_number, manuf),
    constraint fk_shelf_ivm foreign key(serial_number, manuf) references ivm(serial_number, manuf),
    constraint fk_shelf_category foreign key(name) references category(name)
);

CREATE TABLE planogram (
    ean CHAR(13) NOT NULL,
    number INT NOT NULL,
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    faces INT NOT NULL,
    units INT NOT NULL,
    loc INT NOT NULL,
    constraint pk_planogram primary key(ean, number, serial_number, manuf),
    constraint fk_planogram_product foreign key(ean) references product(ean),
    constraint fk_planogram_shelf foreign key(number, serial_number, manuf) references shelf(number, serial_number, manuf)
);

CREATE TABLE retailer (
    tin CHAR(9) NOT NULL,
    name VARCHAR(255) NOT NULL unique,
    constraint pk_retailer primary key(tin)
);

CREATE TABLE responsible_for (
    category_name VARCHAR(255) NOT NULL,
    tin CHAR(9) NOT NULL,
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    constraint pk_responsible_for primary key(serial_number, manuf),
    constraint fk_responsible_for_ivm foreign key(serial_number, manuf) references ivm(serial_number, manuf),
    constraint fk_responsible_for_retailer foreign key(tin) references retailer(tin),
    constraint fk_responsible_for_category foreign key(category_name) references category(name)
);

CREATE TABLE resupply_event(
    ean CHAR(13) NOT NULL,
    number INT NOT NULL,
    serial_number CHAR(20) NOT NULL,
    manuf VARCHAR(255) NOT NULL,
    instant TIMESTAMP NOT NULL,
    units INT NOT NULL,
    tin CHAR(9) NOT NULL,
    constraint pk_resuply_event primary key(ean, number, serial_number, manuf, instant),
    constraint fk_resuply_event_planogram foreign key(ean, number, serial_number, manuf) references planogram(ean, number, serial_number, manuf),
    constraint fk_resuply_event_retailer foreign key(tin) references retailer(tin)
);

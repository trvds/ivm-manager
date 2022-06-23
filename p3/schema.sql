drop table if exists category cascade;
drop table if exists simple_category cascade;
drop table if exists super_category cascade;
drop table if exists has_other cascade;
drop table if exists product cascade;
drop table if exists has_category cascade;
drop table if exists ivm cascade;
drop table if exists retail_point cascade;
drop table if exists installed_in cascade;
drop table if exists shelf cascade;
drop table if exists planogram cascade;
drop table if exists retailer cascade;
drop table if exists responsible_for cascade;
drop table if exists resupply_event cascade;


create table category (
    name varchar(255) not null,
    constraint pk_category primary key(name)
);

create table simple_category (
    name varchar(255) not null,
    constraint pk_simple_category primary key(name),
    constraint fk_simple_category foreign key(name) references category(name)
);

create table super_category (
    name varchar(255) not null,
    constraint pk_super_category primary key(name),
    constraint fk_super_category foreign key(name) references category(name)
);

create table has_other (
    super_category varchar(255) not null,
    category varchar(255) not null,
    constraint pk_has_other primary key(category),
    constraint fk_has_other_super_category foreign key(super_category) references super_category(name),
    constraint fk_has_other_category foreign key(category) references category(name)
);

create table product (
    ean char(13) not null,
    cat varchar(255) not null,
    descr varchar(255) not null,
    constraint pk_product primary key(ean),
    constraint fk_product_category foreign key(cat) references category(name)
);

create table has_category(
    ean char(13) not null,
    name varchar(255) not null,
    constraint pk_has_category primary key(ean, name),
    constraint fk_has_category_product foreign key(ean) references product(ean),
    constraint fk_has_category_category foreign key(name) references category(name)
);

create table ivm(
    serial_number char(20) not null,
    manuf varchar(255) not null,
    constraint pk_ivm primary key(serial_number, manuf)
);

create table retail_point (
    name varchar(255) not null,
    district varchar(255) not null,
    county varchar(255) not null,
    constraint pk_retail_point primary key(name)
);


create table installed_in (
    serial_number char(20) not null,
    manuf varchar(255) not null,
    local varchar(255) not null,
    constraint pk_installed_in primary key(serial_number, manuf),
    constraint fk_installed_in_ivm foreign key(serial_number, manuf) references ivm(serial_number, manuf),
    constraint fk_installed_in_retail_point foreign key(local) references retail_point(name)
);

create table shelf (
    number int not null,
    serial_number char(20) not null,
    manuf varchar(255) not null,
    height real not null,
    name varchar(255) not null,
    constraint pk_shelf primary key(number, serial_number, manuf),
    constraint fk_shelf_ivm foreign key(serial_number, manuf) references ivm(serial_number, manuf),
    constraint fk_shelf_category foreign key(name) references category(name)
);

create table planogram (
    ean char(13) not null,
    number int not null,
    serial_number char(20) not null,
    manuf varchar(255) not null,
    faces int not null,
    units int not null,
    loc int not null,
    constraint pk_planogram primary key(ean, number, serial_number, manuf),
    constraint fk_planogram_product foreign key(ean) references product(ean),
    constraint fk_planogram_shelf foreign key(number, serial_number, manuf) references shelf(number, serial_number, manuf)
);

create table retailer (
    tin char(9) not null,
    name varchar(255) not null unique,
    constraint pk_retailer primary key(tin)
);

create table responsible_for (
    category_name varchar(255) not null,
    tin char(9) not null,
    serial_number char(20) not null,
    manuf varchar(255) not null,
    constraint pk_responsible_for primary key(serial_number, manuf),
    constraint fk_responsible_for_ivm foreign key(serial_number, manuf) references ivm(serial_number, manuf),
    constraint fk_responsible_for_retailer foreign key(tin) references retailer(tin),
    constraint fk_responsible_for_category foreign key(category_name) references category(name)
);

create table resupply_event(
    ean char(13) not null,
    number int not null,
    serial_number char(20) not null,
    manuf varchar(255) not null,
    instant timestamp not null,
    units int not null,
    tin char(9) not null,
    constraint pk_resuply_event primary key(ean, number, serial_number, manuf, instant),
    constraint fk_resuply_event_planogram foreign key(ean, number, serial_number, manuf) references planogram(ean, number, serial_number, manuf),
    constraint fk_resuply_event_retailer foreign key(tin) references retailer(tin)
);

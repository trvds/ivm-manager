-- Table: category
-- INSERT INTO category VALUES ('category');
INSERT INTO category VALUES ('Doces');
INSERT INTO category VALUES ('Salgados');
INSERT INTO category VALUES ('Bolos');
INSERT INTO category VALUES ('Chocolates');
INSERT INTO category VALUES ('Bebidas');
INSERT INTO category VALUES ('Refrigerantes');
-- Table: simple_category
-- INSERT INTO simple_category VALUES ('category');
INSERT INTO simple_category VALUES ('Bolos');
INSERT INTO simple_category VALUES ('Chocolates');
INSERT INTO simple_category VALUES ('Refrigerantes');

-- Table: super_category
-- INSERT INTO super_category VALUES ('category');
INSERT INTO super_category VALUES ('Doces');
INSERT INTO super_category VALUES ('Salgados');
INSERT INTO super_category VALUES ('Bebidas');

-- Table: has_other
-- INSERT INTO has_other VALUES ('category', 'category');
INSERT INTO has_other VALUES ('Doces', 'Bolos');
INSERT INTO has_other VALUES ('Doces', 'Chocolates');
INSERT INTO has_other VALUES ('Bebidas', 'Refrigerantes');

-- Table: product
-- INSERT INTO product VALUES ('ean', 'category', 'descr');
INSERT INTO product VALUES ('4486942345738', 'Bolos', 'Bolo de chocolate');
INSERT INTO product VALUES ('7446669566976', 'Bolos', 'Bolo de baunilha');
INSERT INTO product VALUES ('0506275190843', 'Refrigerantes', 'Coca-Cola');

-- Table: has_category
-- INSERT INTO has_category VALUES ('ean', 'category');
INSERT INTO has_category VALUES ('4486942345738', 'Bolos');
INSERT INTO has_category VALUES ('7446669566976', 'Bolos');
INSERT INTO has_category VALUES ('0506275190843', 'Refrigerantes');

-- Table: ivm
-- INSERT INTO ivm VALUES ('serial_number', 'manuf');
INSERT INTO ivm VALUES ('1234567890123456789', 'Bosch');
INSERT INTO ivm VALUES ('1234567890987654321', 'Makita');
INSERT INTO ivm VALUES ('1321412315324324242', 'Makita');


-- Table: retail_point
-- INSERT INTO retail_point VALUES ('name', 'district', 'county');
INSERT INTO retail_point VALUES ('Estação de Serviço - Galp', 'Lisboa', 'Oeiras');
INSERT INTO retail_point VALUES ('Adega do Fredo', 'Viana do Castelo', 'Caminha');

-- Table: installed_in
-- INSERT INTO installed_in VALUES ('serial_number', 'manuf', 'local');
INSERT INTO installed_in VALUES ('1234567890123456789', 'Bosch', 'Adega do Fredo');
INSERT INTO installed_in VALUES ('1321412315324324242', 'Makita', 'Estação de Serviço - Galp');
INSERT INTO installed_in VALUES ('1234567890987654321', 'Makita', 'Estação de Serviço - Galp');

-- Table: shelf
-- INSERT INTO shelf VALUES ('number', 'serial_number', 'manuf', height, name);
INSERT INTO shelf VALUES ('1', '1234567890123456789', 'Bosch', '3', 'Bolos');
INSERT INTO shelf VALUES ('2', '1234567890123456789', 'Bosch', '3', 'Chocolates');
INSERT INTO shelf VALUES ('3', '1234567890123456789', 'Bosch', '3', 'Refrigerantes');

INSERT INTO shelf VALUES ('1', '1321412315324324242', 'Makita', '3', 'Bolos');
INSERT INTO shelf VALUES ('2', '1321412315324324242', 'Makita', '3', 'Chocolates');
INSERT INTO shelf VALUES ('3', '1321412315324324242', 'Makita', '3', 'Refrigerantes');

INSERT INTO shelf VALUES ('1', '1234567890987654321', 'Makita', '3', 'Bolos');
INSERT INTO shelf VALUES ('2', '1234567890987654321', 'Makita', '3', 'Chocolates');
INSERT INTO shelf VALUES ('3', '1234567890987654321', 'Makita', '3', 'Refrigerantes');

-- Table: planogram
-- INSERT INTO planogram VALUES ('ean', 'number', 'serial_number', 'manuf', 'faces', 'units', 'loc');
INSERT INTO planogram VALUES ('4486942345738', '1', '1234567890123456789', 'Bosch', '3', '20', '3');
INSERT INTO planogram VALUES ('7446669566976', '1', '1234567890123456789', 'Bosch', '3', '12', '1');
INSERT INTO planogram VALUES ('0506275190843', '3', '1234567890123456789', 'Bosch', '2', '14', '2');

INSERT INTO planogram VALUES ('4486942345738', '1', '1234567890987654321', 'Makita', '3', '13', '3');

INSERT INTO planogram VALUES ('7446669566976', '1', '1321412315324324242', 'Makita', '3', '12', '1');
INSERT INTO planogram VALUES ('0506275190843', '3', '1321412315324324242', 'Makita', '5', '23', '2');

-- Table: retailer
-- INSERT INTO retailer VALUES ('tin', 'name');
INSERT INTO retailer VALUES ('123456789', 'Fredo');
INSERT INTO retailer VALUES ('987654321', 'Mariana');

-- Table: responsible_for
-- INSERT INTO responsible_for VALUES ('category_name', 'tin', 'serial_number', 'manuf');
INSERT INTO responsible_for VALUES ('Bolos', '123456789', '1234567890123456789', 'Bosch');
INSERT INTO responsible_for VALUES ('Bolos', '123456789', '1321412315324324242', 'Makita');
INSERT INTO responsible_for VALUES ('Bolos', '987654321', '1234567890987654321', 'Makita');
/*
INSERT INTO responsible_for VALUES ('Chocolates', '123456789', '1234567890123456789', 'Bosch');
INSERT INTO responsible_for VALUES ('Chocolates', '123456789', '1321412315324324242', 'Makita');
INSERT INTO responsible_for VALUES ('Chocolates', '987654321', '1234567890987654321', 'Makita');
INSERT INTO responsible_for VALUES ('Refrigerantes', '123456789', '1234567890123456789', 'Bosch');
INSERT INTO responsible_for VALUES ('Refrigerantes', '987654321', '1321412315324324242', 'Makita');
INSERT INTO responsible_for VALUES ('Refrigerantes', '987654321', '1234567890987654321', 'Makita');
*/

-- Table: resupply_event
-- INSERT INTO resupply_event VALUES ('ean', 'number', 'serial_number', 'manuf', 'instant', 'units', 'tin');
INSERT INTO resupply_event VALUES ('4486942345738', '1', '1234567890123456789', 'Bosch', '2022-01-01 00:00:00', '20', '123456789');
INSERT INTO resupply_event VALUES ('7446669566976', '1', '1234567890123456789', 'Bosch', '2022-01-01 00:00:00', '12', '123456789');
INSERT INTO resupply_event VALUES ('0506275190843', '3', '1234567890123456789', 'Bosch', '2022-01-01 00:00:00', '12', '123456789');

INSERT INTO resupply_event VALUES ('4486942345738', '1', '1234567890987654321', 'Makita', '2022-01-01 00:00:00', '10', '987654321');

INSERT INTO resupply_event VALUES ('7446669566976', '1', '1321412315324324242', 'Makita', '2022-01-01 00:00:00', '8', '123456789');
INSERT INTO resupply_event VALUES ('0506275190843', '3', '1321412315324324242', 'Makita', '2022-01-01 00:00:00', '10', '987654321');

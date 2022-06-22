--7.1
CREATE INDEX resp_cat_idx ON responsible_for(category_name) INCLUDE (tin);
CREATE INDEX retailer_idx ON retailer(tin) INCLUDE (name);

--7.2
CREATE INDEX prod_desc_idx ON product(descr) INCLUDE (cat);
CREATE INDEX has_cat_name_idx ON has_category(name) INCLUDE (ean);

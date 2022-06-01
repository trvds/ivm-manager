has(<u>ean, name</u>)

- ean: FK(Product)
- name: FK(Category)

responsible-for(<u>name, tin, serial_number, manuf</u>)

- name: FK(Category)
- tin: FK(Retailer)
- serial_number, manuf: FK(IVM)

installed-at(<u>serial_number, manuf, adress</u>, nr):

- serial_number, manuf: FK(IVM)
- adress: FK(Point of Retail)

planogram(<u>ean, nr, serial_number, manuf</u>, faces, units, loc):

- ean: FK(Product)
- nr: FK(Shelve)
- serial_number, manuf: FK(IVM)

replenishment(<u>instant, ean, nr, serial_number, manuf</u>)

- instant: FK(Replenishment Event)
- ean: FK(Product)
- nr: FK(Shelve)
- serial_number, manuf: FK(IVM)

has-other(<u>category_name</u>, <u>super_category_name</u>):

- IC-1: A category can't be contained in itself
- IC-2 There can't be any cycles in the categories hierarchy
- category_name: FK(category.name)
- super_category_name: FK(super_category.name)

shelve(<u>serial_number, manuf, nr</u>, name, height)

- IC-7: No shelve can exist at the same time in 'ambient_temp_shelf', 'warm_shelf' and in 'colde_shelf'
- serial_number, manuf: FK(IVM)
- name: FK(category)

ambient_temp_shelf(<u>serial_number, manuf, nr</u>)

- serial_number, manuf: FK(IVM)
- nr: FK(shelve.nr)

warm_shelf(<u>serial_number, manuf, nr</u>)

- serial_number, manuf: FK(IVM)
- nr: FK(shelve.nr)

cold_shelf(<u>serial_number, manuf, nr</u>)

- serial_number, manuf: FK(IVM)
- nr: FK(shelve.nr)

replenishment_event(<u>serial_number, manuf, nr, instant</u>,tin, units)

- serial_number, nr: FK(shelve.serial_number, shelve.nr)
- tin: FK(Retailler)

product(<u>ean</u>, descr)

- IC-8: Every Product (ean) must participate in the has association

category(<u>name</u>)

- IC-9: No category can exist at the same time in 'simple_category' and in 'super_category'

simple_category(<u>name</u>)

- name: FK(category.name)

super_category(<u>name</u>)

- name: FK(category.name)

retailer(<u>tin</u>, name)

- UNIQUE(name)

ivm(<u>serial_number</u>, <u>manuf</u>)

point_of_retail(<u>adress</u>, name)

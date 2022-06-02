ivm(<u>serial_number, manuf</u>)

shelve(<u>serial_number, manuf, nr</u>, name, height)

- IC-7: No shelve can exist at the same time in 'ambient_temp_shelf', 'warm_shelf' and in 'cold_shelf'
- IC-8: A shelve must exist in one of 'ambient_temp_shelf', 'warm_shelf' and in 'cold_shelf'
- serial_number, manuf: FK(ivm.serial_number, ivm.manuf)
- name: FK(category.name)

ambient_temp_shelf(<u>serial_number, manuf, nr</u>)

- serial_number, manuf: FK(ivm,serial_number, ivm.manuf)
- nr: FK(shelve.nr)

warm_shelf(<u>serial_number, manuf, nr</u>)

- serial_number, manuf: FK(ivm.serial_number, ivm.manuf)
- nr: FK(shelve.nr)

cold_shelf(<u>serial_number, manuf, nr</u>)

- serial_number, manuf: FK(ivm.serial_number, ivm.manuf)
- nr: FK(shelve.nr)

replenishment_event(<u>instant, nr, serial_number, manuf, ean</u>, tin, units)

- serial_number, manuf, nr, ean: FK(planogram.serial_number, planogram.manuf, planogram.nr, planogram.ean)
- tin: FK(retailler.tin)

product(<u>ean</u>, descr)

- IC-9: Every Product (ean) must participate in the has association

category(<u>name</u>)

- IC-10: No category can exist at the same time in 'simple_category' and in 'super_category'
- IC-11: Every category must exist in either 'simple_category' or 'super_category'

simple_category(<u>name</u>)

- name: FK(category.name)

super_category(<u>name</u>)

- name: FK(category.name)

- IC-12: Every super_category must exist in an has-other relation

retailer(<u>tin</u>, name)

- UNIQUE(name)

point_of_retail(<u>adress</u>, name)

has(<u>ean, name</u>)

- ean: FK(product.ean)
- name: FK(category.name)

responsible-for(<u>name, tin, serial_number, manuf</u>)

- name: FK(category.name)
- tin: FK(retailer.tin)
- serial_number, manuf: FK(ivm.serial_number, ivm.manuf)

installed-at(<u>serial_number, manuf</u>, adress, nr):

- serial_number, manuf: FK(ivm.serial_number, ivm.manuf)
- adress: FK(point_of_retail.adress)

planogram(<u>ean, nr, serial_number, manuf</u>, faces, units, loc):

- ean: FK(product.ean)
- nr: FK(shelve.nr)
- serial_number, manuf: FK(ivm.serial_number, ivm.manuf)

- IC-4: The number of replenished units from a Replenishment Event can't exceed the number of units specified in the planogram.

has-other(<u>category_name</u>, super_category_name):

- IC-1: A category can't be contained in itself
- IC-2 There can't be any cycles in the categories hierarchy
- category_name: FK(category.name)
- super_category_name: FK(super_category.name)

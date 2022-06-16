DROP VIEW IF EXISTS Vendas;

CREATE VIEW Vendas(ean, cat, ano, trimestre, dia_mes, dia_semana, distrito, concelho, unidades)
AS
SELECT resupply_event.units AS unidades, product.ean, product.name AS cat, 
retail_point.district AS distrito, retail_point.county AS concelho
EXTRACT(YEAR FROM resupply_event.instant) AS ano,
EXTRACT(QUARTER FROM resupply_event.instant) AS trimestre,
EXTRACT(DAY FROM resupply_event.instant) AS dia_mes,
EXTRACT(DOY FROM resupply_event.instant) AS dia_semana
FROM resupply_event, product, retail_point
WHERE resupply_event.ean = product.ean AND
installed_at.retail_point = retail_point AND
installed_at.serial_number = planogram.serial_number AND
planogram.ean = product.ean
-- 1. Find the model number, speed and hard drive capacity for all the PCs with prices below $500.Result set: model, speed, hd.
SELECT model, speed, hd 
FROM PC
WHERE price < 500

-- 2. List all printer makers. Result set: maker.
SELECT DISTINCT maker AS Maker
FROM Product
WHERE type = 'Printer'

-- 3. Find the model number, RAM and screen size of the laptops with prices over $1000.
SELECT model, ram, screen 
FROM Laptop
WHERE price > 1000

-- 4. Find all records from the Printer table containing data about color printers.
SELECT *
FROM Printer
WHERE color = 'y'

-- 5. Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.
SELECT model, speed, hd
FROM PC
WHERE (cd = '12x' OR cd = '24x') AND price < 600

-- 6. For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. Result set: maker, speed.
SELECT DISTINCT Product.maker, Laptop.speed
FROM Product LEFT JOIN
Laptop ON Laptop.model = Product.model
WHERE hd >= 10

-- 7. Find out the models and prices for all the products (of any type) produced by maker B.
SELECT Product.model, PC.price
FROM PC INNER JOIN   
     Product ON PC.model = Product.model
WHERE Product.maker = 'B'
UNION
SELECT Product.model, Laptop.price
FROM Laptop INNER JOIN   
     Product ON Laptop.model = Product.model
WHERE Product.maker = 'B'
UNION
SELECT Product.model, Printer.price
FROM Printer INNER JOIN   
     Product ON Printer.model = Product.model
WHERE Product.maker = 'B'

-- 8. Find the makers producing PCs but not laptops.
SELECT maker FROM Product
WHERE type IN ('PC')
EXCEPT
SELECT maker FROM Product WHERE type IN ('Laptop')

select distinct maker
from Product
where type = 'PC'
and maker not in
(select distinct maker
from Product
where type = 'Laptop')

-- 9. Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.
SELECT maker AS Maker
FROM Product LEFT JOIN
     PC ON Product.model = PC.model
WHERE PC.speed >= 450
GROUP BY maker


-- 10. Find the printer models having the highest price. Result set: model, price.
SELECT model, price
FROM Printer
WHERE price = (SELECT MAX(price) 
 FROM Printer)
 
 -- 11. Find out the average speed of PCs.
select avg(speed)
from PC

-- 12. 

-- 35. Find models in the Product table consisting either of digits only or Latin letters (A-Z, case insensitive) only. Result set: model, type.
select model, type
from Product
where model not like '%[^0-9]%' or model not like '%[^a-z]%'
or model not like '%[^A-Z]%'


-- 41. For the PC in the PC table with the maximum code value, obtain all its characteristics (except for the code) and display them in two columns:
-- - name of the characteristic (title of the corresponding column in the PC table);
-- - its respective value.
select distinct maker, speed
from Product, Laptop
where Product.model = Laptop.model
and hd >= 10;

select 'cd' as chr, cd as value 
from PC 
where code = (select max(code) from PC)

union

select  'model' as chr, cast(model as varchar) as value 
from PC 
where code = (select max(code) from PC)

union

select  'speed' as chr, cast(speed as varchar) as value 
from PC 
where code = (select max(code) from PC)

union

select  'ram' as chr, cast(ram as varchar) as value 
from PC 
where code = (select max(code) from PC)

union

select  'hd' as chr, cast(hd as varchar)  as value 
from PC 
where code = (select max(code) from PC)

union

select  'price' as chr, cast(price as varchar) as value 
from PC 
where code = (select max(code) from PC)

-- 51. Find the names of the ships with the largest number of guns among all ships having the same displacement (including ships in the Outcomes table).
select s.name
from Ships as s, Classes as c
where s.class = c.class
and c.numGuns = (select max(numGuns)
from Classes
where Classes.displacement = c.displacement)

union

select o.ship
from Outcomes as o, Classes as c
where o.ship = c.class
and c.numGuns = (select max(numGuns)
from Classes
where Classes.displacement = c.displacement)
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
FROM Product LEFT JOIN Laptop 
ON Laptop.model = Product.model
WHERE hd >= 10

-- 7. Find out the models and prices for all the products (of any type) produced by maker B.
SELECT Product.model, PC.price
FROM PC INNER JOIN Product 
ON PC.model = Product.model
WHERE Product.maker = 'B'
UNION
SELECT Product.model, Laptop.price
FROM Laptop INNER JOIN Product 
ON Laptop.model = Product.model
WHERE Product.maker = 'B'
UNION
SELECT Product.model, Printer.price
FROM Printer INNER JOIN Product 
ON Printer.model = Product.model
WHERE Product.maker = 'B'

-- 8. Find the makers producing PCs but not laptops.
SELECT maker 
FROM Product
WHERE type IN ('PC')
EXCEPT
SELECT maker 
FROM Product 
WHERE type IN ('Laptop')

select distinct maker
from Product
where type = 'PC'
and maker not in (
	select distinct maker
	from Product
	where type = 'Laptop'
)

-- 9. Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.
SELECT maker AS Maker
FROM Product LEFT JOIN PC 
ON Product.model = PC.model
WHERE PC.speed >= 450
GROUP BY maker

-- 10. Find the printer models having the highest price. Result set: model, price.
SELECT model, price
FROM Printer
WHERE price = (
	SELECT MAX(price) 
	FROM Printer
)
 
 -- 11. Find out the average speed of PCs.
SELECT AVG(speed)
FROM PC

-- 12. Find out the average speed of the laptops priced over $1000.
SELECT AVG(speed)
FROM Laptop
WHERE price > 1000

-- 13. Find out the average speed of the PCs produced by maker A.
SELECT AVG(PC.speed)
FROM Product LEFT JOIN PC 
ON PC.model = Product.model
WHERE Product.maker = 'A'

-- 14. Get the makers who produce only one product type and more than one model. Output: maker, type.
SELECT DISTINCT maker, MAX(type) as type
FROM Product
GROUP BY maker
HAVING COUNT(distinct type) = 1 
AND COUNT(model) > 1

-- 15. Get hard drive capacities that are identical for two or more PCs. Result set: hd.
SELECT hd
FROM PC
GROUP BY hd
HAVING COUNT(hd) >= 2

-- 16. Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i). 
-- Result set: model with the bigger number, model with the smaller number, speed, and RAM.
SELECT DISTINCT pc1.model, pc2.model, pc1.speed, pc1.ram
FROM PC AS pc1 JOIN PC AS pc2
ON pc1.speed = pc2.speed 
AND pc1.ram = pc2.ram
WHERE pc1.model > pc2.model

-- 17. Get the laptop models that have a speed smaller than the speed of any PC. Result set: type, model, speed.
SELECT DISTINCT pr.type AS Type, l.model as Model, l.speed
FROM Product AS pr JOIN Laptop as l
ON pr.model = l.model
WHERE l.speed < ALL (
	SELECT speed
	FROM PC
)

-- 18. Find the makers of the cheapest color printers.Result set: maker, price.
SELECT DISTINCT Product.maker, Printer.price 
FROM Product JOIN Printer 
ON Product.model = Printer.model 
WHERE Printer.color = 'y' 
AND Printer.price = (
	SELECT MIN(price)
	FROM Printer
	WHERE color = 'y'
)

-- 19. For each maker having models in the Laptop table, find out the average screen size of the laptops he produces. Result set: maker, average screen size.
SELECT pr.maker, AVG(l.screen)
FROM Product as pr 
JOIN Laptop AS l 
ON pr.model= l.model
GROUP BY pr.maker

-- 20. Find the makers producing at least three distinct models of PCs. Result set: maker, number of PC models.
SELECT maker, COUNT(model)
FROM Product
WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(model) >= 3

-- 21. Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price.
SELECT pr.maker, MAX(DISTINCT pc.price)
FROM Product AS pr
JOIN PC AS pc
ON pr.model= pc.model
GROUP BY pr.maker

-- 22. For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds. Result set: speed, average price.
SELECT speed, AVG(price)
FROM PC
WHERE speed > 600
GROUP BY speed

--23. Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher. Result set: maker
SELECT DISTINCT maker
FROM Product
WHERE maker IN (
	SELECT DISTINCT maker 
	FROM Product AS pr
	JOIN PC as pc
	ON pr.model = pc.model
	WHERE pc.speed >= 750
)
AND maker IN (
	SELECT DISTINCT maker 
	FROM Product AS pr 
	JOIN Laptop AS l
	ON pr.model = l.model
	WHERE l.speed >= 750
)

--24. List the models of any type having the highest price of all products present in the database.
WITH max
AS (
	SELECT model, price FROM PC
	UNION 
	SELECT model, price FROM Laptop
	UNION 
	SELECT model, price FROM printer
)

SELECT model FROM max
WHERE price = (
	SELECT MAX(price) 
	FROM max
)

--25. Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity. Result set: maker.
select distinct maker
from Product join PC
on Product.model = PC.model
where ram = (
	select min(ram)
	from PC
)
and speed = (
	select max(speed)
	from PC
	where ram = (
		select min(ram)
		from PC)
	)
and maker in (
	select maker
	from Product
	where type='Printer'
)

-- 26. Find out the average price of PCs and laptops produced by maker A. Result set: one overall average price for all items.
select avg(price)
from (
	select price
	from Product join PC
	on Product.model = PC.model
	where maker = 'A'
	union all
	select price
	from Product join Laptop
	on Product.model = Laptop.model
	where maker='A'
) as AVG_price

--27. Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers. Result set: maker, average HDD capacity.
select pr.maker, avg(pc.hd)
from Product as pr join PC as pc 
on pr.model = pc.model
where maker in (
	select distinct maker
	from Product
	where type='Printer'
)
group by maker

-- 28. Using Product table, find out the number of makers who produce only one model.
with total_count
as (
	select maker
	from product 
	group by maker 
	having count(model) = 1
)

select count(maker)
from total_count

--29. Under the assumption that receipts of money (inc) and payouts (out) are registered not more than once a day for each collection point 
-- [i.e. the primary key consists of (point, date)], 
-- write a query displaying cash flow data (point, date, income, expense). Use Income_o and Outcome_o tables.
select i.point, i.date, i.inc, o.out
from Income_o i left join Outcome_o o
on i.point = o.point
and i.date = o.date

union
select o.point, o.date, i.inc, o.out
from Outcome_o o left join Income_o i
on o.point = i.point
and o.date = i.date

-- 30. Under the assumption that receipts of money (inc) and payouts (out) can be registered any number of times a day for each collection point 
-- [i.e. the code column is the primary key], display a table with one corresponding row for each operating date of each collection point.
-- Result set: point, date, total payout per day (out), total money intake per day (inc). Missing values are considered to be NULL.
select i.point, i.date, o.out, i.inc
from (
	select point, date, sum(inc) as inc
	from Income
	group by point, date
) as i
left join (
	select point, date, sum(out) as out
	from Outcome
	group by point, date
) as o
on i.point = o.point
and i.date = o.date

union
select o.point, o.date, o.out, i.inc
from (
	select point, date, sum(out) as out
	from Outcome
	group by point, date
) as o
left join (
	select point, date, sum(inc) as inc
	from Income
	group by point, date
) as i
on o.point = i.point
and o.date = i.date

-- 31. For ship classes with a gun caliber of 16 in. or more, display the class and the country.
select class, country
from Classes
where bore >= 16.0

-- 32. One of the characteristics of a ship is one-half the cube of the calibre of its main guns (mw). Determine the average.
with total 
as (
	select country, bore, name
	from Classes join Ships
	on Classes.class = Ships.class
	
	union
	select country, bore, ship
	from Classes join Outcomes
	on Classes.class = Outcomes.ship
)

select country, cast(round(avg(power(bore,3)*0.5),2) as numeric(10,2)) as weight 
from total
group by country

-- 33. Get the ships sunk in the North Atlantic battle. Result set: ship.
select ship
from Outcomes
where result = 'sunk'
and battle = 'North Atlantic'

-- 34. In accordance with the Washington Naval Treaty concluded in the beginning of 1922, it was prohibited to build battle ships with a displacement of more than 35 thousand tons. 
-- Get the ships violating this treaty (only consider ships for which the year of launch is known). List the names of the ships.
select distinct name 
from Classes as cl join Ships as sh 
on cl.class = sh.class 
where launched >= 1922 
and displacement > 35000
and type = 'bb'

-- 35. Find models in the Product table consisting either of digits only or Latin letters (A-Z, case insensitive) only. Result set: model, type.
select model, type
from Product
where model not like '%[^0-9]%' or model not like '%[^a-z]%'
or model not like '%[^A-Z]%'

-- 36. List the names of lead ships in the database (including the Outcomes table).
select name
from Ships
where name in (
	select class
	from Classes
)

union
select ship
from Outcomes
where ship in (
	select class
	from Classes
)

-- 37. Find classes for which only one ship exists in the database (including the Outcomes table).
with total_ship
as (
	select cl.class, sh.name
	Classes as cl join Ships as sh
	on cl.class = sh.class
	
	union
	select cl.class, o.ship as name
	from Classes as cl join Outcomes as o
	on cl.class = o.ship
)

select class 
from total_ship 
group by class 
having count(class) = 1

-- 38. Find countries that ever had classes of both battleships (‘bb’) and cruisers (‘bc’).
select distinct country
from Classes
where type = 'bb'
and country in (
	select distinct country
	from Classes
	where type = 'bc'
)

-- 39. Find the ships that "survived for future battles"; that is, after being damaged in a battle, they participated in another one, which occurred later.
select distinct o2.ship 
from (
	select ship, battle, result, date
	from Outcomes join Battles
	on Outcomes.battle = Battles.name
	where result='damaged'
) as o1 
join (
	select ship, battle, result, date
	from Outcomes join Battles
	on Outcomes.battle = Battles.name
) as o2
on o1.ship = o2.ship
where o1.date < o2.date

-- 40. For the ships in the Ships table that have at least 10 guns, get the class, name, and country.
select cl.class, sh.name, cl.country
from Ships as sh, Classes as cl
where sh.class = cl.class
and numGuns >= 10

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

-- 42. Find the names of ships sunk at battles, along with the names of the corresponding battles.
select ship, battle
from Outcomes
where result = 'sunk'

-- 43. Get the battles that occurred in years when no ships were launched into water.
select name
from Battles
where year(date)
not in (
	select launched
	from Ships
	where launched is not null
)

-- 44. Find all ship names beginning with the letter R.
select name
from Ships
where name like 'R%'
union
select ship
from Outcomes
where ship like 'R%'

-- 45. Find all ship names consisting of three or more words (e.g., King George V). Consider the words in ship names to be separated by single spaces, 
-- and the ship names to have no leading or trailing spaces.
select name
from Ships
where name like '% % %'
union
select ship
from Outcomes
where ship like '% % %'

-- 46. For each ship that participated in the Battle of Guadalcanal, get its name, displacement, and the number of guns.
select distinct ship, displacement, numguns
from Classes left join Ships
on classes.class = ships.class
right join Outcomes
on Classes.class = ship
or ships.name = ship
where battle = 'Guadalcanal'

-- 47. Number the rows of the Product table as follows: makers in descending order of number of models produced by them (for manufacturers producing an equal number of models, 
-- their names are sorted in ascending alphabetical order); model numbers in ascending order. Result set: row number as described above, manufacturer's name (maker), model.
select count(*) num, t1.maker, t1.model
from (
	select maker, model, c
	from Product
	join (
		select count(model) c, maker m
		from Product
		group by maker 
	) b1
	on maker = m
) t1
join (
	select maker, model, c
	from Product
	join (
		select count(model) c, maker m
		from Product
		group by maker 
	) b2
	on maker = m
) t2
on t2.c > t1.c
or t2.c = t1.c and t2.maker < t1.maker
or t2.c = t1.c and t2.maker = t1.maker and t2.model <= t1.model
group by t1.maker, t1.model
order by 1

-- 48. Find the ship classes having at least one ship sunk in battles.
select distinct Classes.class
from Classes, Ships, Outcomes
where Classes.class = Ships.class
and Ships.name = Outcomes.ship
and Outcomes.result = 'sunk'

union
select distinct class
from Classes, Outcomes
where Classes.class = Outcomes.ship
and Outcomes.result = 'sunk'

-- 49. Find the names of the ships having a gun caliber of 16 inches (including ships in the Outcomes table).
select name
from Ships, Classes
where Ships.class = Classes.class
and bore = 16

union
select ship
from Outcomes, Classes
where Outcomes.ship = Classes.class
and bore = 16

-- 50. Find the battles in which Kongo-class ships from the Ships table were engaged.
select battle
from Outcomes, Ships
where Outcomes.ship = Ships.name
and Ships.class = 'Kongo'

-- 51. Find the names of the ships with the largest number of guns among all ships having the same displacement (including ships in the Outcomes table).
select s.name
from Ships as s, Classes as c
where s.class = c.class
and c.numGuns = (
	select max(numGuns)
	from Classes
	where Classes.displacement = c.displacement
)

union
select o.ship
from Outcomes as o, Classes as c
where o.ship = c.class
and c.numGuns = (
	select max(numGuns)
	from Classes
	where Classes.displacement = c.displacement
)

-- 52. Determine the names of all ships in the Ships table that can be a Japanese battleship having at least nine main guns with 
-- a caliber of less than 19 inches and a displacement of not more than 65 000 tons.
select name 
from Ships, Classes
where Ships.class = Classes.class 
and (country = 'Japan' or country is null) 
and (numGuns >= 9 or numGuns is null)     
and (bore < 19 or bore is null) 
and (displacement <= 65000 or displacement is null) 
and (type = 'bb' or type is null)

-- 53. With a precision of two decimal places, determine the average number of guns for the battleship classes.
select cast(avg(cast(numGuns as numeric(6,2))) as numeric(6,2)) as 'Avg-numGuns'
from Classes
where type = 'bb'

-- 54. With a precision of two decimal places, determine the average number of guns for all battleships (including the ones in the Outcomes table).
select cast(avg(cast(numGuns as numeric(6,2))) as numeric(6,2)) as 'Avg-numGuns'
from
( 
   select c1.numGuns 
   from Classes c1 
       join Ships s1 
       on c1.class = s1.class 
       where c1.type='bb'  
   union all 
   select c2.numGuns 
   from Classes c2 
       join Outcomes o2 
	   on c2.class = o2.ship 
       where c2.type='bb' 
       and o2.ship not in (select sx.name from Ships sx) 
) t

-- 55. For each class, determine the year the first ship of this class was launched. 
-- If the lead ship’s year of launch is not known, get the minimum year of launch for the ships of this class.
-- Result set: class, year.
select C.class, 
case when S.launched si null then (
	select min(launched) 
	from Ships as S 
	where S.class = C.class
) 
else S.launched end
from Classes as C 
left join Ships as S
on C.class = S.name

-- 56. For each class, find out the number of ships of this class that were sunk in battles. 
-- Result set: class, number of ships sunk.
select class, sum(sunks) as sunks 
from (
	select class, sum(case result when 'sunk' then 1 else 0 end) as sunks 
	from Classes c left join Outcomes o 
	on c.class = o.ship
	where class not in (select name from Ships) 
	group by class

	union all
	select class, sum(case result when 'sunk' then 1 else 0 end) as sunks
	from Ships s left join Outcomes o 
	on s.name = o.ship
	group by class
) as x

group by class

-- 57. For classes having irreparable combat losses and at least three ships in the database, display the name of the class and the number of ships sunk.
SELECT C.class, COUNT(result) 
FROM classes AS c 
JOIN ships AS s 
ON c.class = s.class 
LEFT JOIN outcomes AS o 
ON o.ship = s.name 
WHERE result = 'sunk' 
AND c.class IN (
	SELECT c.class 
	FROM classes AS c 
	JOIN ships AS s
	ON c.class = s.class 
	LEFT JOIN outcomes AS o 
	ON o.ship = s.name 
	GROUP BY c.class 
	HAVING count(name) >= 3) 
GROUP BY c.class 
HAVING COUNT(result) IS NOT NULL

-- 58. For each product type and maker in the Product table, find out, with a precision of two decimal places, the percentage ratio of the number of models of the actual type produced 
-- by the actual maker to the total number of models by this maker.
-- Result set: maker, product type, the percentage ratio mentioned above.


-- 59. Calculate the cash balance of each buy-back center for the database with money transactions being recorded not more than once a day.
-- Result set: point, balance.

-- (COALESCE (ss.inc, 0) - COALESCE (dd.out, 0))
SELECT ss.point,
CASE 
	WHEN inc IS NULL 
	THEN 0 
	ELSE inc 
END -
CASE 
	WHEN out IS NULL 
	THEN 0
	ELSE out 
END
FROM (
	SELECT point, SUM(inc) inc
	FROM Income_o
	GROUP BY point
) AS ss
FULL JOIN (
	SELECT point, SUM(out) out 
	FROM Outcome_o
	GROUP BY point
 ) AS dd
 ON ss.point = dd.point

-- 60. For the database with money transactions being recorded not more than once a day, calculate the cash balance of each buy-back center at the beginning of 4/15/2001. 
-- Note: exclude centers not having any records before the specified date.
-- Result set: point, balance
SELECT i.point, 
CASE 
	WHEN inc IS NULL 
	THEN 0 
	ELSE inc 
END -
CASE 
	WHEN out IS NULL 
	THEN 0
	ELSE out 
END
FROM (
	SELECT point, SUM(inc) inc
	FROM Income_o
	WHERE '20010415' > date
	GROUP BY point
) AS I 
FULL JOIN (
	SELECT point, SUM(out) out 
	FROM Outcome_o
	WHERE '20010415' > date
	GROUP BY point
 ) AS III 
 ON III.point = I.point
 
 -- 61. For the database with money transactions being recorded not more than once a day, calculate the total cash balance of all buy-back centers.
SELECT SUM(
CASE 
	WHEN inc IS NULL 
	THEN 0 
	ELSE inc 
END -
CASE 
	WHEN out IS NULL 
	THEN 0
	ELSE out 
END)
FROM (
	SELECT point, SUM(inc) inc
	FROM Income_o
	GROUP BY point
) AS I 
FULL JOIN (
	SELECT point, SUM(out) out 
	FROM Outcome_o
	GROUP BY point
 ) AS III 
 ON III.point = I.point
 
 -- 62. For the database with money transactions being recorded not more than once a day, calculate the total cash balance of all buy-back centers at the beginning of 04/15/2001.
SELECT SUM(
CASE 
	WHEN inc IS NULL 
	THEN 0 
	ELSE inc 
END -
CASE 
	WHEN out IS NULL 
	THEN 0
	ELSE out 
END)
FROM (
	SELECT point, SUM(inc) inc
	FROM Income_o
        WHERE '20010415' > date
	GROUP BY point
) AS I 
FULL JOIN (
	SELECT point, SUM(out) out 
	FROM Outcome_o
	WHERE '20010415' > date
	GROUP BY point
 ) AS III 
 ON III.point = I.point
 
 -- 63. Find the names of different passengers that ever travelled more than once occupying seats with the same number.
SELECT p.name
FROM Passenger p JOIN Pass_in_trip pt
ON p.ID_psg = pt.ID_psg
GROUP BY p.name, p.id_psg
HAVING COUNT(DISTINCT pt.place) < COUNT(*)

-- 64. 
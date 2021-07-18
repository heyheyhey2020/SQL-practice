-- In SQL Server, assuming you can find the result by using both joins and subqueries, which one would you prefer to use and why?
-- Joins, because it has better performance

-- What is CTE and when to use it?
-- Common table expression, when want a temporary named result set it will be used. And a common table expression can include references to itself. This is referred to as a recursive common table expression.

-- What are Table Variables? What is their scope and where are they created in SQL Server?
-- A table variable is a data type that can be used within a Transact-SQL batch, stored procedure, or function—and is created and defined similarly to a table, only with a strictly defined lifetime scope
-- current level of scope while declaring
--  tempdb


-- What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?
-- Delete command is useful to delete all or specific rows from a table specified using a Where clause
-- The truncate command removes all rows of a table
-- Truncate reseeds identity values, whereas delete doesn't
-- Truncate removes all records and doesn't fire triggers
-- Truncate is faster compared to delete as it makes less use of the transaction log
-- Truncate is not possible when a table is referenced by a Foreign Key or tables are used in replication or with indexed views.​
-- Truncate has better performance since truncate makes less use of the transaction log

-- What is Identity column? How does DELETE and TRUNCATE affect it?
-- Identity column of a table is a column whose value increases automatically. The value in an identity column is created by the server.
-- Truncate reseeds identity values, whereas delete doesn't.​

-- What is difference between “delete from table_name” and “truncate table table_name”?
-- Both remove rows in table
-- truncate has better performance and the reason is above.


use Northwind
go


-- List all cities that have both Employees and Customers.
select distinct a.city from dbo.Customers as a
join dbo.Employees as b
on a.city = b.city

-- List all cities that have Customers but no Employee. Use sub-query
select distinct city from dbo.Customers
where city not in
(select distinct city from dbo.Employees)


-- List all cities that have Customers but no Employee. Do not use sub-query
select distinct a.city from dbo.Customers as a
left join dbo.Employees as b
on a.city = b.city
where b.city is null

-- List all products and their total order quantities throughout all orders
select a.ProductID, a.ProductName, a.UnitPrice, sum(b.Quantity)
from dbo.Products as a
join dbo.[Order Details] as b
on a.ProductID = b.ProductID
group by a.ProductID, a.ProductName, a.UnitPrice

-- List all Customer Cities and total products ordered by that city
select a.ShipCity, count(b.Quantity)
from dbo.Orders as a
join dbo.[Order Details] as b
on a.OrderID=b.OrderID
group by a.ShipCity
order by a.ShipCity

-- List all Customer Cities that have at least two customers. Use union
select a.ShipCity
from
	(select ShipCity, CustomerID
	from dbo.Orders
	union 
	select ShipCity, CustomerID
	from dbo.Orders) as a
group by a.ShipCity
having count(CustomerID) >= 2


-- List all Customer Cities that have at least two customers. Use sub-query and no union
select distinct a.ShipCity
from dbo.Orders as a
join (select ShipCity, CustomerID from dbo.orders) as b
on a.ShipCity = b.ShipCity
where a.CustomerID!=b.CustomerID

-- List all Customer Cities that have ordered at least two different kinds of products.
select a.ShipCity, count(distinct b.ProductID) as [product count]
from dbo.Orders as a
join [Order Details] as b
on a.OrderID=b.OrderID
group by a.ShipCity
having count(distinct b.ProductID) >= 2
--select temp.ShipCity, count(temp.[product count])
--from
--	(select distinct a.ShipCity, b.ProductID as 'product count'
--	from Orders as a
--	join [Order Details] as b
--	on a.OrderID=b.OrderID) as temp
--group by temp.ShipCity
--having count(temp.[product count]) >= 2

-- List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities
select a.CustomerID, a.ContactName
from Customers as a
join Orders as b
on a.CustomerID=b.CustomerID
where a.City != b.ShipCity

-- List 5 most popular products, their average price, and the customer city that ordered most quantity of it
select top 5 * from (
select a.ProductID, a.ProductName, a.UnitPrice, c.ShipCity, count(c.OrderID) as [quantity count],
rank() over(partition by c.ShipCity order by count(c.OrderID) desc) as rnk
from Products as a
join [Order Details] as b
on a.ProductID=b.ProductID
join Orders as c
on b.OrderID = c.OrderID
group by a.ProductID, a.ProductName, a.UnitPrice, c.ShipCity
) as temp
where rnk = 1
order by [quantity count] desc


-- List all cities that have never ordered something but we have employees there. Use sub-query 
select distinct city
from Employees
where city not in
(select distinct ShipCity
from Orders)


-- List all cities that have never ordered something but we have employees there. Do not use sub-query 
select distinct a.City
from Employees as a
left join Orders as b
on a.city=b.ShipCity
where b.ShipCity is null


-- List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
-- most orders
select top 1 a.City, count(b.OrderID) as [order count]
from Employees as a
join Orders as b
on a.EmployeeID=b.EmployeeID
group by a.City
order by count(b.OrderID) desc
-- most total quantity
select top 1 a.City, count(c.Quantity) as [product quantity]
from Employees as a
join Orders as b
on a.EmployeeID=b.EmployeeID
join [Order Details] as c
on b.OrderID=c.OrderID
group by a.City
order by count(c.Quantity)

-- How do you remove the duplicates record of a table
-- use dinstict key workd

-- Sample table to be used for solutions below- Employee ( empid integer, mgrid integer, deptid integer, salary integer) Dept (deptid integer, deptname text) 
-- Find employees who do not manage anybody.
-- solution: 
-- select distinct a.empid from employee as a
-- left join emplyee as b on a.mgrid=b.empid
-- where a.empid id is null


-- Find departments that have maximum number of employees. (solution should consider scenario having more than 1 departments that have maximum number of employees). Result should only have - deptname, count of employees sorted by deptname
--select b.deptid, b.deptname, count(empid) 
--from employee as a
--join dept as b
--on a.deptid=b.deptid
--group by b.deptid, b.deptname
--having count(empid) = (select top 1 count(empid) as [max count] from employee group by deptid)
--order by b.deptname

-- Find top 3 employees (salary based) in every department. Result should have deptname, empid, salary sorted by deptname and then employee with high to low salary
--select a.deptname, b.empid, count(b.salary) as [salary]
--rank() over(partition by a.deptid order by a.deptname desc, count(b.salary) desc) as rnk
--from dept as a
--join employee as b
--on a.deptid=b.deptid
--group by a.deptname, b.empid
--where rnk <= 3
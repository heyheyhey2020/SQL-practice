-- What is a result set?
-- A set of rows from a database as well as metadata about the query such as the column names, and the types and sizes of each column -- refered from wikipedia

-- What is the difference between Union and Union All?
-- Union extracts the rows that are being specified in the query 
-- Union All extracts all the rows including the duplicated values from both the queries

-- What are the other Set Operators SQL Server has?
-- Intersect
-- Except

-- What is the difference between Union and Join?
-- Join is used to combine columns from different tables
-- Union is used to combine rows

-- What is the difference between INNER JOIN and FULL JOIN?
-- Inner join returns only the matching rows between both the tables, non matching rows are eliminated
-- Full Join returns all rows from both the tables, including non-matching rows from both the tables

-- What is difference between left join and outer join?
-- left join returns all rows in left table and the matching rows in right table
-- Outer join default as full join which returns all rows from both the tables, including non-matching rows from both the tables

-- What is cross join?
-- Cross join produces a result set which is the number of rows in the first table multiplied by the number of rows in the second table 
-- if no where clause is used along with cross join

-- What is the difference between WHERE clause and HAVING clause?
-- Both are used to filter data
-- having clause is used only after group by clause, where clause is used when there is no group by clause in front of it

-- Can there be multiple group by columns?
-- No, but multiple fields can by listed after group by clause


use AdventureWorks2019
go


-- How many products can you find in the Production.Product table?
select count(ProductID) from Production.Product

-- Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
select count(ProductID) from Production.Product
where ProductSubcategoryID is not null

-- How many Products reside in each SubCategory? Write a query to display the results with the following titles.
select ProductSubcategoryID, count(ProductId) as CountedProducts from Production.Product
group by ProductSubcategoryID
having ProductSubcategoryID is not null

-- How many products that do not have a product subcategory.
select count(ProductID) from Production.Product
where ProductSubcategoryID is null

-- Write a query to list the summary of products quantity in the Production.ProductInventory table.
select sum(Quantity)
from Production.ProductInventory

-- Write a query to list the summary of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
select ProductID, sum(Quantity) as TheSum
from Production.ProductInventory
where LocationID=40
group by ProductID
having sum(Quantity)<100

-- Write a query to list the summary of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
select Shelf, ProductID, sum(Quantity) as TheSum
from Production.ProductInventory
where LocationID=40
group by Shelf, ProductID
having sum(Quantity)<100

-- Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table
select avg(Quantity)
from Production.ProductInventory
where LocationID=10

-- Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
select ProductID, Shelf, avg(Quantity) as TheAvg
from Production.ProductInventory
group by ProductID, Shelf

-- Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
select ProductID, Shelf, avg(Quantity) as TheAvg
from Production.ProductInventory
where Shelf != 'N/A'
group by ProductID, Shelf

-- List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
select Color, Class, count(1) as 'TheCount', avg(ListPrice) as 'AvgPrice'
from Production.Product
where Color is not null and Class is not null
group by Color, Class



--JOIN

-- Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following. 
select a.Name as 'Country', b.Name as 'Province'
from Person.CountryRegion as a
join Person.StateProvince as b
on a.CountryRegionCode=b.CountryRegionCode

-- Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
select a.Name as 'Country', b.Name as 'Province'
from Person.CountryRegion as a
join Person.StateProvince as b
on a.CountryRegionCode=b.CountryRegionCode
where a.Name in ('Germany', 'Canada')


use Northwind
go

--List all Products that has been sold at least once in last 25 years.
select distinct a.ProductName
from dbo.Products as a
join dbo.[Order Details] as b
on a.ProductID=b.ProductID
join dbo.Orders as c
on b.OrderID=c.OrderID
where DATEDIFF( YEAR, getdate(), c.OrderDate) <= 25

-- List top 5 locations (Zip Code) where the products sold most
select top 5 ShipPostalCode, count(ShipPostalCode) as CodeCount
from dbo.Orders
group by ShipPostalCode
having ShipPostalCode is not null
order by count(ShipPostalCode) desc

-- List top 5 locations (Zip Code) where the products sold most in last 20 years
select top 5 ShipPostalCode, count(ShipPostalCode) as CodeCount
from dbo.Orders
where DATEDIFF( YEAR, getdate(), OrderDate) <= 20
group by ShipPostalCode
having ShipPostalCode is not null
order by count(ShipPostalCode) desc

-- List all city names and number of customers in that city
select ShipCity, count(CustomerID) as CustomerCount
from dbo.Orders
group by ShipCity

-- List city names which have more than 10 customers, and number of customers in that city 
select ShipCity, count(CustomerID) as CustomerCount
from dbo.Orders
group by ShipCity
having count(CustomerID) > 10

-- List the names of customers who placed orders after 1/1/98 with order date
select distinct a.ContactName, b.OrderDate
from dbo.Customers as a
join dbo.orders as b
on a.CustomerID=b.CustomerID
where b.OrderDate > '1-1-98 0:0:0'

-- List the names of all customers with most recent order dates
select a.ContactName, max(b.OrderDate) as [Most recent order date]
from dbo.Customers as a
left join dbo.orders as b
on a.CustomerID=b.CustomerID
group by a.ContactName

-- Display the names of all customers  along with the  count of products they bought 
select a.ContactName, isnull(count(b.OrderID), 0) as [count of products]
from dbo.Customers as a
left join dbo.orders as b
on a.CustomerID=b.CustomerID
group by a.ContactName

-- Display the customer ids who bought more than 100 Products with count of products
select CustomerID, count(OrderID) as [count of products]
from dbo.Orders
group by CustomerID
having count(OrderID)>100

-- List all of the possible ways that suppliers can ship their products. Display the results as below
-- Supplier Company Name   	Shipping Company Name
select a.CompanyName as [Supplier Company Name], b.CompanyName as [Shipping Company Name]
from dbo.Suppliers as a
cross join dbo.Shippers as b

-- Display the products order each day. Show Order date and Product Name
select a.ProductName, c.OrderDate
from dbo.Products as a
join dbo.[Order Details] as b
on a.ProductID=b.ProductID
join dbo.Orders as c
on b.OrderID=c.OrderID

-- Displays pairs of employees who have the same job title
select a.EmployeeID, a.LastName, a.FirstName, b.EmployeeID, b.LastName, b.FirstName, a.title
from dbo.Employees as a
join dbo.Employees as b
on a.Title=b.Title and a.EmployeeID!=b.EmployeeID

-- Display all the Managers who have more than 2 employees reporting to them
select EmployeeID, LastName, FirstName
from dbo.Employees
group by EmployeeID, LastName, FirstName
having count(ReportsTo)>2

-- Display the customers and suppliers by city. The results should have the following columns
--City 
--Name 
--Contact Name,
--Type (Customer or Supplier)
select a.City as [City], b.CompanyName as Name, a.ContactName as [Contact Name],
	case when b.CompanyName is not null then 'Supplier' else 'Customer' end as [Type]
from Customers as a
full join Suppliers as b
on a.City=b.City
where a.City is not null

-- Have two tables T1 and T2, please write a query to inner join these two tables and write down the result of this query.
--select *
--from f1.t1 as a
--join f2.t2 as b
--on a.id=b.id
--result: F1.T1  F2.T2
--			2      2

-- Based on above two table, Please write a query to left outer join these two tables and write down the result of this query
--from f1.t1 as a
--left join f2.t2 as b
--on a.id=b.id
--result: F1.T1  F2.T2
--			1     null
--			2      2
--			3     null




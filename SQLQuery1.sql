
use AdventureWorks2019
go

-- Q1
select ProductID, Name, Color, ListPrice from Production.Product

-- Q2
select ProductID, Name, Color, ListPrice from Production.Product
where ListPrice=0

-- Q3
select ProductID, Name, Color, ListPrice from Production.Product
where Color is null

-- Q4
select ProductID, Name, Color, ListPrice from Production.Product
where Color is not null

 --	Q5
 select ProductID, Name, Color, ListPrice from Production.Product
 where Color is not null and ListPrice>0

 -- Q6
 select Name+Color from Production.Product
 where Name is not null and Color is not null

 -- Q7
 select 'NAME: '+Name, 'COLOR: '+Color from Production.Product
  where Name is not null and Color is not null

 -- Q8
 select ProductID, Name from Production.Product
 where ProductID between 400 and 500

 --	Q9
  select ProductID, Name, Color from Production.Product
  where Color in ('black','blue')

  -- Q10
  select * from Production.Product
  where Name like 's%'

  -- Q11
  select Name, ListPrice from Production.Product
  order by Name

  -- Q12
  select Name, ListPrice from Production.Product
  where Name like '[a,s]%'
  order by Name

  -- Q13
  select Name, ListPrice from Production.Product
  where Name like 'spo%' and Name not like '___k%'

  -- Q14
  select distinct Color from Production.Product
  where Color is not null
  order by Color desc

  -- Q15
  select distinct ProductSubcategoryID, Color from Production.Product
  where ProductSubcategoryID is not null and Color is not null

  -- Q16
  select ProductSubcategoryID, left([Name],35) AS [Name], Color, ListPrice
  from Production.Product
  where (Color not in ('Red', 'Black') or ListPrice between 1000 and 2000) and ProductSubcategoryID=1
  order by ProductID

  -- Q17 
  select distinct ProductSubcategoryID, Name, Color, ListPrice from Production.Product
  where ProductSubcategoryID in (1,2,12,14) 
		and ListPrice in (539.99, 1364.50, 1431.50, 1700.99)
  order by ProductSubcategoryID desc
  

  

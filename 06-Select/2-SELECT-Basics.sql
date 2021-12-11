USE DemoDb

GO
-- basic select all columns from table

SELECT * FROM dbo.Employees

GO

SELECT  Id ,
        Name ,
        Price  FROM dbo.Products
GO
-- select specific columns from a table

SELECT e.FirstName, e.LastName, e.Title  FROM dbo.Employees AS e
GO


SELECT p.Name, e.FirstName FROM Employees AS e, dbo.Products AS p

-- basic select with a filter

SELECT FirstName, LastName, Title  FROM Employees
	WHERE Title LIKE 'Sales%'
GO

/*-- JOIN Basics --*/
/*-- select using inner join*/
SELECT p.Name, s.* FROM Products AS p   --* & s.* & p.*
	INNER JOIN 
		Sales AS s ON  s.ProductId = p.Id

GO
        
SELECT p.Name,
		 e.LastName,
		 s.SaleDate,
		 s.Quantity
 FROM Products AS p 
	 INNER JOIN  Sales AS s ON s.ProductId = p.Id
	 INNER JOIN  dbo.Employees AS e ON e.Id = s.EmployeeId
GO

SELECT * FROM dbo.Sales
GO

SELECT * FROM Sales AS s 
INNER JOIN  Products AS p ON p.Id = s.ProductId
GO

-- SELECT using left outer join , products with sales
-- use both inner join and left join
-- null values just come with left join :)


SELECT	p.Name,
		COUNT(s.ProductId) AS NumberOfSales,
		SUM(s.Quantity) AS SalesQuantityTotal,
		SUM(p.Price * s.Quantity) AS SalesGrossTotoal
		 FROM dbo.Products AS p 
			INNER JOIN dbo.Sales AS s ON s.ProductId = p.Id
			GROUP BY Name
			
GO

SELECT	p.Name,
		COUNT(s.ProductId) AS NumberOfSales,
		SUM(s.Quantity) AS SalesQuantityTotal,
		SUM(p.Price * s.Quantity) AS SalesGrossTotoal
		 FROM dbo.Products AS p 
			LEFT JOIN dbo.Sales AS s ON s.ProductId = p.Id
			GROUP BY Name
			
GO  
-- >> now correct form comes next :D

SELECT	Name,
		COUNT(s.ProductId) AS NumberOfSales,
		ISNULL(SUM(s.Quantity),0) AS SalesQuantityTotal,
		ISNULL(SUM(p.Price * s.Quantity),0)
		 AS SalesGrossTotoal FROM dbo.Products AS p 
			LEFT JOIN dbo.Sales AS s ON s.ProductId = p.Id
			GROUP BY Name
			
GO


-- select using right outer join, employees with sales
SELECT	FirstName+ ' ' + LastName + '-' + Title AS NameAndTitle,
		COUNT(s.Id) AS NumberOfSales
		FROM Sales AS s
			RIGHT JOIN 
				Employees AS e ON e.Id = s.EmployeeId
				GROUP BY FirstName + ' ' + LastName + '-' + Title
				HAVING COUNT(s.id) > 0
				
GO 

/*-- drived Tables --*/ -- is a quary that use as a table :)
-- simple drived table quary

SELECT FirstName + ' ' + LastName AS EmployeeFullName
	FROM
		(SELECT * FROM Employees WHERE Title LIKE 'Sales%')
			 AS EmployeeDerived
GO

-- derived table quary with joins
SELECT TOP 10	Name, 
				Quantity,
				FirstName + ' ' + LastName AS EmployeeFullName,
				SaleDate
	FROM 
		(SELECT * FROM Sales WHERE Quantity = 10)
		 AS SalesQuantityOf10
		INNER JOIN dbo.Products AS p 
			ON p.Id = SalesQuantityOf10.ProductId
		INNER JOIN dbo.Employees
			ON dbo.Employees.Id = SalesQuantityOf10.EmployeeId
	WHERE p.Id = 5
	ORDER BY SaleDate DESC
GO
SELECT * FROM dbo.Products
--(Question: wehre can where cluse come else in above query?!!)

--Drived Table Quary Aggregate
-- compare queries with agregate with query below!

SELECT	Name,
		NumberOfSales,
		SalesQuantityTotal,
		SalesGrossTotal 
FROM Products AS pout
		LEFT JOIN 
		(SELECT s.ProductId,
				COUNT(*) AS NumberOfSales,
				SUM(Quantity) AS SalesQuantityTotal,
				SUM(Price * Quantity) AS SalesGrossTotal
		FROM Sales AS s 
				JOIN 
			Products AS p ON p.Id = s.ProductId
		GROUP BY  s.ProductId) AS pin ON pin.ProductId = pout.Id
GO
SELECT	Name,
		COUNT(s.ProductId) AS NumberOfSales,
		ISNULL(SUM(s.Quantity),0) AS SalesQuantityTotal,
		ISNULL(SUM(p.Price * s.Quantity),0)
		 AS SalesGrossTotoal FROM dbo.Products AS p 
			LEFT JOIN dbo.Sales AS s ON s.ProductId = p.Id
			GROUP BY Name
			
GO

-- Synonyms

CREATE SYNONYM AWEMployee
	FOR AdventureWorks2012.HumanResources.Employee
	GO

	SELECT * FROM AdventureWorks2012.HumanResources.Employee
	GO

	SELECT * FROM AWEmployee
	GO
    
	DROP SYNONYM AWEmployee

	GO
    /*
    tip:
    AWEmployee can not be Altered! but insert and update and delete works :)
    */
USE DemoDb
GO

-- CASE (equality expresion)
SELECT FirstName, LastName,
		CASE Gender
			WHEN 'F' THEN 'Female'
			WHEN 'M' THEN 'Male'
			ELSE 'Unkknown'
		END AS GenderDescription,
		MaritalStatusDescriptipon = CASE MaritalStatus
				WHEN 's' THEN 'Single'
				WHEN 'm' THEN 'Married'
				ELSE 'Unknown'
		END
		
FROM 
	AdventureWorks2012.HumanResources.Employee AS e
INNER JOIN 
	AdventureWorks2012.Person.Person AS p
	ON p.BusinessEntityID = e.BusinessEntityID

-- tip : explain name aliasing for CASE
GO


-- CASE (searched expresions using range)

SELECT p.Name,
	CASE p.DisContinuedFlag
		WHEN 0 THEN 'store is empty'
		WHEN 1 THEN ' still have it :D'
		ELSE 'N/A?'
	END AS StoreProducts
		
 FROM dbo.Products AS p 
GO

SELECT Id, Name, Price,
		CASE
			WHEN Price < 100 THEN 'Hmmm ... Affordable'
			WHEN Price >= 100 AND price < 1000 THEN 'How much??'
			WHEN Price >= 1000 THEN 'Galactic robbery!'
		END AS CustomerResponse 
FROM dbo.Products
GO

--CASE ( in ORDER BY)
SELECT * FROM
	 Products 
ORDER BY 
	CASE
		DisContinuedFlag WHEN 0 THEN Id END DESC,
	CASE
		DisContinuedFlag WHEN 1 THEN Id END DESC
		 
GO

	-- CASE ( in WHERE)

	SELECT * FROM Products
		 WHERE
			1 = CASE WHEN price < 100  THEN 1 ELSE 0 END

	-- tip: 1 = 1 return the row but 1 = 0 do nothing :)
	GO

--COALESCE (x params, ANSI SQL Standard)
	-- NULL + everything = NULL ! so we use COALESCE
	-- if all answers = null then deafult no name

SELECT	FirstName,
		MiddleName,
		LastName,
		FirstName + ' ' + LastName AS FirstLastName, 
		COALESCE(FirstName + ' ' + MiddleName + ' ' + LastName,
					FirstName + ' ' + LastName, 
						FirstName,
							 LastName, 'No Name') AS FullName 
	FROM dbo.Employees
GO
SELECT * FROM dbo.Employees
GO
SELECT FirstName + MiddleName + LastName AS FullName FROM dbo.Employees

--ISNULL(2 params, T-SQL Specific)
SELECT Id, FirstName,
		ISNULL(MiddleName, 'N/A') AS MiddleName,
		LastName
FROM dbo.Employees
GO

--Ranking (employees by salary)
	--DENSE_RANK is also correct
SELECT
COALESCE(FirstName + ' ' + MiddleName + ' ' + LastName,
					FirstName + ' ' + LastName, 
						FirstName,
							 LastName, 'No Name') AS FullName,
	Title,
	Salary,
	RANK() OVER (ORDER BY Salary DESC) AS SalaryRank,
	ROW_NUMBER() OVER (ORDER BY Salary DESC) AS RowNum
FROM dbo.Employees
GO

--Ranking (top sales by employee , products)
SELECT	s.EmployeeId,
		p.Id,
		SUM(Quantity * Price) AS TotalproductsSales,
		RANK() OVER 
			(PARTITION BY s.EmployeeId ORDER BY SUM(Quantity * Price) DESC)
					AS EmployeeProductSalesRank
FROM Sales AS s
	INNER JOIN Products AS p ON p.Id = s.ProductId
	GROUP BY s.EmployeeId, p.Id
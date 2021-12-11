USE DemoDb

GO

-- subquery in column list
SELECT	Name, 
		(SELECT COUNT(*) FROM dbo.Sales AS s 
		WHERE s.ProductId = p.Id)
		 AS SaleCount
FROM Products AS p

GO

SELECT	Name,
		COUNT(s.ProductId) AS SaleTotal FROM dbo.Products AS p
INNER JOIN sales AS s ON s.ProductId = p.Id
GROUP BY Name
HAVING COUNT(s.ProductId) > 0
GO

--suquery in where clause using IN
SELECT * FROM Sales
	WHERE EmployeeId IN (
						 SELECT Id
						 FROM Employees
						 WHERE Title LIKE 'Sales%'
						  )
GO

-- privious query with join
SELECT * FROM
		Sales AS s
			INNER JOIN 
		Employees AS e 
			ON e.Id = s.EmployeeId
	WHERE Title LIKE 'Sales%'
GO

--EXISTS / NOT EXISTS
USE AdventureWorks2012
GO
-- EXISTS
SELECT	p.FirstName,
		p.LastName,
		e.JobTitle 
	FROM Person.Person AS p
		INNER JOIN 
	HumanResources.Employee AS e 
		ON e.BusinessEntityID = p.BusinessEntityID
WHERE EXISTS (
		SELECT edh.DepartmentID --'SELECT 1' is also correct cuse of returning true/false
			FROM HumanResources.Department AS d
				INNER JOIN
		HumanResources.EmployeeDepartmentHistory AS edh 
			ON edh.DepartmentID = d.DepartmentID
		WHERE e.BusinessEntityID = edh.BusinessEntityID
			AND d.Name LIKE 'Research%'
			 )
GO

-- NOT EXIST
SELECT p.FirstName,
		 p.LastName,
		  e.JobTitle 
	FROM Person.Person AS p
		INNER JOIN 
	HumanResources.Employee AS e 
		ON e.BusinessEntityID = p.BusinessEntityID
WHERE NOT EXISTS (
		SELECT edh.DepartmentId --'SELECT 1' is also correct cuse of returning true/false
		FROM HumanResources.Department AS d
		INNER JOIN HumanResources.EmployeeDepartmentHistory AS edh 
			ON edh.DepartmentID = d.DepartmentID
		WHERE e.BusinessEntityID = edh.BusinessEntityID
			AND d.Name LIKE 'Research%'
			 )
	ORDER BY LastName, FirstName
GO
-- privious query using IN
SELECT p.FirstName, p.LastName, e.JobTitle FROM Person.Person AS p
INNER JOIN HumanResources.Employee AS e ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN HumanResources.EmployeeDepartmentHistory AS edh ON edh.BusinessEntityID = e.BusinessEntityID
WHERE edh.DepartmentID IN
			(
				SELECT DepartmentId
				FROM HumanResources.Department
				WHERE Name LIKE 'Research%'
			)
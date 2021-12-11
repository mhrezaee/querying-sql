-- commmon table expressions
USE DemoDb

GO
-- basic common table expression
WITH SaleByYearCTE (EmployeeId, SaleId, SalesYear)
AS
(
	SELECT EmployeeId, Id, YEAR(SaleDate) AS SalesYear
	FROM Sales
)
SELECT	EmployeeId,
		COUNT(SaleId) AS TotalSales,
		SalesYear 
 FROM SaleByYearCTE
 WHERE SalesYear >= YEAR(DATEADD(yyyy, -5, GETDATE())) -- last 5 years
 GROUP BY SalesYear, EmployeeId
 ORDER BY EmployeeId, SalesYear
 GO

--Multiple CTE's
WITH EmployeeProductSales (EmployeeId, ProductId, TotalSales)
 AS
(
	SELECT e.id, p.Id, SUM(Price * Quantity) AS TotalSales
	FROM dbo.Employees AS e
	INNER JOIN dbo.Sales AS s ON s.EmployeeId = e.Id
	INNER JOIN dbo.Products AS p ON p.Id = s.ProductId
	GROUP BY p.Id, e.Id
),
ProductInfo	(ProductId, ProductName, Price)
 AS 
(
	SELECT Id, Name, Price
	FROM Products
),
EmployeeInfo (EmployeeId, EmployeeName) AS
(
	SELECT Id, COALESCE(FirstName + ' ' + MiddleName + ' ' + LastName,
							FirstName + ' ' + LastName,
								FirstName, LastName) AS EmployeeName
	 FROM Employees
)
SELECT	[pi].ProductName,
		ei.EmployeeName,
		eps.TotalSales
FROM EmployeeProductSales AS eps
INNER JOIN ProductInfo AS [pi]  ON [pi].ProductId = eps.ProductId
INNER JOIN EmployeeInfo AS ei ON ei.EmployeeId = eps.EmployeeId
ORDER BY ProductName, TotalSales DESC, EmployeeName
GO

-- slef referencing recursive query with CTE
	-- ommit this part from exam :)
ALTER TABLE dbo.Employees
	ADD 
		ManagerId	INT
GO
-- omitted from exam
WITH ManagerEmployeesCTE (Name, Title, EmployeeId, EmployeeLevel, Sort)
AS (
	-- Anchor result set 
	SELECT CAST(COALESCE(e.FirstName, ' ' + e.LastName, FirstName) AS NVARCHAR(255)) AS Name,
	e.Title, e.Id, 1 AS EmployeeLevel,
	CAST(COALESCE(e.FirstName, ' ' + e.LastName, FirstName) AS NVARCHAR(255)) AS SortOrder
	FROM dbo.Employees AS e
	WHERE e.ManagerId IS NULL
	UNION ALL
	-- Recusrsive result set
	SELECT 
		CAST(REPLICATE('|  ',	EmployeeLevel) + CAST(COALESCE(e.FirstName, ' ' + e.LastName, FirstName) AS NVARCHAR(255)) AS NVARCHAR(255)) AS Name,
		e.Title,
		e.Id,
		EmployeeLevel + 1 AS EmployeeLevel,
		CAST(RTRIM(Sort) + '|  ' + CAST(COALESCE(e.FirstName, ' ' + e.LastName, FirstName) AS NVARCHAR(255)) AS NVARCHAR(255)) AS SortOrder
	FROM dbo.Employees AS e
	INNER JOIN ManagerEmployeesCTE AS d ON d.EmployeeId = e.ManagerId
)
SELECT EmployeeId, Name, Title, EmployeeLevel
FROM ManagerEmployeesCTE
ORDER BY Sort

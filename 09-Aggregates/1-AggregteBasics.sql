USE DemoDb
GO

/*-- GROUP BY --*/
-- BAsic GROUP BY
SELECT ProductId, Quantity FROM dbo.Sales
ORDER BY ProductId -- first run this query to proof sth :)
GO

-- then run this query and explain the difrences
SELECT ProductId, SUM(Quantity) AS TotalQuantitySold 
FROM dbo.Sales
GROUP BY ProductId
ORDER BY ProductId
GO

-- GROUP BY multiple groups / HAVING
SELECT EmployeeId, ProductId, SUM(Quantity) AS TotalQuantitySold 
FROM dbo.Sales
GROUP BY EmployeeId, ProductId
HAVING SUM(Quantity) > 400 
ORDER BY EmployeeId, ProductId
GO

--GROUP BY Result of functions
SELECT 
	DATEPART(yyyy, SaleDate) AS SaleYear,
	SUM(Quantity) AS TotalQuantitySold
FROM dbo.Sales
GROUP BY DATEPART(yyyy, SaleDate)
ORDER BY SaleYear DESC
GO

/*-- GROUPING SETS --*/
--Basic GROUPING SETS
SELECT EmployeeId, SUM(Quantity) AS QuantitySold 
FROM dbo.Sales
GROUP BY GROUPING SETS ((EmployeeId), ()) -- () yani majmoo ro dar akhar biar !
GO

--Basic GROUPING SETS with multiple groups
SELECT EmployeeId,
		DATEPART(yyyy,SaleDate) AS SaleYear,
		SUM(Quantity) AS QuntitySold
FROM dbo.Sales
GROUP BY GROUPING SETS ((EmployeeId, DATEPART(yyyy,SaleDate)) , ())
GO

--GROUPING SETS with multiple groups , subtotaled by Employees
SELECT
	EmployeeId,
	DATEPART(yyyy,SaleDate) AS SaleYear,
	SUM(Quantity) AS QuntitySold 
FROM dbo.Sales
GROUP BY GROUPING SETS ((EmployeeId, DATEPART(yyyy,SaleDate)) , (EmployeeId))
-- GROUP BY GROUPING SETS ((EmployeeId, DATEPART(yyyy,SaleDate)) , (EmployeeId) , ()) in ham mishe
-- Tip: akhare har employee ye NULL be harahe majmooe forooshesh miare :)
GO

--GROUPING SET with multiple groups and multiple aggregations
SELECT
	EmployeeId,
	DATEPART(MM, SaleDate) AS SaleMonth,
	DATEPART(yyyy,SaleDate) AS SaleYear,
	SUM(Quantity) AS Sales 
FROM dbo.Sales
GROUP BY GROUPING SETS (
							(EmployeeId, DATEPART(MM,SaleDate), DATEPART(yyyy,SaleDate)),
							(EmployeeId, DATEPART(MM,SaleDate)),
							(EmployeeId),
							()
						)
-- tip: akhre har mah , har sal total darim :)
GO

--GROUPING SET with unrelated aggregations
SELECT
	EmployeeId,
	DATEPART(yyyy,SaleDate) AS SaleYear,
	SUM(Quantity) AS Sales 
FROM dbo.Sales
GROUP BY GROUPING SETS ((EmployeeId, DATEPART(yyyy,SaleDate)), ( DATEPART(yyyy,SaleDate)))
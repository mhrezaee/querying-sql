USE DemoDb
GO

--FIRST_VALUE , LAST_VALUE, to return product with thhe lowest price
SELECT Name, Price,
		FIRST_VALUE(Name) OVER (ORDER BY Price) AS Cheapest
FROM dbo.Products
GO

--LAG to compare previous years data with current years data
SELECT 
		ProductId,
		YEAR(SaleDate) AS SaleYear,
		SUM(Quantity) AS CurrentYearQuantity,
		LAG(SUM(Quantity), 1, 0) OVER (ORDER BY YEAR(SaleDate)) AS PreviousYearQuantity
FROM dbo.Sales
WHERE ProductId = 1
GROUP BY ProductId, YEAR(SaleDate)

--LEAD to compare next years data with current years data
SELECT 
		ProductId,
		YEAR(SaleDate) AS SaleYear,
		SUM(Quantity) AS CurrentYearQuantity,
		LEAD(SUM(Quantity), 1, 0) OVER (ORDER BY YEAR(SaleDate)) AS NextYearQuantity
FROM dbo.Sales
WHERE ProductId = 1
GROUP BY ProductId, YEAR(SaleDate)
GO

--CUME_DIST / PERCENT_RANK to show distribution and rank by salary
SELECT
	COALESCE(FirstName + ' ' + LastName, FirstName, LastName) AS FullName,
	Title, Salary,
	CUME_DIST() OVER (ORDER BY Salary) AS CumeDist,
	PERCENT_RANK() OVER (ORDER BY Salary) AS pctRank
FROM dbo.Employees
ORDER BY FullName , Salary DESC
GO

--PEFCENt_CONT / PERCENTILE_DISC to calculate median salary by title
SELECT
	COALESCE(FirstName + ' ' + LastName, FirstName, LastName) AS FullName,
	Title, Salary,
	PERCENTILE_CONT(.5) WITHIN GROUP (ORDER BY Salary) OVER (PARTITION BY Title) AS MedianCont,
	PERCENTILE_DISC(.5) WITHIN GROUP (ORDER BY Salary) OVER (PARTITION BY Title) AS MedianDisc
FROM dbo.Employees
ORDER BY FullName , Salary DESC
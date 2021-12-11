USE DemoDb
GO

-- simple UNION ( combine Duplicates and show one)
SELECT Id, ManagerId, FirstName, LastName FROM dbo.Employees
UNION
SELECT Id, ManagerId, FirstName, LastName FROM dbo.SalesEmployees

GO

-- written as FULL OUTER JOIN
SELECT e.Id, e.ManagerId, e.FirstName, e.LastName FROM dbo.Employees AS e
	FULL OUTER JOIN 
	dbo.SalesEmployees AS se ON se.Id = e.Id
GO

-- UNION All (show duplicates)
SELECT Id, ManagerId, FirstName, LastName FROM dbo.Employees
UNION ALL
SELECT Id, ManagerId, FirstName, LastName FROM dbo.SalesEmployees
GO

-- UNION with many SELECts
SELECT Id, ManagerId, FirstName, LastName FROM dbo.Employees WHERE ManagerId = 6
UNION
SELECT Id, ManagerId, FirstName, LastName FROM dbo.Employees WHERE Salary > 0
UNION
SELECT Id, ManagerId, FirstName, LastName FROM dbo.Employees WHERE ManagerId = 6
GO

-- UNION example to get price history
SELECT ProductId, PreviousPrice AS price, PriceChangeDate FROM ProductPriceHistory
UNION
SELECT ProductId, NewPrice AS Price, PriceChangeDate FROM ProductPriceHistory
ORDER BY PriceChangeDate

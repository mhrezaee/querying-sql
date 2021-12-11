USE DemoDb
GO

-- UDF results in row-based Logic
SELECT
	Id,
	FirstName,
	LastName,
	dbo.GetManagerName AS manager
FROM 
	dbo.Employees
GO

--ReWritten using Set-Based (corelated subquery)
SELECT 
	Id,
	FirstName,
	LastName,
	(SELECT COALESCE(FirstName+' '+ LastName, LastName, FirstName) FROM dbo.Employees WHERE Id = e.ManagerId ) AS Manager,
	e.Title
FROM 
	dbo.Employees AS e
GO

--Cursor using Row-based Logic
DECLARE @ProductId INT

DECLARE dataCursor CURSOR FOR 
	SELECT
		Id
	FROM 
		Products
	WHERE 
		DisContinuedFlag = 0

OPEN dataCursor FETCH NEXT FROM dataCursor INTO @ProductId
	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			SELECT
				@ProductId,
				SUM(Quantity) AS TotalQuantity,
				COUNT(*) AS TotalSales
			FROM 
				Sales
			WHERE 
				ProductId = @ProductId

			FETCH NEXT FROM dataCursor INTO @ProductId
		END
CLOSE dataCursor
DEALLOCATE dataCursor

GO

--ReWritten using set-based logic
SELECT
	s.ProductId,
	SUM(Quantity) AS TotalQuantity,
	COUNT(*) AS TotalSales
FROM 
	Sales AS s
		JOIN
	dbo.Products AS p ON p.Id = s.ProductId
WHERE 
	DisContinuedFlag = 0
GROUP BY 
	s.ProductId
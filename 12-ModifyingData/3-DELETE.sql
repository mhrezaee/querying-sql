USE DemoDb
GO

--simple DELETE statement
DELETE FROM 
	Products
WHERE 
	Id = 5
GO

--DELETE multiple rows
DELETE FROM Sales
	WHERE 
		DATEPART(yyyy,SaleDate) <= 2005
GO

TRUNCATE TABLE Employees

-- delete based on join

DELETE s FROM Sales AS s
INNER JOIN Employees AS e ON e.Id = s.EmployeeId
WHERE e.Title = 'Sales Manager'
GO

SELECT * FROM Sales


-- DELETE to remove duplicates
SELECT 
		ProductId, EmployeeId, Quantity, SaleDate , COUNT(*)
FROM
		Sales
GROUP BY
		ProductId, EmployeeId, Quantity, SaleDate
HAVING
		COUNT(*) > 0
GO
-- another way
DELETE dbo.Sales
WHERE Id IN
		(
			SELECT
				MAX(Id) AS SaleIdToDelete
			FROM 
				dbo.Sales
			GROUP BY
				ProductId,EmployeeId, Quantity, SaleDate
			HAVING
				COUNT(*) > 1
		)

SELECT * FROM dbo.Sales
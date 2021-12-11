USE DemoDb
GO

--EXCEPT to compare results and return products without sales
SELECT Id FROM products
EXCEPT
SELECT productId FROM dbo.Sales
GO
-- tip: cause of EXCEPT we can not use Name column so we can use it in a subquery like below :)

SELECT * FROM dbo.Products
	WHERE Id IN (
					SELECT Id FROM products
					EXCEPT
					SELECT productId FROM dbo.Sales
				)
GO


--LEFT JOIN to return products without sales
SELECT p.id, p.Name FROM Products AS p
LEFT JOIN Sales AS s ON s.ProductId = p.Id
WHERE s.ProductId IS NULL
GO

-- INTERSECT to compare results and return products with sales
SELECT Id FROM dbo.Products
INTERSECT
SELECT ProductId FROM dbo.Sales
GO

--INNER JOIN to return products with sales
SELECT DISTINCT p.Id, p.Name
FROM dbo.Products AS p
	INNER JOIN  dbo.Sales AS s ON s.ProductId = p.Id
GO

--INTERSECT in subquery
SELECT Name FROM dbo.Products
 WHERE Id IN	(
				SELECT Id FROM dbo.Products
				INTERSECT
                SELECT ProductId FROM dbo.Sales
				)
USE DemoDb
GO

--Inline Table-Value function to return table data type with employees

CREATE FUNCTION EmployeesByTitle
(
	@Title NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN
	
	SELECT * FROM Employees
	WHERE Title LIKE '%' + @Title + '%'
GO

SELECT * FROM EmployeesByTitle('Sales')
SELECT * FROM EmployeesByTitle('Manager')
GO

--Multi-Statement table-value function to return table with products sales

CREATE FUNCTION ProductSales
(
	@ProductId INT
)
RETURNS @ProductSalesDate TABLE (
								 ProductId		INT			NOT NULL,
								 EmployeeId		INT			NOT NULL,
								 Quantity		SMALLINT	NOT NULL,
								 SaleDate		DATETIME	NOT NULL
								)
AS
BEGIN
	
	INSERT INTO @ProductSalesDate
		SELECT productId, EmployeeId, Quantity, SaleDate
		FROM dbo.Sales
		WHERE ProductId = @ProductId

	RETURN
END
GO

-- select from table-value function
SELECT * FROM ProductSales(1)

--join using standard join syntax (must hard code params)
SELECT * FROM dbo.Products AS p
	JOIN
		ProductSales(1) AS ps ON p.Id = ps.ProductId
GO

-- CROSS APPLY for INNER JOIN to table-value function
-- tip: its not hard code and use all products Id

SELECT * FROM Products AS p
	CROSS APPLY ProductSales(p.Id)

-- OUTER APPLY For OUTER Joining to table-value Function

SELECT * FROM dbo.Products AS p
	OUTER APPLY ProductSales(p.Id)
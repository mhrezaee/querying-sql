USE DemoDb
GO


--Basic Scalar function to return a products sale total
CREATE FUNCTION GetProductSalesTotal
(
	@ProductId INT
)
RETURNS DECIMAL(19,4)

AS
	BEGIN
		DECLARE @SalesTotal DECIMAL(19,4)

		SELECT @SalesTotal = SUM(Quantity*Price)
		FROM Sales AS s
			JOIN dbo.Products AS p
				ON p.Id = s.ProductId
		WHERE s.ProductId = @ProductId
		GROUP BY s.ProductId
		RETURN @SalesTotal
	END
GO

SELECT Name, dbo.GetProductSalesTotal(Id) AS TotalSale 
	FROM dbo.Products
-- Tip : dbo at the begining is nessacery

GO

-- scalar function to validate email address
CREATE FUNCTION ValidateEmailAddress
(
	@Email VARCHAR(255)
)
RETURNS BIT
AS
BEGIN
	
	DECLARE @valid BIT = 0

	IF @Email IS NOT NULL AND @Email LIKE '%_@_%_.__%'
		SET @valid = 1

  RETURN @valid
END

GO
SELECT dbo.ValidateEmailAddress('email@site.com')
GO


ALTER TABLE dbo.Employees ADD EmailAddress NVARCHAR(255) NULL
GO

UPDATE dbo.Employees SET EmailAddress = 'user1@site.com' WHERE Id = 1
UPDATE dbo.Employees SET EmailAddress = 'site.com' WHERE Id = 2
UPDATE dbo.Employees SET EmailAddress = 'user2@site.com' WHERE Id = 3
UPDATE dbo.Employees SET EmailAddress = 'user1@site.com' WHERE Id = 4
UPDATE dbo.Employees SET EmailAddress = 'user3.site@com' WHERE Id = 5
UPDATE dbo.Employees SET EmailAddress = 'site.com' WHERE Id = 6
GO

-- use in SELECT list to view every row
SELECT 
	Id, FirstName, LastName, EmailAddress, dbo.ValidateEmailAddress(EmailAddress) AS [valid?]
FROM 
	dbo.Employees
GO

-- use in WHERE cluse to return list of invalid email addresses
SELECT * FROM dbo.Employees
WHERE 
	dbo.ValidateEmailAddress(EmailAddress) = 0
		AND
    EmailAddress IS NOT NULL
GO

CREATE FUNCTION CustomDateFormat
(
	@Date DATETIME
)
RETURNS CHAR(10)
AS
BEGIN
	
	RETURN	CAST(DATEPART(Day, @Date) AS VARCHAR)
			 + '/' + CAST(DATEPART(MONTH,@Date) AS VARCHAR)
			 + '/' + CAST(DATEPART(YEAR, @Date) AS VARCHAR)
END
GO

SELECT Name, Quantity, SaleDate, dbo.CustomDateFormat(SaleDate) AS FormattedDate
FROM sales AS s
		JOIN dbo.Products AS p
			ON p.Id = s.ProductId
GO

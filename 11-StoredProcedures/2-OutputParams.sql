USE DemoDb
GO

-- insert new sale, returning SaleId as output parameter

IF OBJECT_ID('sp_AddSale', 'P') IS NOT NULL
	DROP PROCEDURE dbo.sp_AddSale
GO
 
CREATE PROCEDURE sp_AddSale
	@employeeId INT,
	@productId INT,
	@quantity SMALLINT,
	@saleId UNIQUEIDENTIFIER OUTPUT
AS

	SET @saleId = NEWID()

	INSERT INTO Sales
		SELECT @saleId, @productId, @employeeId, @quantity, GETDATE() 
GO

--executing sp and displaying the output

DECLARE @saleId UNIQUEIDENTIFIER
EXECUTE sp_AddSale 1,2,12, @saleId OUTPUT
PRINT 'saleId: ' + CAST(@saleId AS NVARCHAR(50))
GO

--sp returning scalar result as output parameter
IF OBJECT_ID('sp_GetProductSalesAmountByYear', 'P') IS NOT NULL
	DROP PROCEDURE dbo.sp_GetProductSalesAmountByYear
GO

CREATE PROCEDURE sp_GetProductSalesAmountByYear
	@prodcutId INT,
	@year SMALLINT,
	@salesTotal DECIMAL(19,4) OUTPUT
AS
	
	SELECT @salesTotal = SUM(s.Quantity * p.Price)
	FROM Sales AS s
	JOIN products AS p ON p.Id = s.ProductId
	WHERE s.ProductId = @prodcutId
	AND YEAR(s.SaleDate) = @year
	GROUP BY s.ProductId, YEAR(s.SaleDate)
GO

-- execeuting sp storing and displaying output parameter
DECLARE @saleTotal DECIMAL(19,4)
EXECUTE sp_GetproductSalesAmountByYear 2,2008, @saleTotal OUTPUT
PRINT 'Total: ' + CAST(@saleTotal AS NVARCHAR(50))

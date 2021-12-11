USE DemoDb
GO

--search engine on top of sales table
ALTER PROCEDURE sp_GetSales
	@EmployeeId INT = NULL,
	@ProductId INT = NULL,
	@Quantity SMALLINT = NULL,
	@BeginSaleDate DATETIME = '1/1/1800',
	@EndSaleDate DATETIME =  '12/31/9999'

AS
	SELECT Id, EmployeeId, ProductId , Quantity, SaleDate
	FROM dbo.Sales
WHERE 
	(@EmployeeId IS NULL OR EmployeeId = @EmployeeId) --EmployeeId = COALESCE(@EmployeeId, EmployeeId)
		AND
	(@ProductId IS NULL OR ProductId = @ProductId) --ProductId = COALESCE(@ProductId, ProductId)
		AND
	(@Quantity IS NULL OR Quantity = @Quantity)
		AND
	(
		DATEDIFF(d,SaleDate, @BeginSaleDate) >= 0
			AND
		DATEDIFF(d,SaleDate, @EndSaleDate) <= 0
	)
GO
EXEC sp_GetSales 1,3,NULL , '1/1/2000', '1/1/2014' 
GO

-- insert new sale, returning saleId, as output parameter
CREATE PROCEDURE sp_AddSale
	@EmployeeId INT,
	@ProductId INT,
	@Quantity SMALLINT,
	@SaleId UNIQUEIDENTIFIER OUTPUT
AS
	
	SET @SaleId = NEWID()

	INSERT INTO Sales 
		SELECT @SaleId, @ProductId, @EmployeeId, @Quantity, GETDATE()
GO

--update existing sale
CREATE PROCEDURE sp_UpdateSale
	@SaleId UNIQUEIDENTIFIER,
	@EmployeeId INT,
	@ProductId INT,
	@Quantity SMALLINT

AS
	UPDATE
		dbo.Sales
	SET
		EmployeeId = @EmployeeId,
		ProductId = @ProductId,
		Quantity = @Quantity,
		SaleDate = GETDATE()
	WHERE Id = @SaleId
GO

-- add or update (merging add and update), use branching logic to determine if its an insert or update
CREATE PROCEDURE sp_AddUpdateSale
	@SaleId UNIQUEIDENTIFIER = NULL,
	@EmployeeId INT,
	@ProductId INT,
	@Quantity SMALLINT
AS
	IF @SaleId IS NULL
		INSERT INTO Sales
			SELECT NEWID(), @ProductId, @EmployeeId, @Quantity, GETDATE()
	ELSE
		UPDATE
			dbo.Sales
		SET
			EmployeeId = @EmployeeId,
		ProductId = @ProductId,
		Quantity = @Quantity,
		SaleDate = GETDATE()
	WHERE Id = @SaleId
GO

-- delete sale
CREATE PROCEDURE sp_DeleteSale
	@SaleId UNIQUEIDENTIFIER
AS
	DELETE FROM dbo.Sales
	WHERE Id = @SaleId
GO
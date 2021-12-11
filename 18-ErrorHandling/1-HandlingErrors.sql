USE DemoDb
GO

-- Basic Example of try...Catch

BEGIN TRY

SELECT 1/0 AS Error

END TRY

BEGIN CATCH

SELECT 
	ERROR_NUMBER() AS ErroNumber,
	ERROR_STATE() AS ErrorState,
	ERROR_SEVERITY() AS ErrorSeverity,
	ERROR_LINE() AS ErrorLine,
	ERROR_PROCEDURE() AS ErrorProcedure,
	ERROR_MESSAGE() AS ErrorMessge
END CATCH

GO

-- Table To store Errors

CREATE TABLE DbErrors
(
	Id				INT				IDENTITY,
	UserName		VARCHAR(100),
	ErrorNumber		INT,
	ErrorState		INT,
	ErrorSeverity	INT,
	ErrorLine		INT,
	ErrorProcedure	VARCHAR(MAX),
	ErrorMessage	VARCHAR(MAX),
	ErrorDateTime	DATETIME
)
GO

-- Modify AddSale Stored Procedure  to add Error Handling
ALTER PROCEDURE sp_AddSale
	@employeeId INT,
	@productId INT,
	@quantity SMALLINT,
	@saleId UNIQUEIDENTIFIER OUTPUT
AS

	SET @saleId = NEWID()
	-- Add try Catch Around insert Statement
	BEGIN TRY
		INSERT INTO Sales (Id,ProductId, EmployeeId, Quantity, SaleDate)
			SELECT @saleId, @productId, @employeeId, @quantity, GETDATE() 
	END TRY

	-- Store Errors in Error Table
	BEGIN CATCH
		INSERT DbErrors
			VALUES (SUSER_SNAME(),ERROR_NUMBER(),ERROR_STATE(),ERROR_SEVERITY(),ERROR_LINE(),ERROR_PROCEDURE(),ERROR_MESSAGE(),GETDATE())
	END CATCH
GO

--Execute Storedprocedure providing invalid EmployeeId
DECLARE @SaleId UNIQUEIDENTIFIER
EXECUTE sp_AddSale 20,1,12, @SaleId OUTPUT
GO

SELECT * FROM DbErrors
GO

--Modify addSale stored Procedure to add Error handling with Transaction 

ALTER PROCEDURE sp_AddSale
	@employeeId INT,
	@productId INT,
	@quantity SMALLINT,
	@saleId UNIQUEIDENTIFIER OUTPUT
AS

	SET @saleId = NEWID()
	-- Add try Catch Around insert Statement
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO Sales
				SELECT @saleId, @productId, @employeeId, @quantity, GETDATE() 
		COMMIT TRANSACTION
	END TRY

	-- Store Errors in Error Table
	BEGIN CATCH
		INSERT DbErrors
			VALUES (SUSER_SNAME(),ERROR_NUMBER(),ERROR_STATE(),ERROR_SEVERITY(),ERROR_LINE(),ERROR_PROCEDURE(),ERROR_MESSAGE(),GETDATE())
		--transaction uncommitable
		IF (XACT_STATE()) = -1
			ROLLBACK TRANSACTION

		--transaction commitable
		IF (XACT_STATE()) = 1
			COMMIT TRANSACTION
	END CATCH
GO

--Execute Storedprocedure providing invalid EmployeeId
DECLARE @SaleId UNIQUEIDENTIFIER
EXECUTE sp_AddSale 20,1,12, @SaleId OUTPUT
GO

SELECT * FROM DbErrors
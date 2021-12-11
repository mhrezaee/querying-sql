USE DemoDb
GO

--Modify AddSale SP to add Error Handling with custom error

ALTER PROCEDURE sp_AddSale
	@employeeId INT,
	@productId INT,
	@quantity SMALLINT,
	@saleId UNIQUEIDENTIFIER OUTPUT
AS

	SET @saleId = NEWID()
	-- Add try Catch Around insert Statement
	BEGIN TRY
		IF (SELECT COUNT(*) FROM dbo.Employees WHERE Id = @employeeId) = 0
			RAISERROR ('EmployeeId Does not Exist.',11,1)
			INSERT INTO Sales
				SELECT @saleId, @productId, @employeeId, @quantity, GETDATE() 
	END TRY

	-- Store Errors in Error Table
	BEGIN CATCH
		INSERT DbErrors
			VALUES (SUSER_SNAME(),ERROR_NUMBER(),ERROR_STATE(),ERROR_SEVERITY(),ERROR_LINE(),ERROR_PROCEDURE(),ERROR_MESSAGE(),GETDATE())

		DECLARE @Message VARCHAR(MAX) = ERROR_MESSAGE(),
				@Severity INT = ERROR_SEVERITY(),
				@State INT = ERROR_STATE()

		RAISERROR (@Message, @Severity , @State)
	END CATCH
GO

-- execute SP providing invalid EmployeeId
DECLARE @SaleId UNIQUEIDENTIFIER
EXECUTE sp_AddSale 20,1,12, @SaleId OUTPUT
GO

SELECT * FROM DbErrors
GO

-- Add custom Error to Sql server

sp_AddMessage @msgnum = 50001,
			  @severity = 11,
			  @msgtext = 'EmployeeId does not exist !'
GO

RAISERROR (50001, 11, 1)

GO

sp_dropmessage @msgnum = 50001
GO

-- view all sql server error messages
SELECT * FROM master.dbo.sysmessages
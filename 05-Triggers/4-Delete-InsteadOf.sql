USE AdventureWorks2012

GO
IF OBJECT_ID('[HumanResources].[dEmployee]','TR') IS NOT NULL
	DROP TRIGGER [HumanResources].[dEmployee]
GO


CREATE TRIGGER [HumanResources].[dEmployee] ON [HumanResources].[Employee] 
	INSTEAD OF DELETE 
		AS 
		BEGIN
			DECLARE @Count int;

			SET @Count = @@ROWCOUNT;
			IF @Count = 0 
				RETURN;

			SET NOCOUNT ON;

			BEGIN
				RAISERROR
					(N'Employees cannot be deleted. They can only be marked as not current.', -- Message
					10, -- Severity.
					1); -- State.

				-- Rollback any active or uncommittable transactions
				IF @@TRANCOUNT > 0
				BEGIN
					ROLLBACK TRANSACTION;
				END
			END;
		END;
-- yek employee az humanresources.employee delete kon ta peygham ro neshoon bede
-- bad begoo role back mikone
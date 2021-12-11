USE DemoDb
GO

-- Read uncommitted: Dirty Reads Possible (Dirty data = uncommitted Data)
-- we set READ UNCOMMITTED to show dirty dat (run whole these 3 selects together with read uncommitted too proof)

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO

SELECT * FROM dbo.Employees

BEGIN TRANSACTION 
	
	UPDATE 
		dbo.Employees
	SET
		Title = 'All Titles Changed!'

	SELECT * FROM dbo.Employees

	IF @@ROWCOUNT > 0
		ROLLBACK
	ELSE
		COMMIT

SELECT * FROM dbo.Employees
GO

-- READ COMMITTED: Prevents Dirty Reads (Default)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO

BEGIN TRAN
	
	SELECT * FROM Employees

	WAITFOR DELAY '00:00:30'

	SELECT * FROM Employees

COMMIT TRAN

GO
-- tip go too next query and run first update

--REPEATABLE READ: prevent dirty reads, concurrent operations cannot modify or delete data
-- (this locks the data and do not let it change while tran hasnt committed)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
GO

BEGIN TRAN
	
	SELECT * FROM Employees

	WAITFOR DELAY '00:00:30'

	SELECT * FROM Employees

COMMIT TRAN
GO

-- SERIALIZABLE: Prevent Dirty Reads, concurrents operations cannot modify or delete or insert data 
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO

BEGIN TRAN
	
	SELECT * FROM Employees

	WAITFOR DELAY '00:00:30'

	SELECT * FROM Employees

COMMIT TRAN
GO

DBCC USEROPTIONS
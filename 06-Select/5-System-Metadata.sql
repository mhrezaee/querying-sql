USE DemoDb
GO
-- metadatas are for informing us about sql objects

-- using OBJECT_ID metadata function
IF OBJECT_ID('iProductNotification', 'TR') IS NOT NULL
		DROP TRIGGER dbo.iProductNotification
GO
IF OBJECT_ID('Employees' , 'U') IS NOT NULL
		PRINT 'yes there is a table named Employees'
		ELSE PRINT 'no srry'
--Using OBJECTPROPERTY with OBJECT_ID metadata function
IF OBJECTPROPERTY(OBJECT_ID('Employees'), 'IsTable') = 1
	PRINT 'yes it is a table'
ELSE
	PRINT 'No it is not a table'
GO -- shift + f1 to proof ObjectProperty

--querying sys.objects system View
SELECT * FROM sys.objects	--exec this line once to show all schemas made yet
WHERE OBJECTPROPERTY(OBJECT_ID, 'SchemaID') = SCHEMA_ID('dbo')
-- returns all schemas :)
GO

-- more system metadata views
SELECT * FROM INFORMATION_SCHEMA.TABLES
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
GO

-- system stored procedures
EXEC sp_help 'Employees'
GO

-- undocumneted stored procedures
EXEC sp_MSForEachTable 'DBCC CHECKTABLE ([?])'
EXEC sp_MSForEachTable 'EXECUTE sp_spaceused [?]'
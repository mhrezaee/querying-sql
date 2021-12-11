USE DemoDb

GO

-- using EXEC
DECLARE @sql NVARCHAR(MAX),
		@topCount INT

SET @topCount = 10
SET @sql = 'SELECT TOP ' + CAST(@topCount AS NVARCHAR(8))
						 + ' * FROM Sales ORDER BY SaleDate DESC'

EXEC (@sql)
GO

--Using sp_ExecuteSQL
use master
GO
DECLARE UserDatabases CURSOR FOR
	SELECT Name FROM sys.databases WHERE database_id > 4
OPEN UserDatabases

DECLARE @dbName NVARCHAR(128)
DECLARE @sql NVARCHAR(MAX)

FETCH NEXT FROM UserDatabases INTO @dbName
	WHILE (@@FETCH_STATUS = 0)
		BEGIN
			SET @sql = 'USE ' + @dbName + ' ; ' + CHAR(13) + 'DBCC SHRINKDATABASE ( '+ @dbName + ' )'
			-- DBCC SHRINKDATABASE = short info about Db
			EXEC sp_ExecuteSQL @sql
			
			FETCH NEXT FROM  UserDatabases INTO @dbName
		END
CLOSE UserDatabases
DEALLOCATE UserDatabases
GO

-- a word about synonyms
/*-- Synonyms --*/
CREATE SYNONYM AWEmployees
	FOR AdventureWorks2012.HumanResources.Employee
GO

SELECT * FROM AWEmployees
GO

DROP SYNONYM AWEmployees
USE DemoDb
GO

-- allow advanced options to be changed
EXEC sp_configure 'show advanced options' , 1
GO
RECONFIGURE
GO

EXEC sp_configure 'xp_cmdshell', 1
GO
RECONFIGURE
GO

--BCP export xml
DECLARE @sql VARCHAR(8000)
SET @sql='bcp "SELECT * FROM DemoDb.dbo.Employees FOR XML RAW(''Employees''), ROOT(''Employees''),ELEMENTS" queryout "D:\Employees.xml" -c -T -S .'
EXEC xp_cmdshell @sql
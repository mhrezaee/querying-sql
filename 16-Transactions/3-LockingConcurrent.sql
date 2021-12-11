USE DemoDb
GO

UPDATE dbo.Employees SET Title = 'READ COMMITED' WHERE Id = 4

--invalid
UPDATE dbo.Employees SET Title = 'REPEATABLE READ' WHERE Id = 1

-- valid
INSERT Employees (FirstName, LastName, Salary) VALUES ('New', 'Employee', 0.00)


--Invalid 
UPDATE dbo.Employees SET Title = 'SERILIZABLE' WHERE Id = 1

--Invalid
INSERT Employees (FirstName, LastName, Salary) VALUES ('Newest', 'Employee', 0.00)


-- DMV to view Locks
SELECT * FROM sys.dm_tran_locks
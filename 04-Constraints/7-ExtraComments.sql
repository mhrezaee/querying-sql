
-- do not execute it
-- just for explanation
USE DemoDb

GO
-- add constraint
-- we use nocheck to not make problem for data already inside the table.

ALTER TABLE dbo.Sales WITH NOCHECK
	ADD CONSTRAINT FK_EmployeesSales FOREIGN KEY (EmployeeId)
	 REFERENCES dbo.Employees(Id)



-- drop constraint

ALTER TABLE dbo.Sales
	DROP CONSTRAINT FK_EmployeesSales

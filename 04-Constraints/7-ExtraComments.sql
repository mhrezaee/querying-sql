
-- in ghesmat dar execute sherkat nakonad
-- faghat braye tozihate ast
USE DemoDb

GO
-- add constraint
-- no check baraye inke dade haye ghabli ke dar jadavel vojood dasht moshkeli pish nayad estefade mishe

ALTER TABLE dbo.Sales WITH NOCHECK
	ADD CONSTRAINT FK_EmployeesSales FOREIGN KEY (EmployeeId)
	 REFERENCES dbo.Employees(Id)



-- drop constraint

ALTER TABLE dbo.Sales
	DROP CONSTRAINT FK_EmployeesSales

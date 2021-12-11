use DemoDb

GO

-- drop foregin key Constraints
ALTER TABLE dbo.Sales
	DROP CONSTRAINT FK_EmployeesSales, FK_ProductsSales
GO

-- disable triggers
EXEC sp_MSForEachTable 'ALTER TABLE ? DISABLE TRIGGER ALL'
GO

-- empty Tables
TRUNCATE TABLE dbo.Employees
TRUNCATE TABLE dbo.Products
TRUNCATE TABLE dbo.Sales
GO

-- Add Foregin Key Constraints
ALTER TABLE dbo.Sales
	ADD CONSTRAINT FK_ProductsSales FOREIGN KEY (ProductId) REFERENCES dbo.Products(Id),
		CONSTRAINT FK_EmployeesSales FOREIGN KEY (EmployeeId) REFERENCES dbo.Employees(Id)
GO

-- re enable triggers
EXEC sp_MSForEachTable 'ALTER TABLE ? ENABLE TRIGGER ALL'
GO

ALTER TABLE dbo.Employees
		ALTER COLUMN LastName NVARCHAR(50) NULL
-- if has eror script drop and create U_Employee
GO

-- create sample employees records
INSERT dbo.Employees SELECT 'Luke',NULL,'Skywalker', 'Sales Person', '10/1/2005','15', 50000
INSERT dbo.Employees SELECT 'Darth',NULL,'Maul', 'Sales Person', '4/27/2005','20', 90000
INSERT dbo.Employees SELECT 'Han',NULL,'Solo', 'Human Resources', '6/19/2005','30', 70000
INSERT dbo.Employees SELECT 'Empror',NULL,'Palpatine', 'Human Resources', '11/5/2005','25', 100000
INSERT dbo.Employees SELECT 'Count',NULL,'Dooku', 'CFO', '3/22/2005','22', 65000
INSERT dbo.Employees SELECT 'Obi-Wan',NULL,'Kenobi', 'CEO', '2/14/2005','15', 80000
INSERT dbo.Employees SELECT 'Yoda',NULL,NULL, 'Sales Person', '1/14/1990','32', 30000
GO

-- create sample products records
INSERT dbo.Products SELECT 'Lightsaber', 49.99, 0
INSERT dbo.Products SELECT 'Blaster', 79.99, 0
INSERT dbo.Products SELECT 'Droid', 99.99, 0
INSERT dbo.Products SELECT 'Speeder', 250.00, 0
INSERT dbo.Products SELECT 'Spaceship', 300.00, 0
GO

-- Create 1,000 random sale records
DECLARE @counter INT
SET @counter = 1

WHILE @counter <= 1000
	BEGIN
		INSERT dbo.Sales
		        SELECT
					NEWID(),
					(ABS(CHECKSUM(NEWID())) % 5) + 1,
					(ABS(CHECKSUM(NEWID())) % 3) + 1,
					(ABS(CHECKSUM(NEWID())) % 10) + 1,
					DATEADD(DAY,ABS(CHECKSUM(NEWID()) % 3650),'2002-4-1')
		SET @counter += 1
		END

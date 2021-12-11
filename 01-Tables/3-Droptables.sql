use DemoDb

GO

ALTER TABLE Products
	DROP COLUMN Price

GO

DROP TABLE Employees
DROP TABLE Products
DROP TABLE SaleOrder

GO

TRUNCATE TABLE Products
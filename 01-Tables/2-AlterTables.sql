USE DemoDb

GO

ALTER TABLE	Employees
	ADD
		ActiveFlag BIT	NOT NULL,
		ModifiedDate	DATETIME NOT NULL


ALTER TABLE Products
	ALTER COLUMN price MONEY


EXEC sp_rename 'Sales', 'SaleOrder'

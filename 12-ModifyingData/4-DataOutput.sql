USE DemoDb
GO

--OUTPUT statement to view affected rows(INSERTED)
DECLARE @InsertedProducts TABLE (Id INT , Name NVARCHAR(200), price DECIMAL(19,4))

INSERT INTO
	 Products (Name, Price)
OUTPUT
	INSERTED.Id,
	INSERTED.Name,
	INSERTED.Price
INTO
	@InsertedProducts
VALUES ('Power Belt', '59.99')

SELECT * FROM @InsertedProducts
SELECT * FROM dbo.Products
GO

--OUTPUT statement to view affected rows(DELETED)
DECLARE @DeletedEmployees TABLE(Id INT, FirstName NVARCHAR(50), LastName NVARCHAR(50))

DELETE FROM 
	SalesEmployees
OUTPUT
	DELETED.Id,
	DELETED.FirstName,
	DELETED.LastName
INTO
	@DeletedEmployees
WHERE 
	Title = 'Sales Person'

SELECT * FROM @DeletedEmployees
SELECT * FROM SalesEmployees
GO

--OUTPUT statement to view affected rows(INSERTED/DELETED)
DECLARE @DiscountProducts TABLE (Id INT, OldPrice DECIMAL(19,4), NewPrice DECIMAL(19,4))

UPDATE
	dbo.Products
SET
	Price *= 0.5,
	Name += '*'
OUTPUT 
	INSERTED.Id,
	DELETED.Price,
	INSERTED.Price
INTO
	@DiscountProducts
WHERE 
	DisContinuedFlag = 1
SELECT * FROM @DiscountProducts
SELECT * FROM dbo.Products
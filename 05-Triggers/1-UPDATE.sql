USE DemoDb

GO


IF OBJECT_ID('ProductPriceHistory','U') IS NOT NULL
	DROP TABLE ProductPriceHistory
GO

CREATE TABLE ProductPriceHistory
(
	Id					UNIQUEIDENTIFIER	NOT NULL		PRIMARY KEY,
	ProductId			INT					NOT NULL,
	PreviousPrice		DECIMAL(19,4)		NULL,
	NewPrice			DECIMAL(19,4)		NOT NULL,
	PriceChangeDate		DATETIME			NOT NULL,
)

GO

IF OBJECT_ID('uProductPriceChange','TR') IS NOT NULL
	DROP TRIGGER uProductPriceChange
GO

CREATE TRIGGER uProductPriceChange ON Products
	FOR UPDATE
AS
	INSERT ProductPriceHistory(Id,ProductId,PreviousPrice,NewPrice,PriceChangeDate)
		SELECT
			NEWID(), p.Id, d.Price, i.price, GETDATE()
		FROM Products AS p
		JOIN 
		INSERTED AS  i ON p.Id = i.Id
		JOIN
		DELETED	 AS  d  ON p.Id = d.Id
GO

-- after execute go to the Product Table press edit top 200 and change a price :)

SELECT * FROM dbo.ProductPriceHistory

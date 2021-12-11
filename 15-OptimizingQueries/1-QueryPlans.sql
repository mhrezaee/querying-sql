USE DemoDb
GO

--Full table scan
SELECT * INTO Sales2 FROM dbo.Sales
SELECT * FROM Sales2

GO

-- clustered Index scan
SELECT * FROM dbo.Sales

-- clustered Index Seek
SELECT * FROM dbo.Sales WHERE Id = '430701F8-569C-41CD-B89D-003ADCC35E13'

GO

-- Index Seek
CREATE NONCLUSTERED INDEX IX_productSearch ON dbo.Sales
(
	ProductId ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF)


GO

SELECT Id, productId FROM dbo.Sales WHERE ProductId = 1

GO

SELECT p.* FROM dbo.Products AS p
INNER JOIN  dbo.Sales AS s ON s.ProductId = p.Id



-- JOIN (LOOP)
SELECT s.Id, Name, Price, Quantity
FROM dbo.Products AS p
	JOIN
dbo.Sales AS s ON s.ProductId = p.Id
OPTION(LOOP JOIN)


-- JOIN (Merge)
SELECT s.Id, Name, Price, Quantity
FROM dbo.Products AS p
	JOIN
dbo.Sales AS s ON s.ProductId = p.Id
OPTION(MERGE JOIN)


-- JOIN (HASH)
SELECT s.Id, Name, Price, Quantity
FROM dbo.Products AS p
	JOIN
dbo.Sales AS s ON s.ProductId = p.Id
OPTION(HASH JOIN)
-- tip : join by default is hash :)

GO

-- text exection plan
SET SHOWPLAN_ALL ON -- off :D

GO

-- Statistics
sp_helpstats 'Sales', 'ALL'

DBCC SHOW_STATISTICS('Sales', 'PK_SaleId')
USE DemoDb
GO

IF OBJECT_ID('NewProducts','U') IS NOT NULL
DROP TABLE NewProducts
CREATE TABLE NewProducts
(
	Id		INT			PRIMARY KEY ,
	Name	NVARCHAR(200),
	price	DECIMAL(19,4)
)

GO

INSERT NewProducts VALUES (1, 'LightSaber', 49.99)
INSERT NewProducts VALUES (2, 'Blaster', 89.99)
INSERT NewProducts VALUES (4, 'Speeder II', 19.99)
INSERT NewProducts VALUES (7, 'PowerBelt', 69.99)
INSERT NewProducts VALUES (8, 'JetPack', 399.99)
GO

-- MERGE NewProducts data with existng Products data
MERGE dbo.Products AS TARGET
USING NewProducts AS SOURCE ON TARGET.Id = SOURCE.Id
WHEN MATCHED AND (TARGET.Name <> SOURCE.Name OR TARGET.Price <> SOURCE.Price) THEN
	UPDATE
		SET TARGET.Name = SOURCE.Name,
			TARGET.Price = SOURCE.Price
WHEN NOT MATCHED BY TARGET THEN 
	INSERT (Name, Price)
		VALUES(SOURCE.Name, SOURCE.Price)
WHEN NOT MATCHED BY SOURCE THEN DELETE 
	OUTPUT $ACTION,
			DELETED.Id AS TargetId, DELETED.Name AS TargetName, DELETED.Price AS TargetPrice,
			INSERTED.Id AS SourceId, Inserted.Name AS SourceName, INSERTED.Price AS SourcePrice;
SELECT @@ROWCOUNT;
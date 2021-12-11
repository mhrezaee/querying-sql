use master

GO

CREATE LOGIN DemoUser
  WITH
    PASSWORD = '',
    DEFAULT_DATABASE = [AdventureWorks2012],
    CHECK_EXPIRATION = OFF,
    CHECK_POLICY = OFF;

GO

USE AdventureWorks2012

GO

CREATE USER DemoUser
FOR LOGIN DemoUser
	WITH DEFAULT_SCHEMA = [dbo];
GO

USE [AdventureWorks2012]
GO


CREATE VIEW [dbo].[vProductAndDescription] 
AS
	SELECT 
		p.[ProductID] ,p.[Name] ,pm.[Name] AS [ProductModel] ,pmx.[CultureID], 
		pd.[Description],p.StandardCost,p.ListPrice,pi.Quantity,p.ReorderPoint 
	FROM
	 [Production].[Product] p 
		INNER JOIN 
	 [Production].[ProductModel] pm ON p.[ProductModelID] = pm.[ProductModelID] 
		INNER JOIN
	 [Production].[ProductModelProductDescriptionCulture] pmx ON pm.[ProductModelID] = pmx.[ProductModelID] 
		INNER JOIN
	 [Production].[ProductDescription] pd ON pmx.[ProductDescriptionID] = pd.[ProductDescriptionID]
		INNER JOIN
	 Production.ProductInventory pi ON p.ProductID = pi.ProductID;

GO

GRANT SELECT ON dbo.vProductAndDescription TO DemoUser;

REVOKE SELECT ON dbo.vProductAndDescription FROM DemoUser;

GO

CREATE SCHEMA Demo AUTHORIZATION dbo

GO

CREATE VIEW Demo.vEmployee
AS
	SELECT * FROM HumanResources.Employee
GO

CREATE VIEW Demo.vProducts
AS
	SELECT * FROM Production.product
GO

ALTER USER DemoUser WITH DEFAULT_SCHEMA= Demo;

GO

GRANT SELECT ON SCHEMA::Demo TO DemoUser;
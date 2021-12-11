USE DemoDb
GO


CREATE VIEW dbo.vEmployeeSaleOrders
	WITH SCHEMABINDING
AS
	SELECT Employees.Id as eID, -- be khhatere inke esmme har column bayad unique bashe
			Products.Id,
			SUM(Price*Quantity) as SaleTotal,
			SaleDate
		FROM dbo.Employees
					JOIN
			dbo.Sales ON sales.EmployeeId = Employees.Id
					JOIN
			dbo.Products ON Products.Id = Sales.ProductId
		GROUP BY
			Employees.Id, products.Id, SaleDate
GO

CREATE UNIQUE CLUSTERED INDEX CIDX_vEmployeeSaleOrders
	ON vEmployeeSaleOrders(,,) -- it has errors cause of having no count-big aggregate

GO

ALTER VIEW dbo.vEmployeeSaleOrders
	WITH SCHEMABINDING
AS
	SELECT Employees.Id as eID, -- be khhatere inke esmme har column bayad unique bashe
			Products.Id,
			SUM(Price*Quantity) as SaleTotal,
			SaleDate,
			COUNT_BIG(*) AS RecordCount
		FROM dbo.Employees
					JOIN
			dbo.Sales ON sales.EmployeeId = Employees.Id
					JOIN
			dbo.Products ON Products.Id = Sales.ProductId
		GROUP BY
			Employees.Id, products.Id, SaleDate
GO

-- create index view
CREATE UNIQUE CLUSTERED INDEX CIDX_vEmployeeSaleOrders
	ON vEmployeeSaleOrders(eId,Id,SaleDate)
GO

SELECT * FROM dbo.vEmployeeSaleOrders
-- then create index views

SELECT * FROM dbo.vEmployeeSaleOrders WITH (NOEXPAND) -- its more optimized (use ctrl + M to proof it)
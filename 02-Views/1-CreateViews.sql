USE DemoDb
GO

CREATE VIEW vEmployeesWithSales
AS
	SELECT e.* FROM Employees AS e
	JOIN
    Sales AS s
	ON e.Id = s.EmployeeId
GO

SELECT * FROM vEmployeesWithSales
GO

-- create another view

CREATE VIEW vTop10ProductSalesByQuantity
AS
	SELECT TOP 10 
		Name AS ProductName,
		SUM(dbo.Sales.Quantity) AS TotalQuantity
	FROM 
		dbo.Sales
			JOIN
            dbo.Products ON dbo.Sales.ProductId = dbo.Products.Id
	GROUP BY Name
	ORDER BY SUM(dbo.Sales.Quantity) DESC
GO

SELECT * FROM vTop10ProductSalesByQuantity

GO
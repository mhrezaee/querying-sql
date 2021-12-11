USE [DemoDb]
GO

/* add a comma and encryprion near schemabinding*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vEmployeeSaleOrders]
	WITH SCHEMABINDING , ENCRYPTION -- this encryption 
AS
	SELECT Employees.Id as eID, -- because column name should be unique
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


-- after Executing this query no more alter is available cause we made it encrypted :) 

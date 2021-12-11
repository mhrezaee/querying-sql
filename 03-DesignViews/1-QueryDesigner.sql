USE DemoDb
GO
-- run it first
-- then right click and choose Design Query in Editor like below

SELECT        Employees.FirstName, Employees.LastName, Products.Name, Sales.SaleDate
FROM            Sales INNER JOIN
                         Products ON Sales.ProductId = Products.Id INNER JOIN
                         Employees ON Sales.EmployeeId = Employees.Id


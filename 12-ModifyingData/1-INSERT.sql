USE DemoDb
GO
SELECT  Id ,
        ProductId ,
        EmployeeId ,
        Quantity ,
        SaleDate FROM dbo.Sales
-- simple insert statement
INSERT INTO Sales 
		VALUES (null, 1,1,10,GETDATE())
GO
INSERT INTO dbo.Sales
        (
		Id,
          ProductId ,
          EmployeeId ,
          Quantity ,
          SaleDate
        )
VALUES  (NEWID(),
          1 , 
          1 , 
          10 ,
          GETDATE()  
        )

GO

INSERT INTO dbo.Products
        ( Name, Price, DisContinuedFlag )
VALUES  ( N'Case',
          10000, 
          0  
          )


INSERT INTO Sales
        ( Id ,ProductId ,EmployeeId ,Quantity ,SaleDate)
VALUES  ( NULL , -- Id - uniqueidentifier
          0 , -- ProductId - int
          0 , -- EmployeeId - int
          0 , -- Quantity - smallint
          GETDATE()  -- SaleDate - date
        )

GO

INSERT INTO dbo.Sales (ProductId ,EmployeeId ,Quantity)
		VALUES  ( 1,1,10)
GO

-- INSERT INTO SELECT (insert from one table into another pre-existing table
INSERT INTO Sales 
		SELECT NEWID(),2,2,20,GETDATE()
GO

INSERT INTO Sales (ProductId,EmployeeId,Quantity)
	SELECT 2,2,20
GO
-- tip : this line duplicates the data in the table :D
INSERT INTO Sales 
		SELECT 
			NEWID(),ProductId,EmployeeId,Quantity, SaleDate
				 FROM Sales
	SELECT @@ROWCOUNT  -- return number of rows affected
GO
SELECT * FROM dbo.Sales

-- select into (insert from one table into a new table, creating the table LOL :D)
SELECT * INTO
	SalesEmployees
FROM 
	dbo.Employees
WHERE
	Title LIKE 'Sales%'

GO
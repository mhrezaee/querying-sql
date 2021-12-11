USE DemoDb

GO
SELECT * FROM dbo.Employees
-- Create sample Employee Records
INSERT dbo.Employees
        ( FirstName , MiddleName, LastName, Title, HireDate, VacationHours, Salary)
VALUES  ( N'Hadi' ,NULL ,N'Rezaee' ,DEFAULT ,DEFAULT ,DEFAULT ,'50000');
-- the query above is equal to the following query
 INSERT dbo.Employees
         ( FirstName,MiddleName,LastName,Salary)
 VALUES  ( N'Hadi' , NULL , N'Rezaee' ,'50000');

-- Cerate Sample Products Records -- CHECK options
-- for ignoring the check constraint
ALTER TABLE dbo.Products NOCHECK CONSTRAINT CHK_Price;
INSERT dbo.Products SELECT 'Shirt' , -1 , 0
INSERT dbo.Products SELECT 'Shirt' , 12.99 , 0 -- because we used unique constraint this line will not added :D
INSERT dbo.Products SELECT 'Shorts' , 14.99 , 0
INSERT dbo.Products SELECT 'Pants' , 19.99 , 0
ALTER TABLE Products CHECK CONSTRAINT CHK_Price;
INSERT dbo.Products SELECT 'Hat' , 9.99 , 0

-- Create sample Sale Records
INSERT Sales SELECT NEWID(),1,1,4, '02/01/2012' -- because there is no product with id 1 this item will not be added
INSERT Sales SELECT NEWID(),2,1,1, '03/01/2012'
INSERT Sales SELECT NEWID(),3,1,2, '02/01/2012' -- because there is no product with id 3 this item will not be added
INSERT Sales SELECT NEWID(),2,2,2, '04/01/2012'
INSERT Sales SELECT NEWID(),3,2,1, '03/01/2012' -- because there is no product with id 1 this item will not be added
INSERT Sales SELECT NEWID(),4,2,2, '01/01/2012'
INSERT Sales SELECT NEWID(),4,2,2, '02/01/2012'

SELECT * FROM dbo.Products

SELECT * FROM dbo.Sales
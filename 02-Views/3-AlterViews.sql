USE DemoDb
GO

ALTER VIEW	vEmployeesWithSales
AS	
	SELECT
		dbo.Employees.Id, -- why just this column got table name (ambbigues)
		FirstName,
		LastName
		FROM dbo.Employees
			JOIN
            dbo.Sales ON Sales.EmployeeId = Employees.Id
GO

-- try below alter view once with chek option and without chek option
ALTER VIEW vEmployees
AS
	SELECT  Id ,
	        FirstName ,
	        MiddleName ,
	        LastName ,
	        Title ,
	        HireDate ,
	        VacationHours ,
	        Salary FROM dbo.Employees
	WHERE Title = 'Sales Person'
	--WITH CHECK OPTION -- it chekcks on insert if title is sales person allow to add otherwise show error!
GO

-- rename view
 sp_rename 'vEmployeesWithSales','vEmployees'


GO
SELECT * FROM vEmployees

GO

INSERT vEmployees SELECT 3,'Hadi',NULL,'Rezaee','Trainer','1/1/2010',80,'100000.00' -- becuse chek option do not allow to insert
INSERT vEmployees SELECT 4,'Garth',NULL,'Schulte','Sales Person','1/1/2010',80,'100000.00'
GO

SELECT * FROM vEmployees

GO

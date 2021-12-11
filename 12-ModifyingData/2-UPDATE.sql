USE DemoDb
GO

--simple update statement
UPDATE Products
	SET Price = 10000
	WHERE Id = 5

SELECT * FROM dbo.Products

GO


SELECT * FROM Employees

-- update multiple rows (10 percent increase)
UPDATE dbo.Employees
SET VacationHours = VacationHours * 1.10
WHERE Title = 'Sales Person'
GO

-- previous query more optimized
UPDATE Employees
SET VacationHours *= 1.10
WHERE Title = 'Sales Person'
GO

-- update data using join(employees with no sale must die :D)
UPDATE e
SET
	VacationHours = 0,
	Salary = 0
FROM Employees AS e
		LEFT JOIN Sales AS s ON s.EmployeeId = e.Id
WHERE e.Title LIKE 'Sales%'
	AND s.Id IS NULL

SELECT * FROM dbo.Employees
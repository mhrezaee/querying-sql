USE DemoDb
GO

--basic sp to get employees with first/last name parameters
-- SET NOCOUNT ON : thats turns off the whole rows affected by query , this increase performance
IF OBJECT_ID('sp_GetEmployees', 'P') IS NOT NULL
	DROP PROCEDURE dbo.sp_GetEmployees
GO
 
CREATE PROCEDURE sp_GetEmployees
	@firstName NVARCHAR(50),
	@lastName NVARCHAR(50)
AS
	SET NOCOUNT ON;
	
	SELECT  FirstName ,MiddleName ,LastName ,Title ,HireDate
	FROM Employees

	WHERE FirstName = @firstName
		AND LastName = @lastName
GO

-- execute sp
EXECUTE sp_GetEmployees 'Luke', 'SkyWalker'
GO

-- create sp with optional title parameter and wildcard first/last name

IF OBJECT_ID('sp_GetEmployees2', 'P') IS NOT NULL
	DROP PROCEDURE dbo.sp_GetEmployees2
GO
 
CREATE PROCEDURE sp_GetEmployees2
	@firstName NVARCHAR(50),
	@lastName NVARCHAR(50),
	@title NVARCHAR(100) = NULL
AS
	SET NOCOUNT ON;
	
	SELECT  FirstName ,MiddleName ,LastName ,Title ,HireDate
	FROM dbo.Employees

	WHERE FirstName LIKE '%' + @firstName + '%'
		AND LastName LIKE '%' + @lastName + '%'
		AND Title = @title
GO
EXECUTE sp_GetEmployees2 'e', 'e' -- return nothing !
EXECUTE sp_GetEmployees2 'e', 'e', 'Sales Person'
EXEC sp_GetEmployees2 'e'
GO

ALTER PROCEDURE sp_GetEmployees2
	@firstName NVARCHAR(50),
	@lastName NVARCHAR(50),
	@title NVARCHAR(100) = NULL
AS
	SET NOCOUNT ON;
	
	SELECT  FirstName ,MiddleName ,LastName ,Title ,HireDate
	FROM dbo.Employees

	WHERE FirstName LIKE '%' + @firstName + '%'
		AND LastName LIKE '%' + @lastName + '%'
		AND Title = COALESCE(@title, Title)
GO
EXECUTE sp_GetEmployees2 'e', 'e' -- return all titles
GO
EXECUTE sp_GetEmployees2 'e', 'e', 'Sales Person'
GO

--executing sp with specifyinng parameters
EXECUTE sp_GetEmployees2 @lastName = 'e', @firstName = 'e'
GO

--create sp with data range parameters

IF OBJECT_ID('sp_GetEmployees3', 'P') IS NOT NULL
	DROP PROCEDURE dbo.sp_GetEmployees3
	GO
 
CREATE PROCEDURE sp_GetEmployees3
	@firstName NVARCHAR(50),
	@lastName NVARCHAR(50),
	@title NVARCHAR(100) = NULL,
	@beginHireDate DATETIME = NULL,
	@endHireDate DATETIME = NULL
AS
	SET NOCOUNT ON;

	SELECT FirstName, MiddleName, LastName,
			Title, HireDate
	FROM dbo.Employees
	WHERE FirstName LIKE '%' + @firstName + '%'
		AND LastName LIKE '%' + @lastName + '%'
		AND Title = COALESCE(@title, Title)
		AND (
				DATEDIFF(d,@beginHireDate,HireDate) >= 0
				AND
				DATEDIFF(d,@endHireDate,HireDate) <= 0
			)-- also we can write next line :)
			--AND HireDate BETWEEN @beginHireDate AND @endHireDate
GO
EXECUTE sp_GetEmployees3 'e', 'a', NULL , '1/1/2005', '1/1/2008'
GO

--drop sp  do not execute :)
DROP PROCEDURE sp_GetEmployees
-- do not execute
GRANT EXECUTE ON sp_GetEmployees TO [user]


GO


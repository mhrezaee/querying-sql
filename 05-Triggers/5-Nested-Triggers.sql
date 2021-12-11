USE DemoDb

GO

CREATE TABLE EmployeeAuditTrail
(
	Id				INT 			NOT NULL	IDENTITY	PRIMARY KEY	CLUSTERED,
	EmployeeId		INT				NOT NULL,
	FirstName		NVARCHAR(50)	NULL,
	MiddleName		NVARCHAR(50)	NULL,
	LastName		NVARCHAR(50)	NULL,
	Title			NVARCHAR(100)	NULL,
	HireDate		DATETIME		NULL,
	VacationHours	INT				NULL,
	Salary			DECIMAL(19,4)	NULL,
	ModifiedDate	DATETIME		NULL,
	ModifiedBy		NVARCHAR(255)	NULL
)

GO

IF OBJECT_ID('udEmployeeAudit', 'TR') IS NOT NULL
		DROP TRIGGER udEmployeeAudit
GO

CREATE TRIGGER udEmployeeAudit ON dbo.Employees
	FOR UPDATE, DELETE
AS
		INSERT EmployeeAuditTrail
			SELECT

			e.Id, d.Firstname, d.MiddleName , d.LastName,
			d.Title , d.HireDate, d.VacationHours, d.Salary,
			GETDATE(), SYSTEM_USER

			FROM
				Employees AS e
					JOIN
				DELETED AS d ON e.Id = d.Id
GO

IF OBJECT_ID('uRecalculateVacationHours', 'TR') IS NOT NULL
		DROP TRIGGER uRecalculateVacationHours
GO

CREATE TRIGGER uRecalculateVacationHours ON Employees
	FOR UPDATE 
AS
	IF UPDATE(HireDate)
		BEGIN
			DECLARE @RecalcFlag BIT
			SELECT @RecalcFlag = IIF(YEAR(HireDate) = 2014, 1 , 0) FROM INSERTED
				
			IF (@RecalcFlag = 1)
				UPDATE Employees SET VacationHours += 40 FROM Employees AS e
					JOIN
				INSERTED AS i ON e.Id = i.Id
		END
GO


-- to enable and disable nested triggers

sp_configure 'nested_triggers', 0 -- for enabling instead of 0 , wirte 1 :) 
GO
RECONFIGURE
GO
-- after executing go too db properties -> Options and proof that nestedtriggers are off
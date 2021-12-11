USE DemoDb
GO

/*-- Generating XML from data --*/
--FOR XML ROW
SELECT * FROM dbo.Employees
	FOR XML RAW
GO

SELECT * FROM dbo.Employees
	FOR XML RAW ('Employee'), ELEMENTS
GO

SELECT * FROM dbo.Employees
	FOR XML RAW ('Employee'), ROOT('Employees'), ELEMENTS
GO

--FOR XML AUTO
SELECT * FROM Employees
	FOR XML AUTO 
GO

-- FOR XML PATH
SELECT * FROM dbo.Employees
	FOR XML PATH
GO

-- FOR XML PATH AND defining atributes
SELECT Id AS "@EmployeeId",
		FirstName, LastName		
FROM dbo.Employees
FOR XML PATH ('Employee')
GO

-- FOR XML EXPLICIT nested data
SELECT 
	 1			AS	Tag,
	 NULL		AS	Parent,
	 Id			AS	[Employee!1!EmployeeId],
	 FirstName	AS	[Name!2!FirstName!element],
	 LastName	AS	[Name!2!LastName!element]
FROM dbo.Employees
UNION 
SELECT
	 2			AS	Tag,
	 1			AS	Parent,
	 Id, FirstName, LastName
FROM Employees
ORDER BY [Employee!1!EmployeeId], [Name!2!LastName!element]
FOR XML EXPLICIT
GO

/* -- XML Data Type*/
ALTER TABLE dbo.Employees
	ADD Bio XML DEFAULT N'<EmployeeBio></EmployeeBio>'
GO

--Loading XML
DECLARE @xmlData XML
SELECT @xmlData = CAST(BulkColumn AS XML)
 FROM OPENROWSET
 (BULK N'C:\Users\Hadi Rezaee\Documents\SQL Server Management Studio\70-461 Querying SQL2012\10-XML\EmployeeBio.xml',
	 SINGLE_BLOB) as x
SELECT @xmlData

UPDATE dbo.Employees
SET Bio = @xmlData
	WHERE Id = 4
GO

--Reading XML
CREATE VIEW vEmployeeBioInfo
AS
	SELECT Id, FirstName, LastName,
			Bio.value('(/EmployeeBio/BirthPlace)[1]', 'VARCHAR(75)') AS BirthPlace,
			Bio.value('(/EmployeeBio/Residence)[1]', 'VARCHAR(75)') AS Residence,
			Bio.value('(/EmployeeBio/Side)[1]', 'CHAR(5)') AS Stance
		FROM dbo.Employees
GO

SELECT * FROM vEmployeeBioInfo
GO

SELECT Bio.query('/EmployeeBio/Appearances')
FROM dbo.Employees WHERE Id = 4
GO

SELECT * FROM dbo.Employees
WHERE Bio.exist('/EmployeeBio[Side="Light"]') = 1
GO

--Indexing XML Columns
CREATE PRIMARY XML INDEX PXML_Bio ON dbo.Employees (Bio)
GO -- thi is Primary

CREATE XML INDEX IXML_Bio ON dbo.Employees (Bio)
	USING XML INDEX PXML_Bio FOR PROPERTY -- thi is secondry
USE DemoDb
GO

-- Configuration functions

SELECT @@VERSION
SELECT @@SERVERNAME
SELECT @@SERVICENAME

-- system Functions

SELECT @@CONNECTIONS

--security Functions

SELECT SYSTEM_USER
SELECT CURRENT_USER

-- conversions functions
--- CAST
SELECT '$' + CAST(Price AS NVARCHAR(20)) AS Price FROM Products

---CONVERT
SELECT SaleDate, CONVERT(VARCHAR,SaleDate,7) AS formattedSaleDate FROM dbo.Sales

--tip: hit shift+f1 on convert too proof numbers do what like 7 :)

--Logic Functions
---IIF
SELECT Id, FirstName, LastName, ManagerId,
		IIF(ManagerId IS NULL, 'No', 'Yes') AS [HasManager?]
FROM dbo.Employees

-- mathematical functions
--- ROUND
SELECT ROUND(10.124,2), ROUND(104.99, -2)

---POWER
DECLARE @value INT, @Counter INT
SET @value = 2
SET @Counter = 1

WHILE @Counter < 10
	BEGIN
		PRINT POWER(@value, @Counter)
		SET @Counter += 1
	END
GO

---RAND (non-determenistic)
SELECT RAND()

---RAND (Determenistic)
SELECT RAND(1)
--tip: if we pass a seed the result always the same

--Metadata Functions
---OBJECT_ID
IF OBJECT_ID('dbo.ObjectToDrop', 'ObjectType') IS NOT NULL
		DROP [ObjectType] dbo.ObjectToDrop
GO

---OBJECTPROPERTY
SELECT OBJECTPROPERTY(OBJECT_ID('dbo.GetProductSalesTotal'),'IsDeterministic')

---ServerProperty
SELECT SERVERPROPERTY('Edition')

---DbName
SELECT DB_NAME()

--StringFunctions
---REPLACE
SELECT Name, REPLACE(Name,'er','ing') AS ERtoING
FROM Products

---LEN
SELECT FirstName,LastName,
		 LEN(FirstName + LastName) AS NameLength
FROM dbo.Employees


---RTRIM/LTRIM
SELECT '     Spaces' AS TooMany, LTRIM('     Spaces') AS JustRight

---SUBSTRING
SELECT FirstName, LastName,
		COALESCE(SUBSTRING(FirstName,1,1)+'.', '')
			+ COALESCE(SUBSTRING(LastName,1,1) + '.','') AS Initials
 FROM dbo.Employees

 --Substring(FirstName,1,1) means starts with first Character and length is 1

 ---STUFF / CHARINDEX / SPACE
 DECLARE @string VARCHAR(20)
 SET @string = 'Watch     StarWars'
 SELECT STUFF(@string, CHARINDEX(SPACE(1), @string) + 1, 2, 'More') AS [:) :D]

 ---REVERSE
 SELECT REVERSE('Hadi Rezaee')
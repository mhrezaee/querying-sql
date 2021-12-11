USE DemoDb

GO

--Using Cursors against tables
DECLARE @ProductId INT

DECLARE dataCursor CURSOR FOR 
	SELECT
		Id
	FROM 
		Products
	WHERE 
		DisContinuedFlag = 0

OPEN dataCursor FETCH NEXT FROM dataCursor INTO @ProductId
	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			SELECT
				@ProductId,
				SUM(Quantity) AS TotalQuantity,
				COUNT(*) AS TotalSales
			FROM 
				Sales
			WHERE 
				ProductId = @ProductId

			FETCH NEXT FROM dataCursor INTO @ProductId
		END
CLOSE dataCursor
DEALLOCATE dataCursor

GO

-- Second Way (with ProductREsult Temporary Table)

DECLARE @ProductId INT

CREATE TABLE #ProductResults
(
	Id			INT,
	Quantity	INT,
	TotalSales	INT
)

DECLARE dataCursor CURSOR FOR 
	SELECT
		Id
	FROM 
		Products
	WHERE 
		DisContinuedFlag = 0

OPEN dataCursor FETCH NEXT FROM dataCursor INTO @ProductId
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT #ProductResults
				SELECT
					@ProductId,
					SUM(Quantity) AS TotalQuantity,
					COUNT(*) AS TotalSales
				FROM 
					Sales
				WHERE 
					ProductId = @ProductId

			FETCH NEXT FROM dataCursor INTO @ProductId
		END

SELECT * FROM #ProductResults
DROP TABLE #ProductResults

CLOSE dataCursor
DEALLOCATE dataCursor
GO

-- Table VAriable with while loop
DECLARE @Products TABLE
(
	Id			INT		IDENTITY,
	ProductId	INT
)

DECLARE @CurRow INT = 1,
		@TotalRows INT

INSERT INTO @Products
	SELECT Id FROM dbo.Products WHERE DisContinuedFlag = 0

SELECT @TotalRows = @@ROWCOUNT

WHILE @CurRow <= @TotalRows
	BEGIN 
		DECLARE @ProductId INT
		SELECT @ProductId = ProductId FROM @Products WHERE Id = @CurRow

		SELECT
			@ProductId,
			SUM(Quantity) AS TotalQuantity,
			COUNT(*)  AS TotalSales
		FROM 
			Sales
		WHERE 
			ProductId = @ProductId
		
		SET @CurRow += 1
	END
GO

-- cursor for backing up all user databases

DECLARE @name VARCHAR(50),
		@path VARCHAR(256),
		@fileName VARCHAR(256),
		@fileDate VARCHAR(20)

SET @path = 'C:\70-461 Support Files\Backup\'
SET @fileDate = CONVERT(VARCHAR(20), GETDATE(), 112)

DECLARE dbCursor CURSOR FOR 
	SELECT
		name
	FROM 
		master.dbo.sysdatabases
	WHERE
		dbid > 16

OPEN dbCursor FETCH NEXT FROM dbCursor INTO @name
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @fileName = @path + @name + '_' + @fileDate + '.bak'
			BACKUP DATABASE @name TO DISK = @fileName

			FETCH NEXT FROM dbCursor INTO @name
		END

CLOSE dbCursor
DEALLOCATE dbCursor
GO

-- Scalar UDF
CREATE FUNCTION GetManagerName
(
	@ManagerId INT
)
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @ManagerName NVARCHAR(100)

	SELECT 
		@ManagerName = COALESCE(FirstName + ' ' + LastName, LastName, FirstName) 
	FROM 
		dbo.Employees
	WHERE
		ManagerId = @ManagerId
	RETURN @ManagerName
END
GO

-- scalar Udf is called for each row
SELECT
	Id,
	FirstName,
	LastName,
	dbo.GetManagerName(ManagerId) AS Manager
FROM 
	Employees
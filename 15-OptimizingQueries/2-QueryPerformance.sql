USE DemoDb
GO

-- :( * is not performance friendly

SELECT * FROM dbo.Sales

-- :) rewrite using only what you need

SELECT EmployeeId, Quantity, SaleDate FROM dbo.Sales

GO

-- :( Inequality forces Table Scans

SELECT * FROM dbo.Sales
WHERE Quantity <> 0

-- :) Rewrite to eliminate Inequality

SELECT * FROM dbo.Sales
WHERE Quantity > 0
GO

-- :( Having Filter rows after they are returned

SELECT ProductId,
		SUM(Quantity) AS TotalQuantity
FROM dbo.Sales
GROUP BY ProductId
HAVING SUM(Quantity) > 0
GO

-- :) WHERE filters rows out before they are returned
SELECT ProductId,
		SUM(Quantity) AS TotalQuantity
FROM dbo.Sales
WHERE Quantity > 0
GROUP BY ProductId
GO

-- :) IN is best when filter criteria is in subquery
SELECT Id, ProductId, SaleDate
FROM dbo.Sales
	WHERE ProductId IN
					(
						SELECT Id FROM dbo.Products
						WHERE DisContinuedFlag = 0
					)
GO

-- :) EXISTS is best when filter criteria is in main query

SELECT Id, ProductId, SaleDate
 FROM dbo.Sales AS s
 WHERE DATEPART(yyyy,SaleDate) = YEAR(GETDATE())
 AND
 EXISTS (SELECT * FROM dbo.Products AS p WHERE p.Id = s.ProductId)
 GO
 
 
-- Use DMVs too find poor or long running queries 
-- return top 10 longest running queries 
SELECT TOP 10
	qs.total_elapsed_time / qs.execution_count / 1000000.0 AS AverageSeconds,
	qs.total_elapsed_time / 1000000.0 AS TotalSeconds,
	qt.text AS Query,
	o.name AS ObjectName,
	DB_NAME(qt.dbid) AS DatabaseName
FROM 
	sys.dm_exec_query_stats AS qs
		CROSS APPLY
	sys.dm_exec_sql_text(qs.sql_handle) AS qt
		LEFT OUTER JOIN
	sys.objects AS o ON qt.objectid = o.object_id
ORDER BY AverageSeconds


-- return top 10 most expensive queries
SELECT TOP 10 
	(total_logical_reads + total_logical_writes) / qs.execution_count AS AverageIo,
	(total_logical_reads + total_logical_writes) AS TotalIO,
	qt.text AS Query,
	o.name AS ObjectName,
	DB_NAME(qt.dbid) AS DatabaseName
FROM 
	sys.dm_exec_query_stats AS qs
		CROSS APPLY
	sys.dm_exec_sql_text(qs.sql_handle) AS qt
		LEFT OUTER JOIN
	sys.objects AS o ON qt.objectid = o.object_id
ORDER BY AverageIO DESC
GO 
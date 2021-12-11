USE DemoDb
GO

--Ranking
SELECT
	EmployeeId, ProductId,
	SUM(Quantity) AS TotalProductsSales,
	RANK() OVER (ORDER BY SUM(Quantity) DESC) AS QuantityRank,
	DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS QuntityDenseRank,
	NTILE(4) OVER (ORDER BY SUM(Quantity) DESC) AS QuantityQuarTile,
	ROW_NUMBER() OVER (ORDER BY SUM(Quantity) DESC) AS RowNumber
FROM dbo.Sales AS s
GROUP BY EmployeeId, ProductId
/* Tip:
	RANK: age 2 meghdar barabar bashan masalan minevise 7 , 7 , badi mishe 9
Dens_RANK: age 2 meghdar barabar bashan masalan minevise 7 , 7 , badi mishe 8
*/
GO

--Ranking across a group using PARTITION
SELECT
	EmployeeId, ProductId,
	SUM(Quantity) AS TotalProductsSales,
	RANK() OVER (PARTITION BY EmployeeId ORDER BY SUM(Quantity) DESC) AS QuantityRank,
	DENSE_RANK() OVER (PARTITION BY EmployeeId ORDER BY SUM(Quantity) DESC) AS QuntityDenseRank,
	NTILE(4) OVER (PARTITION BY EmployeeId ORDER BY SUM(Quantity) DESC) AS QuantityQuarTile,
	ROW_NUMBER() OVER (PARTITION BY EmployeeId ORDER BY SUM(Quantity) DESC) AS RowNumber
FROM dbo.Sales AS s
GROUP BY EmployeeId, ProductId

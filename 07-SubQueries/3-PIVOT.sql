USE DemoDb
GO

-- PIVOT for SUM of quantity by year
-- too har sal cheghad mahsool forokhte shode :)
-- masalan bebinim too che sali bishtarin foroosh ro dashtim
-- age bar asase har mahsool bekhaym too select ProductId ro ham ezfe mikonim
SELECT * FROM (	SELECT
				--ProductId,
				YEAR(SaleDate) AS SaleYear,
				Quantity
				FROM Sales) AS s
		PIVOT
			  (SUM(Quantity)
			  FOR SaleYear
			  IN ([2005],[2006],[2007],[2008],[2009],[2010],[2011],[2012])
			  ) AS pt
GO

--PIVOT for AVG Sales per year by product
SELECT p.NAME, pt.*
FROM (
		SELECT	Sales.ProductId,
				YEAR(SaleDate) AS SaleYear,
				Price * Quantity AS SaleTotal
		FROM dbo.Sales
		INNER JOIN Products ON dbo.Products.Id = dbo.Sales.ProductId
		) AS s
	PIVOT
		(
			AVG(SaleTotal) 
			FOR SaleYear
				IN ([2005],[2006],[2007],[2008],[2009],[2010],[2011],[2012])
		) AS pt
	INNER JOIN dbo.Products p ON p.Id = pt.ProductId
	ORDER BY pt.ProductId
/*
2. Вывести список 2х самых популярных продуктов (по кол-ву проданных) в каждом месяце за 
	2016й год (по 2 самых популярных продукта в каждом месяце)
*/

SELECT StockName AS 'Продукт'
	,RowRank AS 'Популярность из 2-х'
	,Mon AS 'Месяц'
	,QtyPerMonth AS 'Количество'
FROM
(
	SELECT 
		StockName
		,Mon
		,QtyPerMonth
		,ROW_Number() OVER(PARTITION BY MON ORDER BY QtyPerMonth DESC) AS RowRank
	FROM(
			SELECT DISTINCT
				SI.StockItemName AS StockName
				, MONTH(I.[InvoiceDate]) AS Mon
				,SUM(IL.[Quantity]) OVER(PARTITION BY MONTH(I.[InvoiceDate]),IL.[StockItemID]  ORDER BY IL.[StockItemID] )  AS QtyPerMonth
			FROM [Sales].[InvoiceLines] AS IL 
			JOIN [Warehouse].[StockItems] AS SI ON SI.StockItemID = IL.StockItemID
			JOIN [Sales].[Invoices] AS I ON I.InvoiceID = IL.InvoiceID
			WHERE YEAR([InvoiceDate]) = 2016
		) AS ITT1 
) AS ITT2
WHERE RowRank < 3
ORDER BY mon,RowRank

--Переделано на  CTE

;WITH InitialSample (ProdName, Monsample, QtyPerMonth)
	AS
	(
		SELECT DISTINCT
			SI.StockItemName AS StockName
			, MONTH(I.[InvoiceDate]) AS Mon
			,SUM(IL.[Quantity]) OVER(PARTITION BY MONTH(I.[InvoiceDate]),IL.[StockItemID]  ORDER BY IL.[StockItemID] )  AS QtyPerMonth
		FROM [Sales].[InvoiceLines] AS IL 
		JOIN [Warehouse].[StockItems] AS SI ON SI.StockItemID = IL.StockItemID
		JOIN [Sales].[Invoices] AS I ON I.InvoiceID = IL.InvoiceID
		WHERE  YEAR([InvoiceDate]) = 2016
	)
,
	BuildRank (StokName, NumMon, QtyPerMonth, RowRank)
	AS
	(
		SELECT 
			ProdName
			,Monsample
			,QtyPerMonth
			,ROW_Number() OVER(PARTITION BY Monsample ORDER BY QtyPerMonth DESC) AS RowRank
		FROM InitialSample AS I
	)
SELECT 
	StokName AS 'Продукт'
	,RowRank  AS 'Популярность из 2-х'
	,NumMon AS 'Месяц'
	,QtyPerMonth AS 'Количество'
FROM BuildRank 
WHERE RowRank <3
ORDER BY NumMon,RowRank


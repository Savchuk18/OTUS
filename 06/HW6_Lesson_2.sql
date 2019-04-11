/*
2. Вывести список 2х самых популярных продуктов (по кол-ву проданных) в каждом месяце за 
	2016й год (по 2 самых популярных продукта в каждом месяце)
*/

SELECT StockName AS 'Продукт'
	--,rr AS 'Популярность из 2-х'
	--,Mon AS 'Месяц'
	--,QTyMonth AS 'Количество'
FROM
(
SELECT 
	StockName
	,Mon
	,QTyMonth
	,ROW_Number() OVER(PARTITION BY MON ORDER BY QTyMonth DESC) AS rr
FROM(
		SELECT DISTINCT
			SI.StockItemName AS StockName
			, MONTH(I.[InvoiceDate]) AS Mon
			,SUM(IL.[Quantity]) OVER(PARTITION BY MONTH(I.[InvoiceDate]),IL.[StockItemID]  ORDER BY IL.[StockItemID] )  AS QTyMonth
		FROM [Sales].[InvoiceLines] AS IL 
		JOIN [Warehouse].[StockItems] AS SI ON SI.StockItemID = IL.StockItemID
		JOIN [Sales].[Invoices] AS I ON I.InvoiceID = IL.InvoiceID
		WHERE I.[InvoiceDate] > '20151231' AND I.[InvoiceDate] < '20170101'
	) AS ITT1 
	) AS ITT2
	WHERE rr < 3
	--ORDER BY mon,rr
	

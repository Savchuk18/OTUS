
;
WITH MAXTOP3 (ItemID) -- Сначала выберем 3 самых дорогих товара
AS
(
SELECT TOP (3) WITH TIES 
	StockItemID
FROM [Warehouse].[StockItems]
ORDER BY UnitPrice DESC
)
SELECT 
	AC.CityID
	,AC.CityName
	,AP.FullName
FROM [Sales].[InvoiceLines] AS IL											-- во всех сф найдём товары
JOIN MAXTOP3 AS M3 ON IL.StockItemID=M3.ItemID								--которые должны быть самыми дорогими
JOIN [Sales].[Invoices] AS SI ON SI.InvoiceID = IL.InvoiceID				-- из заголовка сф
JOIN [Sales].[Customers] AS SC ON SC.CustomerID = SI.CustomerID				-- найдём покупателя
JOIN [Application].[Cities] AS AC ON AC.CityID = SC.DeliveryCityID			-- чтобы найти город отправки
JOIN [Application].[People] AS AP ON AP.PersonID = SI.PackedByPersonID		-- и чтобы узнать упковщика
 

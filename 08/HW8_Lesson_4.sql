/*
4. Перепишите ДЗ из оконных функций через CROSS APPLY 
Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки

*/

SELECT --TOP 2 WITH TIES
	C.[CustomerID]
	,C.[CustomerName]
	,SeekSales.StockItemID
	,SeekSales.UnitPrice
	,Seeksales.InvoiceDate
FROM [Sales].[Customers] AS C
CROSS APPLY (SELECT  distinct TOP 2 WITH TIES
					IL.[StockItemID]
					,IL.UnitPrice
					,I.InvoiceDate
				FROM [Sales].[Invoices] AS I
				JOIN [Sales].[InvoiceLines] AS IL ON IL.InvoiceID = I.InvoiceID

				WHERE I.CustomerID = C.CustomerID
				ORDER BY IL.UnitPrice DESC
			) AS SeekSales
ORDER BY  C.CustomerID


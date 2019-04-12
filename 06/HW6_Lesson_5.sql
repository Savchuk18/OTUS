/*
5. Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки

*/

-- Возник вопрос - а что, если клиент дорогие товары покупал по нескольку раз?
-- в условии указано, что нужна дата продажи, и не сказано - первая или последняя,
-- поэтому вроде получается, что все продажи, какие должны быть...

;WITH ListProduct (ProductID,ProductPrice,ClientID)
	AS
	(
		SELECT DISTINCT	-- DISTINCT отрабатывает поле оконных функций, поэтому сначала уберём дубли
			[StockItemID]
			,[UnitPrice]
			,I.CustomerID -- можно, в принципе здесь и название клиента подцепить, но оставим как есть.
		FROM [Sales].[InvoiceLines] AS IL
		JOIN [Sales].[Invoices] AS I ON I.[InvoiceID] = IL.InvoiceID
	)
	,
	RankListPro (PrID,PrPrice,CliID,rnk)
	AS
	(
		SELECT ProductID
			,ProductPrice
			,ClientID
			,RANK() OVER(Partition BY ClientId ORDER BY ProductPrice DESC) as rnk
		FROM ListProduct
	)
SELECT 
	R.CliID AS 'ID Клиента'
	,[CustomerName] AS 'Название клиента'
	,R.PrID AS 'ID Продукта'
	,R.PrPrice AS 'Цена продукта'
	,I.InvoiceDate AS 'Дата продажи'
FROm RankListPro AS R
JOIN [Sales].[Invoices] AS I ON I.[CustomerID] = R.CliID
JOIN [Sales].[InvoiceLines] AS Il ON IL.InvoiceID = I.InvoiceID AND IL.StockItemID = R.PrID
JOIN [Sales].[Customers] AS C ON C.[CustomerID] = R.CliID
WHERE R.rnk < 3
ORDER BY R.CliID

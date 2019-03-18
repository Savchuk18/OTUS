
/*
Посчитать среднюю цену товара, общую сумму продажи по месяцам
*/
SELECT 
	YEAR([InvoiceDate]) AS 'Год'
	 ,MONTH([InvoiceDate]) AS 'Месяц'
	 ,AVG(IL.UnitPrice) AS 'Средняя цена'
	 ,SUM(IL.UnitPrice*[Quantity])	AS 'Сумма за месяц'
FROM [Sales].[InvoiceLines] AS IL
JOIN [Sales].[Invoices] AS I ON I.InvoiceID = IL.InvoiceID
GROUP BY YEAR([InvoiceDate]), MONTH([InvoiceDate])
--ORDER BY YEAR([InvoiceDate]), MONTH([InvoiceDate]) -- Про сортировку ничего не было сказано, но удобнее смотреть.



/*
Отобразить все месяцы, где общая сумма продаж превысила 10 000 
*/
SELECT 
     YEAR([InvoiceDate]) AS 'Год'
	 ,MONTH([InvoiceDate]) AS 'Месяц'
	 ,SUM(IL.UnitPrice*[Quantity])	AS 'Сумма за месяц > 10000'
FROM [Sales].[InvoiceLines] AS IL
JOIN [Sales].[Invoices] AS I ON I.InvoiceID = IL.InvoiceID
GROUP BY YEAR([InvoiceDate]), MONTH([InvoiceDate])
HAVING SUM(IL.UnitPrice*[Quantity]) > 10000


/*
Вывести сумму продаж, дату первой продажи и количество проданного по месяцам, по товарам, продажи которых менее 50 ед в месяц. 
*/

SELECT 
     YEAR([InvoiceDate]) AS 'Год'
	 ,MONTH([InvoiceDate]) AS 'Месяц'
	 ,[StockItemID] AS 'Товар'
	 ,COUNT([Quantity])	AS 'Количество за месяц'
FROM [Sales].[InvoiceLines] AS IL
JOIN [Sales].[Invoices] AS I ON I.InvoiceID = IL.InvoiceID
GROUP BY YEAR([InvoiceDate]), MONTH([InvoiceDate]), [StockItemID]
HAVING COUNT([Quantity]) < 50


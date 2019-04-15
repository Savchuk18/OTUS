-- продолжение

-- С табличной переменной вместо временной таблицы
set statistics time on;

PRINT('-------------- Another variant --------------')
DECLARE @ITT  TABLE(Summ DECIMAL(19,2), Mm int)
INSERT INTO @ITT
	(
	Summ,
	Mm
	)
	SELECT SUM(AmountExcludingTax), MONTH(I.InvoiceDate)
		FROM [Sales].[Invoices] AS I
		JOIN [Sales].[CustomerTransactions] AS T ON I.[InvoiceID] = T.[InvoiceID]
		WHERE I.InvoiceDate > '20141231'
		GROUP BY MONTH(I.InvoiceDate);
SELECT 
	I.[InvoiceID] As N'Продажа'
	,P.CustomerName As N'Клиент'
	,I.InvoiceDate As N'Дата продажи'
	,T.AmountExcludingTax As N'Сумма продажи'
	,(SELECT SUM(Summ) FROM @ITT AS IT WHERE IT.mm <= MONTH(I.InvoiceDate )) AS N'С нарастающим итогом'--IT.Summ
FROM [Sales].[Invoices] As I
JOIN [Sales].[CustomerTransactions] AS T ON T.InvoiceID = I.InvoiceID
JOIN [Sales].[Customers] AS P ON P.CustomerID = I.CustomerID 
WHERE I.InvoiceDate > '20141231'
ORDER BY MONTH(I.[InvoiceDate]),I.InvoiceID --  для наглядности
set statistics time off;

/*
1. Напишите запрос с временной таблицей и перепишите его с табличной переменной. Сравните планы. 
В качестве запроса с временной таблицей и табличной переменной можно взять свой запрос. 
Или запрос из ДЗ по Оконным функциям 
Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года (в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки)
Выведите id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом
Пример 
Дата продажи Нарастающий итог по месяцу
2015-01-29	4801725.31
2015-01-30	4801725.31
2015-01-31	4801725.31
2015-02-01	9626342.98
2015-02-02	9626342.98
2015-02-03	9626342.98
Нарастающий итог должен быть без оконной функции. 

*/

-- За исходный запрос взят из предыдущего ДЗ по оконным функциям, где использовалась CTE без оконных функций

-- Анализ 2-х планов счетов - с временной таблицей и с табличной переменной отличаются только при заполнении табличной переменной 
-- или временной таблицы. 
-- Причём по таймингу табличная переменная заполняется быстрее, скорее всего, потому что табличная переменная создаётся в памяти.
-- ну и сам план для табличной переменной выглядит попроще.

-- С временной таблицей вместо CTE
set statistics time on;


IF OBJECT_ID('tempdb..#ITT') IS NOT NULL
    DROP TABLE #ITT
CREATE TABLE #ITT (Summ DECIMAL(19,2), Mm int)
INSERT INTO #ITT
	(
	Summ,
	Mm
	)
	SELECT SUM(AmountExcludingTax), MONTH(I.InvoiceDate)
		FROM [Sales].[Invoices] AS I
		JOIN [Sales].[CustomerTransactions] AS T ON I.[InvoiceID] = T.[InvoiceID]
		WHERE I.InvoiceDate > '20141231'
		GROUP BY MONTH(I.InvoiceDate);
--		SELECT * FROM #ITT



SELECT 
	I.[InvoiceID] As N'Продажа'
	,P.CustomerName As N'Клиент'
	,I.InvoiceDate As N'Дата продажи'
	,T.AmountExcludingTax As N'Сумма продажи'
	,(SELECT SUM(Summ) FROM #ITT AS IT WHERE IT.mm <= MONTH(I.InvoiceDate )) AS N'С нарастающим итогом'--IT.Summ
FROM [Sales].[Invoices] As I
JOIN [Sales].[CustomerTransactions] AS T ON T.InvoiceID = I.InvoiceID
JOIN [Sales].[Customers] AS P ON P.CustomerID = I.CustomerID 
WHERE I.InvoiceDate > '20141231'
ORDER BY MONTH(I.[InvoiceDate]),I.InvoiceID --  для наглядности


set statistics time off;




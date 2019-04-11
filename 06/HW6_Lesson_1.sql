/*
1.Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года 
(в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки)
Выведите id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом
Пример 
Дата продажи Нарастающий итог по месяцу
2015-01-29	4801725.31
2015-01-30	4801725.31
2015-01-31	4801725.31
2015-02-01	9626342.98
2015-02-02	9626342.98
2015-02-03	9626342.98
Продажи можно взять из таблицы Invoices.
Сделать 2 варианта запроса - через windows function и без них. Написать какой быстрее выполняется, сравнить по set statistics time on;
*/

-- В условии задачи не сказано, что надо разделять года, получается, что 2016.01.01 и 2015.01.01 должны попадать в один
-- диапазон (RANGE).

set statistics time on;
SELECT 
I.[InvoiceID] As N'Продажа'
,P.CustomerName As N'Клиент'
,I.[InvoiceDate] N'Дата продажи'
,trans.AmountExcludingTax N'Сумма продажи'
,SUM(trans.AmountExcludingTax) OVER(ORDER BY MONTH(I.[InvoiceDate]))  AS N'С нарастающим итогом'
FROM [Sales].[Invoices] AS I
JOIN Sales.CustomerTransactions as trans ON Trans.InvoiceID = I.InvoiceID
JOIN [Sales].[Customers] AS P ON P.CustomerID = I.CustomerID 
WHERE [InvoiceDate] > '20141231'
ORDER BY MONTH(I.[InvoiceDate]),I.InvoiceID --  для наглядности

PRINT('-------------- Another request --------------')

-- Без оконных функций, используя CTE

;WITH IT (Summ,mm)
AS
(
SELECT SUM(AmountExcludingTax), MONTH(I.InvoiceDate)
FROM [Sales].[Invoices] AS I
JOIN [Sales].[CustomerTransactions] AS T ON I.[InvoiceID] = T.[InvoiceID]
WHERE I.InvoiceDate > '20141231'
GROUP BY MONTH(I.InvoiceDate)
)
SELECT 
	I.[InvoiceID] As N'Продажа'
	,P.CustomerName As N'Клиент'
	,I.InvoiceDate As N'Дата продажи'
	,T.AmountExcludingTax As N'Сумма продажи'
	,(SELECT SUM(Summ) FROM IT WHERE IT.mm <= MONTH(I.InvoiceDate )) AS N'С нарастающим итогом'--IT.Summ
FROM [Sales].[Invoices] As I
JOIN [Sales].[CustomerTransactions] AS T ON T.InvoiceID = I.InvoiceID
JOIN [Sales].[Customers] AS P ON P.CustomerID = I.CustomerID 
WHERE I.InvoiceDate > '20141231'
ORDER BY MONTH(I.[InvoiceDate]),I.InvoiceID --  для наглядности
 
set statistics time off;


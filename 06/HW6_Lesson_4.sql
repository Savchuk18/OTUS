/*
4. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал
В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки

*/

SELECT DISTINCT
	I.[SalespersonPersonID] AS 'ID продавца'
	,P.[FullName] AS 'Полное имя продавца'
	,LAST_VALUE(I.CustomerID) OVER(PARTITION BY I.SalespersonPersonID ORDER BY I.InvoiceDate, I.[InvoiceID] ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS 'ID Последнего клиента'
	,LAST_VALUE(C.[CustomerName]) OVER(PARTITION BY I.SalespersonPersonID ORDER BY I.InvoiceDate, I.[InvoiceID] ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS 'Последний клиент'
	,LAST_VALUE(I.InvoiceDate) OVER(PARTITION BY I.SalespersonPersonID ORDER BY I.InvoiceDate, I.[InvoiceID]  ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS 'Дата последней продажи'
	,LAST_VALUE([TransactionAmount]) OVER(PARTITION BY I.SalespersonPersonID ORDER BY I.InvoiceDate, I.[InvoiceID] ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS 'Сумма последней сделки'
FROM [Application].[People] AS P  
JOIN [Sales].[Invoices] AS I ON I.SalespersonPersonID = P.PersonID
JOIN [Sales].[CustomerTransactions] AS CT ON CT.InvoiceID = I.InvoiceID
JOIN [Sales].[Customers] AS C ON C.CustomerID = I.CustomerID
WHERE IsSalesperson=1


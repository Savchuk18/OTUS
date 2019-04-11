/*
Bonus из предыдущей темы
Напишите запрос, который выбирает 10 клиентов, которые сделали больше 30 заказов и последний заказ был не позднее апреля 2016.
*/

-- В условии задачи не сказано, что запрос должен быть детерминированным, поэтому есть варианты 
-- немного странная формулировка про последний заказ - последний заказ был не позднее апреля 2016 - т.е., если последний не позднее, то
-- и все остальные заказы ещё раньше . Непонятно только, апрель включать или нет. Поэтому до мая смотрю.

SELECT TOP (10)
	I.CustomerID
	,MAX([CustomerName])
	--,COUNT([InvoiceID]) AS [COunt]
FROM [Sales].[Invoices] AS I
JOIN [Sales].[Customers] AS C ON C.CustomerID = I.CustomerID
WHERE YEAR(I.InvoiceDate) <= '2016' AND MONTH(I.InvoiceDate) < 5
GROUP BY I.CustomerID
HAVING COUNT([InvoiceID]) > 30
ORDER BY I.CustomerID, COUNT([InvoiceID]) --[COunt]



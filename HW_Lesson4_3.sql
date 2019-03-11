/*
Задание 3

Выберите всех клиентов у которых было 5 максимальных оплат из [Sales].[CustomerTransactions] представьте 3 способа (в том числе с CTE)

*/

-- 1 способ. Конечно, чтобы получить детерминированный запрос, нужно использовать WITH TIES, иначе негарантировано...

SELECT [CustomerName]
FROM [Sales].[Customers]
WHERE [CustomerID] IN (
		SELECT TOP (5) WITH TIES
			  [CustomerID]
		  FROM [WideWorldImporters].[Sales].[CustomerTransactions]
		  ORDER BY [TransactionAmount] Desc
		  )


-- 2 Способ с СТЕ.
;
WITH TOP5 (IDCustomers)
AS
(
SELECT TOP (5) WITH TIES
			  [CustomerID]
		  FROM [WideWorldImporters].[Sales].[CustomerTransactions]
		  ORDER BY [TransactionAmount] Desc
)
SELECT [CustomerName] 
FROM [Sales].[Customers]
WHERE [CustomerID] in ( SELECT IDCustomers FROM TOP5 )


-- 3 Способ





/*
������� 3

�������� ���� �������� � ������� ���� 5 ������������ ����� �� [Sales].[CustomerTransactions] ����������� 3 ������� (� ��� ����� � CTE)

*/

-- 1 ������. �������, ����� �������� ����������������� ������, ����� ������������ WITH TIES, ����� ���������������...

SELECT [CustomerName]
FROM [Sales].[Customers]
WHERE [CustomerID] IN (
		SELECT TOP (5) WITH TIES
			  [CustomerID]
		  FROM [WideWorldImporters].[Sales].[CustomerTransactions]
		  ORDER BY [TransactionAmount] Desc
		  )


-- 2 ������ � ���.
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


-- 3 ������





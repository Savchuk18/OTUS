/*
2. Для всех клиентов с именем, в котором есть Tailspin Toys
вывести все адреса, которые есть в таблице, в одной колонке

Пример результатов
CustomerName	AddressLine
Tailspin Toys (Head Office)	Shop 38
Tailspin Toys (Head Office)	1877 Mittal Road
Tailspin Toys (Head Office)	PO Box 8975
Tailspin Toys (Head Office)	Ribeiroville
*/


SELECT C1.CustomerName,CCC.DeliveryAddressLine1
FROM [Sales].[Customers] AS C1
CROSS APPLY (SELECT [DeliveryAddressLine1] FROM [Sales].[Customers] AS C2 WHERE C2.CustomerID = C1.CustomerID
			UNION ALL
			SELECT [DeliveryAddressLine2] FROM [Sales].[Customers] AS C3 WHERE C3.CustomerID = C1.CustomerID
			) AS CCC
WHERE [CustomerName] Like '%Tailspin Toys%'
--ORDER BY C1.CustomerName

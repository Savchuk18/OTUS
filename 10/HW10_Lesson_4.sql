
/*
Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла. 
*/

SELECT  SC.CustomerName
		,F.OrderID
		,F.Summ
FROM [Sales].[Customers] AS SC
CROSS APPLY 
	[dbo].[funcOrdersCustBegEnd] (SC.CustomerName, --SUBSTRING(SC.CustomerName,1,6)
	'20130101', '20130201') AS F
WHERE F.Summ > 10000




/*

5. Пишем динамический PIVOT. 
По заданию из 8го занятия про CROSS APPLY и PIVOT 
Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
Название клиента
МесяцГод Количество покупок

Нужно написать запрос, который будет генерировать результаты для всех клиентов 
имя клиента указывать полностью из CustomerName
дата должна иметь формат dd.mm.yyyy например 25.12.2019

Из 8-го задания:

1. Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
Название клиента
МесяцГод Количество покупок
Клиентов взять с ID 2-6, это все подразделение Tailspin Toys
имя клиента нужно поменять так чтобы осталось только уточнение 
например исходное Tailspin Toys (Gasport, NY) - вы выводите в имени только Gasport,NY
дата должна иметь формат dd.mm.yyyy например 25.12.2019

Например, как должны выглядеть результаты:
InvoiceMonth	Peeples Valley, AZ	Medicine Lodge, KS	Gasport, NY	Sylvanite, MT	Jessie, ND
01.01.2013	3	1	4	2	2
01.02.2013	7	3	4	2	1


*/


DECLARE @AllNamesClient varchar(max);

SET @AllNamesClient=(SELECT STRING_AGG( CAST(QUOTENAME(C.CustomerName) as varchar(max)),', ')
FROM [Sales].[Customers] AS C
WHERE EXISTS (SELECT CustomerID FROM [Sales].[Orders] AS SO WHERE SO.CustomerID = C.CustomerID) -- отбросим клиентов без продаж. 
)																								-- Можно бы ещё проверять CustomerName на NULL, мало ли...
SET  @AllNamesClient = '(' + @AllNamesClient + ')';

-- SELECT @AllNamesClient -- просто посмотреть

/* Это на тот случай, если нет STRING_AGG, и вообще показалось, что со STRING_AGG ней медленнее
SELECT @AllNamesClient = @AllNamesClient  + QUOTENAME(C.CustomerName) + ','	
FROM [Sales].[Customers] AS C
WHERE EXISTS (SELECT CustomerID FROM [Sales].[Orders] AS SO WHERE SO.CustomerID = C.CustomerID)
SELECT @AllNamesClient=SUBSTRING(@AllNamesClient,1, LEN(@AllNamesClient)-1) + ')';
--SELECT @AllNamesClient, LEN(@AllNamesClient); --просто посмотреть...
*/
DECLARE @SQLComm varchar(max)=''; -- здесь запишем  SQL команду

SET @SQLComm = '
;WITH ForPivot ([Cliname],[МесяцГод],[OrderID])
AS
(
	SELECT 
		C.CustomerName
		,FORMAT(EOMONTH(O.OrderDate),''dd.MM.yyyy'')
		,O.OrderID
	FROM [Sales].[Orders] AS O
	JOIN [Sales].[Customers] AS C ON C.CustomerID = O.[CustomerID]
)
SELECT *
FROM ForPivot
	PIVOT (Count(OrderID)
	FOR Cliname IN ' + @AllNamesClient + '
	) AS P'

--PRINT @SQLComm
EXEC (@SQLComm)


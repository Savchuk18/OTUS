-- Переделаный запрос
/*
Основная идея для переделки - сначала выбрать все СФ, которые имеют общую сумму не меньше 27000, 
чтобы уже из этого получить номера СФ, и не перебирать их все, 
и уйти, таким образом, от самой трудоёмкой операции  - просмотра всех СФ.
Перестроил запрос, но, к сожалению, ощутимого выигрыша не получил - почему-то остался index scan по Invoice, 
хотя, должен работать JOIN, и, ожидался SEEK по
Sales.Invoices и фильтр по уже найденым записям. 
Перестраивал индекс ALTER INDEX, но не помогло.
*/
;
WITH TOTAL27000 (ID, TOTALSUMM)					--Выберем в CTE все InvoiceLines, у которых сумма не меньше 27000
AS
(
	SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000
)
SELECT 
	SI.InvoiceID, 
	SI.InvoiceDate,
	P.FullName	 AS SalesPersonName,
	SalesTotals.TotalSumm AS TotalSummByInvoice
	,OLS.TotalSummForPickedItems
FROM TOTAL27000 AS SalesTotals 
JOIN Sales.Invoices AS SI
	ON SI.InvoiceID = SalesTotals.ID 
JOIN Application.People AS P ON P.PersonID = SI.SalespersonPersonID
JOIN Sales.Orders AS SO ON SO.OrderID = SI.OrderID
JOIN (SELECT OrderLines.OrderId AS OID
			,SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice) AS TotalSummForPickedItems
	  FROM Sales.OrderLines 
	  GROUP BY OrderLines.OrderId 
	) AS OLS ON OLS.OID = SO.OrderID
	WHERE SO.PickingCompletedWhen IS NOT NULL
	ORDER BY TotalSumm DESC
	

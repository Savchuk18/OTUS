SELECT 
	Invoices.InvoiceID, 
	Invoices.InvoiceDate,
	(SELECT People.FullName
		FROM Application.People
		WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
	SalesTotals.TotalSumm AS TotalSummByInvoice, 
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		FROM Sales.OrderLines
		WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
						FROM Sales.Orders
						WHERE Orders.PickingCompletedWhen IS NOT NULL	
						AND Orders.OrderId = Invoices.OrderId)	
	) AS TotalSummForPickedItems
FROM Sales.Invoices 
JOIN
(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000
	) AS SalesTotals
	ON Invoices.InvoiceID = SalesTotals.InvoiceID
	ORDER BY TotalSumm DESC

/*
Объяснение запроса
Из таблицы счетов-фактур (СФ) (Sales.Invoices) выбираются СФ с суммой по СФ более 27000 (JOIN), в порядке убывания общей суммы:
	номер СФ - InvoiceID 
	дата СФ InvoiceDate
	Полное имя "продажника" по данной СФ
	Общая сумма по СФ
	Общая сумма по заказу, на основании которого создана СФ, в том случае, если указана дата завершения формирования заказа
*/
/*
Рассуждения по производительности))
Странное условия с житейской точки зрения 
Orders.PickingCompletedWhen IS NOT NULL 
для указания суммы заказа, потому что если дата готовности заказа указана, то общая сумма заказа вроде как должна совпасть с суммой СФ,
хотя назначение поля до конца неизвестно, может, это и не так. Надо знать назначение этого поля. На производительность большого влияния не оказывает.

По производительности - около 90% занимает проход по СФ, это самая трудозатратная операция, через неё поиск в таблице InvoiceLines
для того, чтобы вычислить сумму по СФ и затем отбросить все СФ с суммой меньше 27000.
Для читабельности можно вынести это в CTE, но на производдительности сказаться не должно.
Поскольку основной SELECT получил уже нужные, отфильтрованные по JOIN InvoiceID, то и поиск полного имени из People.FullName 
и суммы по заказу (Sales.OrderLines) по InvoiceID не оказывает существенного влияния на производительность. Опять для читабельности можно 
переделать выборку фамилии в отдельный JOIN, но после JOIN по поиску суммы СФ.

*/

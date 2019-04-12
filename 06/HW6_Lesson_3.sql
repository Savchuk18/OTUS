/*
3. Функции одним запросом
Посчитайте по таблице товаров, в вывод также должен попасть ид товара, название, брэнд и цена
пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
посчитайте общее количество товаров и выведете полем в этом же запросе
посчитайте общее количество товаров в зависимости от первой буквы названия товара
отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
предыдущий ид товара с тем же порядком отображения (по имени)
названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
сформируйте 30 групп товаров по полю вес товара на 1 шт
Для этой задачи НЕ нужно писать аналог без аналитических функций
*/

DECLARE @Patt varchar(128) = N'%[A-Z,0-9]%' -- Для выделения буквоцифры из наименования, чтобы не по  " или ' нумеровать
SELECT 
	[StockItemID]
	,[StockItemName]
	,[UnitPrice]
	,S.SupplierName
	,[Brand]
	,[TypicalWeightPerUnit]
	,ROW_NUMBER() OVER(PARTITION BY SUBSTRING(SI.StockItemName,PATINDEX(@Patt,SI.StockItemName),1) ORDER BY SI.StockItemName) AS [По 1-ой букве]
	,COUNT(*) OVER() AS [Всего товаров]
	,COUNT(*) OVER(PARTITION BY SUBSTRING(SI.StockItemName,PATINDEX(@Patt,SI.StockItemName),1) ) AS [Товаров по 1-ой букве]
	,LEAD(StockItemID) OVER(ORDER BY [StockItemName]) AS [Следующий id (по полному названию)]
	,LAG(StockItemID) OVER(ORDER BY [StockItemName]) AS [предыдущий id (по полному названию)]
	,LAG([StockItemName],2,'No items') OVER(ORDER BY [StockItemName]) AS [предыдущее название (по полному названию)]
	,NTILE(30) OVER(ORDER BY [TypicalWeightPerUnit]) AS [Масса за единицу]
FROM [Warehouse].[StockItems] AS SI
JOIN [Purchasing].[Suppliers] AS S ON S.SupplierID = SI.SupplierID


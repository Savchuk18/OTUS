/*
3. В таблице StockItems в колонке CustomFields есть данные в json.
Написать select для вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- Range (из CustomFields)

*/
SELECT 
	StockItemID ,
	StockItemName, 
	--CustomFields,
	JSON_VALUE(CustomFields,'$.CountryOfManufacture') AS [Страна]
	,JSON_VALUE(CustomFields,'$.Range') AS [Примечание]
FROM [Warehouse].[StockItems] 
--WHERE ISJSON(CustomFields)=1 --  В [Warehouse].[StockItems]  остались данные от предыдущегго упражнения, это фильтр...)


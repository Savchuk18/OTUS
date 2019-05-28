/*
4. Найти в StockItems строки, где есть тэг "Vintage"
Запрос написать через функции работы с JSON.
Тэги искать в поле CustomFields, а не в Tags.
*/


SELECT 
	SI.*
FROM [Warehouse].[StockItems] As SI
	CROSS APPLY
		OPENJSON(SI.CustomFields)
			WITH(
				CountryOfManufacture nvarchar(100),
				Tags nvarchar(max)  as json
			) AS Cust
			outer apply openjson(Cust.Tags)
						WITH( Tag nvarchar(15) '$')
WHERE tag Like N'%Vintage%'


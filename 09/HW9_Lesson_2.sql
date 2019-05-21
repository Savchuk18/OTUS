SELECT 
	[StockItemName] AS [@Name]
	,[SupplierID]
	,[UnitPackageID] AS "Package/UnitPackageID" --
	,[OuterPackageID]  AS "Package/OuterPackageID" --
	,[QuantityPerOuter]  AS "Package/QuantityPerOuter" --
	,[TypicalWeightPerUnit]  AS "Package/TypicalWeightPerUnit" --
	,[LeadTimeDays]
	,[IsChillerStock]
	,[TaxRate]
	,[UnitPrice]
FROM [Warehouse].[StockItems] 
FOR XML PATH('Item'), ROOT('StockItems'),ELEMENTS--, TYPE 


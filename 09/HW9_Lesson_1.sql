/*

1. Загрузить данные из файла StockItems.xml в таблицу StockItems.
Существующие записи в таблице обновить, отсутствующие добавить (искать по StockItemName).

*/



-- DROP TABLE #XMLStockItems
CREATE TABLE #XMLStockItems( --В эту таблицу импортируем данные, чтобы  посмотреть, что импортируем...
	[Name] [nvarchar](100) COLLATE Latin1_General_100_CI_AS NOT NULL ,
	[SupplierID] [int] NOT NULL,
	[UnitPackageID] [int] NOT NULL,
	[OuterPackageID] [int] NOT NULL,
	[LeadTimeDays] [int] NOT NULL,
	[QuantityPerOuter] [int] NOT NULL,
	[IsChillerStock] [bit] NOT NULL,
	[TaxRate] [decimal](18, 3) NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[TypicalWeightPerUnit] [decimal](18, 3) NOT NULL,
)
GO

-----------------------------------------
-- Собственно процесс импорта...

DECLARE @docHandle int;
DECLARE @xmlDoc xml;

SET @xmlDoc = (
SELECT * 
FROM OPENROWSET (
BULK 'C:\Savchuk\StockItems.xml', SINGLE_BLOB
) as D
);

EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDoc;

INSERT INTO #XMLStockItems
SELECT * 
FROM OPENXML (@docHandle, N'/StockItems/Item/Package',3)
WITH ([Name] varchar(300) '../@Name'
	,SupplierID int '../SupplierID'
	,UnitPackageID int
	,OuterPackageID int
	,QuantityPerOuter int
	,TypicalWeightPerUnit decimal(8,3)
	,LeadTimeDays int '../LeadTimeDays'
	,IsChillerStock int '../IsChillerStock'
	,TaxRate decimal(8,3) '../TaxRate'
	,UnitPrice decimal(12,6) '../UnitPrice'
	)
;
--SELECT * FROM #XMLStockItems; -- чего там выбрали?

EXEC sp_xml_removedocument @docHandle;

-- Надо добавить и изменить. давно не было MERGE. Хотя ч-з INSERT и UPDATE должно быть быстрее...

MERGE [Warehouse].[StockItems] AS target
	USING #XMLStockItems AS source
	ON (target.StockItemName = source.[Name])
		WHEN MATCHED THEN
			UPDATE SET
				SupplierID = source.SupplierID,
				UnitPackageID = source.UnitPackageID,
				OuterPackageID = source.OuterPackageID,
				QuantityPerOuter = source.QuantityPerOuter,
				TypicalWeightPerUnit = source.TypicalWeightPerUnit,
				LeadTimeDays = source.LeadTimeDays,
				IsChillerStock = source.IsChillerStock,
				TaxRate = source.TaxRate,
				UnitPrice = source.UnitPrice
		WHEN NOT MATCHED THEN
		INSERT(
				StockItemName,
				SupplierID,
				UnitPackageID ,
				OuterPackageID,
				QuantityPerOuter ,
				TypicalWeightPerUnit ,
				LeadTimeDays ,
				IsChillerStock ,
				TaxRate ,
				UnitPrice 
				,LastEditedBy -- не может быть null, добавил

		)
		VALUES
		(
				 source.[Name],
				source.SupplierID,
				source.UnitPackageID,
				source.OuterPackageID,
				source.QuantityPerOuter,
				source.TypicalWeightPerUnit,
				source.LeadTimeDays,
				source.IsChillerStock,
				source.TaxRate,
				source.UnitPrice
				,1 -- только это значение в исходной таблице
		);


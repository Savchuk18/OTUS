DECLARE @clid int = 401, @Summ Decimal(22,2)
EXEC [dbo].[procSummCustomerPurchase] 401, @Summ OUTPUT
SELECT @Summ

SELECT [dbo].[CustomerIDHiPurchase]()

EXEC [dbo].[pOrdersCustBegEnd] N'Jon', '20130101', '20130201'
	WITH RESULT SETS 
	((
		[Клиент] varchar(100),
		[Дата ордера] date,
		[Номер ордера] int NOT NULl
	))

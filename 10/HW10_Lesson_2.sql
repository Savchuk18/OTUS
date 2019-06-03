USE [WideWorldImporters]
GO
/****** Object:  StoredProcedure [dbo].[procSummCustomerPurchase]    Script Date: 23.05.2019 11:04:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alex
-- Create date: 2019/05/23
-- Description:	Сумма продаж клиента
-- =============================================
ALTER PROCEDURE [dbo].[procSummCustomerPurchase]
	
	@CustomerID int = 0,
	@SummPurchase decimal(22,2) OUTPUT
	
AS
-- Пример вызова
-- DECLARE @clid int = 401, @Summ Decimal(22,2)
-- EXEC [dbo].[procSummCustomerPurchase] @clid, @Summ OUTPUT 
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS (SELECT 1 FROM [Sales].[Customers] WHERE [CustomerID] = @CustomerID)
		BEGIN
			RAISERROR(N'Код клиента не задан или неправильный!',16,1)
			RETURN
		END

	SET @SummPurchase = (
							SELECT
								SUM(IL.[Quantity] * IL.UnitPrice)
							FROM [Sales].[Invoices] AS I
							JOIN [Sales].[InvoiceLines] AS IL ON IL.InvoiceID = I.InvoiceID
							WHERE I.CustomerID = @CustomerID
							GROUP BY I.CustomerID
						);
	--PRINT @SummPurchase;
END

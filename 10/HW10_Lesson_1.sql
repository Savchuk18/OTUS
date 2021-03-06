USE [WideWorldImporters]
GO
/****** Object:  UserDefinedFunction [dbo].[CustomerIDHiPurchase]    Script Date: 23.05.2019 8:11:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alex
-- Create date: 2019/05/22
-- Description:	функция возвращает id Клиента с наибольшей суммой покупки
-- =============================================
ALTER FUNCTION [dbo].[CustomerIDHiPurchase]
(
)
RETURNS int
AS
-- SELECT [dbo].[CustomerIDHiPurchase]() -- Пример вызова
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar int;

	SET @ResultVar = (
						SELECT [CustomerID]
							FROM [Sales].[Invoices] AS I
							JOIN 
								(SELECT TOP 1 
										IL.InvoiceID
										,SUM([Quantity] * [UnitPrice]) AS SSUM
									FROM [Sales].[InvoiceLines] AS IL
									GROUP BY IL.InvoiceID
									ORDER BY SSUM DESC
								) AS CP
							ON I.InvoiceID = CP.InvoiceID
						);
	

	RETURN @ResultVar;

END

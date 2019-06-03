/*
3. Cоздать одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему
*/

/*
Ниже процедура и функция.
По SET STATISTICS TIME ON получается, что функция работает быстрее, чем процедура. Думаю, это связано с тем, что процедура компилируется один раз 
и если при выполнении параметры близки к тем, с которыми процедура компилируется, то время выполнения близко к оптимальному, в противном случае расхождение.


*/

-- Процедура
USE [WideWorldImporters]
GO
/****** Object:  StoredProcedure [dbo].[pOrdersCustBegEnd]    Script Date: 29.05.2019 15:01:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alex
-- Create date: 2019/05/29
-- Description:	Выборка ордеров покупателя по части имени в диапазоне дат
-- =============================================
ALTER PROCEDURE [dbo].[pOrdersCustBegEnd]

	@InNamePart varchar(100) = Null, 
	@InDBegin date = Null,
	@InDEnd date = Null
AS
BEGIN
	SET NOCOUNT ON;


	SELECT 
		C.CustomerName
		,O.OrderDate
		,O.OrderID
		,IT.SUMM
	FROM [Sales].[Customers] AS C
	JOIN [Sales].[Orders] AS O ON O.CustomerID = C.CustomerID
	JOIN (SELECT SUM([UnitPrice] * [Quantity]) AS SUMM
			,OL.OrderID
		FROM [Sales].[OrderLines] AS OL 
		GROUP BY OL.OrderID
	) AS IT ON IT.OrderID = O.OrderID
	WHERE CustomerName Like N'%' +  @InNamePart + N'%'
		AND O.OrderDate >= @InDBegin
		AND O.OrderDate <= @InDEnd
END


-- Функция

USE [WideWorldImporters]
GO
/****** Object:  UserDefinedFunction [dbo].[funcOrdersCustBegEnd]    Script Date: 03.06.2019 16:46:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alex
-- Create date: 2019/06/03
-- Description:	
-- =============================================
ALTER FUNCTION  [dbo].[funcOrdersCustBegEnd]
(
	@InNamePart Nvarchar(100) = Null, 
	@InDBegin date = Null,
	@InDEnd date = Null
)
RETURNS 
@OrdersCustBegEnd TABLE 
(
	CustomerName nvarchar(100)
	,OrderID	int
	,OrderDate	date
	,Summ		decimal(22,2)
)
AS
BEGIN
	
	IF  (@InNamePart IS NULL) OR	(@InDBegin IS NULL ) OR (@InDEnd IS NULL  )
		BEGIN
			-- 	RAISERROR 
			RETURN
		END

	INSERT  @OrdersCustBegEnd
				(
				CustomerName 
				,OrderID
				,OrderDate	
				,Summ		
				)
	SELECT 
		C.CustomerName
		,O.OrderID
		,O.OrderDate
		,IT.SUMM
	FROM [Sales].[Customers] AS C
	JOIN [Sales].[Orders] AS O ON O.CustomerID = C.CustomerID
	JOIN (SELECT SUM([UnitPrice] * [Quantity]) AS SUMM
			,OL.OrderID
		FROM [Sales].[OrderLines] AS OL 
		GROUP BY OL.OrderID
	) AS IT ON IT.OrderID = O.OrderID
	WHERE CustomerName Like N'%' +  @InNamePart + N'%'
		AND O.OrderDate >= @InDBegin
		AND O.OrderDate <= @InDEnd
	
	RETURN 
END

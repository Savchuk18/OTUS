/*
������� 2
*/
 -- ��������� ��������
 SELECT [StockItemID],[StockItemName], [UnitPrice] FROM [Warehouse].[StockItems] WHERE [UnitPrice] = (SELECT MIN([UnitPrice]) FROM [Warehouse].[StockItems])
 -- ������ ������ : 
 /*
 StockItemID	StockItemName	UnitPrice
188	3 kg Courier post bag (White) 300x190x95mm	0.66
 */
 
SELECT [StockItemID],[StockItemName], [UnitPrice] FROM [Warehouse].[StockItems] WHERE [UnitPrice] = (SELECT TOP (1) WITH TIES [UnitPrice] FROM [Warehouse].[StockItems] ORDER BY [UnitPrice] )
 
--  JOIN � CTE

 ;
 WITH minprice (Price)
 AS
 (
 SELECT MIN([UnitPrice]) FROM [Warehouse].[StockItems]
 )
 SELECT 
 [StockItemID],[StockItemName], [UnitPrice]
 FROM [Warehouse].[StockItems] AS S 
 JOIN minprice AS  MP ON MP.Price=S.UnitPrice
 
 -- ��������� ���������� �������� ��������.
 
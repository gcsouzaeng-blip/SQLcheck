USE lin2world
go
CREATE PROCEDURE [dbo].[lin_LoadPrivateStore]

AS
SELECT 0
GO

ALTER PROCEDURE dbo.lin_LoadPrivateStore
(        
	@char_id AS INT,
	@store_type AS INT,
	@x_loc AS INT,
	@y_loc AS INT,
	@z_loc AS INT,
	@is_offline AS INT,
	@item1_id AS INT,
	@item1_count AS INT,
	@item1_price AS INT,
	@item1_enchant AS INT,
	@item2_id AS INT,
	@item2_count AS INT,
	@item2_price AS INT,
	@item2_enchant AS INT,
	@item3_id AS INT,
	@item3_count AS INT,
	@item3_price AS INT,
	@item3_enchant AS INT,
	@item4_id AS INT,
	@item4_count AS INT,
	@item4_price AS INT,
	@item4_enchant AS INT,
	@item5_id AS INT,
	@item5_count AS INT,
	@item5_price AS INT,
	@item5_enchant AS INT,
	@item6_id AS INT,
	@item6_count AS INT,
	@item6_price AS INT,
	@item6_enchant AS INT,
	@item7_id AS INT,
	@item7_count AS INT,
	@item7_price AS INT,
	@item7_enchant AS INT,
	@item8_id AS INT,
	@item8_count AS INT,
	@item8_price AS INT,
	@item8_enchant AS INT
)        
AS    
SET NOCOUNT ON        

SELECT char_id, store_type, x_loc, y_loc, z_loc, is_offline, 
	item1_id, item1_count, item1_price, item1_enchant,
	item2_id, item2_count, item2_price, item2_enchant,
	item3_id, item3_count, item3_price, item3_enchant,
	item4_id, item4_count, item4_price, item4_enchant,
	item5_id, item5_count, item5_price, item5_enchant,
	item6_id, item6_count, item6_price, item6_enchant,
	item7_id, item7_count, item7_price, item7_enchant,
	item8_id, item8_count, item8_price, item8_enchant FROM PrivateStore WHERE char_id = @char_id
GO
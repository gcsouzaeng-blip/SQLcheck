USE [lin2world]
GO
/****** Object:  StoredProcedure [dbo].[lin_LoadE]    Script Date: 06/10/2022 20:32:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[lin_LoadE]
AS
SET NOCOUNT ON

DECLARE @charId as int
DECLARE @itemType as int
DECLARE @charName as NVARCHAR(32)
DECLARE @enchant as int

CREATE TABLE #topenchants (char_id int, item_type int, char_name NVARCHAR(32), enchant INT)

DECLARE topenchantCur CURSOR FOR
SELECT DISTINCT [enchant] FROM [dbo].[user_item] where enchant > 0 AND item_type > 0
OPEN topenchantCur
FETCH NEXT FROM topenchantCur INTO @enchant
WHILE (@@FETCH_STATUS <> -1)
BEGIN
SELECT @charId = [char_id] FROM [dbo].[user_item] WHERE [enchant] = @enchant
SELECT @itemType = [item_type] FROM [dbo].[user_item] WHERE [enchant] = @enchant
SELECT @charName = [char_name] FROM [dbo].[user_data] WHERE [char_id] = @charId
INSERT INTO #topenchants SELECT @charId, @itemType, @charName, @enchant
FETCH NEXT FROM topenchantCur INTO @enchant
END
CLOSE topenchantCur
DEALLOCATE topenchantCur

SELECT TOP(10) char_id, item_type, char_name, enchant FROM #topenchants order by enchant desc


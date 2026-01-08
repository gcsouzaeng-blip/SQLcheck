USE [lin2world]
GO
/****** Object:  StoredProcedure [dbo].[lin_LoadE]    Script Date: 03/15/2024 13:17:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[lin_LoadE]
AS
BEGIN
    SET NOCOUNT ON;

    CREATE TABLE #topenchants (
        char_id INT,
        item_type INT,
        char_name NVARCHAR(50),
        enchant INT
    );

    -- Seleciona os 10 melhores registros em ordem decrescente
    INSERT INTO #topenchants
    SELECT TOP 10
        ui.char_id,
        ui.item_type,
        ud.char_name,
        ui.enchant
    FROM [dbo].[user_item] ui
    JOIN [dbo].[user_data] ud ON ui.char_id = ud.char_id
    WHERE
        ui.enchant > 0
        AND ui.item_type > 0
        AND ui.item_type NOT IN (4442, 4422, 4443, 44, 54, 16, 4425, 6649, 6648, 6650, 2375, 4423, 3500, 4424, 3501, 3502)
    ORDER BY ui.enchant DESC;

    -- Retorna os resultados
    SELECT
        char_id,
        item_type,
        char_name,
        enchant
    FROM #topenchants;
END;

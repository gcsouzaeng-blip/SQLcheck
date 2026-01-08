USE [lin2world];
GO

-- Remove versão antiga (se existir) para evitar ambiguidade
IF OBJECT_ID('dbo.lin_LoadE', 'P') IS NOT NULL
    DROP PROCEDURE dbo.lin_LoadE;
GO

/***************************************************************
  lin_LoadE - versão unificada
  - @TopLimit INT = quantos registros retornar (default 200)
  - @UseTemp  BIT = 1 -> usa comportamento antigo que insere em #topenchants e depois SELECT
                 = 0 -> usa SELECT direto (mais simples)
  Observação: esta procedure foi montada combinando a versão original
  (que usava #topenchants) e a versão parametrizável. Referências:
  original com temp table e TOP 10; e versão parametrizável enviada.
***************************************************************/
CREATE PROCEDURE dbo.lin_LoadE
    @TopLimit INT = 200,
    @UseTemp  BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    /*
      Lista de item_type excluídos (mantida igual aos originais)
    */
    DECLARE @ExcludedItems TABLE (it INT);
    INSERT INTO @ExcludedItems (it) VALUES
    (4442),(4422),(4443),(44),(54),(16),(4425),
    (6649),(6648),(6650),(2375),(4423),(3500),
    (4424),(3501),(3502);

    IF(@UseTemp = 1)
    BEGIN
        /*
            Comportamento antigo: insere em #topenchants e então retorna.
            Útil se scripts dependem exatamente desse fluxo.
        */
        IF OBJECT_ID('tempdb..#topenchants') IS NOT NULL
            DROP TABLE #topenchants;

        CREATE TABLE #topenchants (
            char_id INT,
            item_type INT,
            char_name NVARCHAR(50),
            enchant INT
        );

        INSERT INTO #topenchants (char_id, item_type, char_name, enchant)
        SELECT TOP (@TopLimit)
            ui.char_id,
            ui.item_type,
            ud.char_name,
            ui.enchant
        FROM dbo.user_item AS ui
        INNER JOIN dbo.user_data AS ud ON ui.char_id = ud.char_id
        WHERE
            ui.enchant > 0
            AND ui.item_type > 0
            AND NOT EXISTS (SELECT 1 FROM @ExcludedItems e WHERE e.it = ui.item_type)
        ORDER BY ui.enchant DESC, ud.char_name ASC;

        SELECT
            char_id,
            item_type,
            char_name,
            enchant
        FROM #topenchants;
    END
    ELSE
    BEGIN
        /*
            Versão direta / parametrizável: SELECT TOP (@TopLimit) com ORDER BY
        */
        SELECT TOP (@TopLimit)
            ui.char_id,
            ui.item_type,
            ud.char_name,
            ui.enchant
        FROM dbo.user_item AS ui
        INNER JOIN dbo.user_data AS ud ON ui.char_id = ud.char_id
        WHERE
            ui.enchant > 0
            AND ui.item_type > 0
            AND NOT EXISTS (SELECT 1 FROM @ExcludedItems e WHERE e.it = ui.item_type)
        ORDER BY ui.enchant DESC, ud.char_name ASC;
    END
END;
GO

-- Exemplos de uso:
-- 1) Versão direta, top 200 (default)
EXEC dbo.lin_LoadE;

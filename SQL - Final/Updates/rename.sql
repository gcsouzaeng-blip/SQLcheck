USE [lin2world]
GO

/****** Object:  Table [dbo].[tmp_user_data]    Script Date: 24/02/2024 15:38:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].temp_var_name(
    [id] int IDENTITY(1,1) NOT NULL,
	[char_name] nvarchar(50) NOT NULL,
	[logData] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  StoredProcedure [dbo].[lin_SetTempName]    Script Date: 24/02/2024 16:54:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[lin_SetTempName] 
    @var_char_id INT, 
    @var_name NVARCHAR(50),
	@var_CahngerName NVARCHAR(50)
AS
BEGIN
    -- Inserir dados na tabela temp_name se char_name não existir
    IF NOT EXISTS (SELECT 1 FROM temp_var_name WHERE char_name = @var_CahngerName)
    BEGIN
        INSERT INTO temp_var_name (char_name, logData)
        VALUES (@var_CahngerName, GETDATE());
    END

    -- Atualizar dados na tabela user_data
    UPDATE user_data
    SET char_name = @var_name
    WHERE char_id = @var_char_id;
END;


/****** Object:  StoredProcedure [dbo].[lin_GetUserName]    Script Date: 23/02/2024 22:43:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[lin_GetUserName]
(
	@char_id as INT
)
AS

SET NOCOUNT ON;
SELECT [char_name] FROM [user_data] WHERE [char_id] = @char_id

/****** Object:  StoredProcedure [dbo].[lin_CleanTable]    Script Date: 24/02/2024 22:10:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[lin_CleanTable]
AS
BEGIN
    IF EXISTS (SELECT 1 FROM temp_var_name)
    BEGIN
        DELETE FROM temp_var_name;
        DBCC CHECKIDENT ('temp_var_name', RESEED, 0);
    END
END;

/****** Object:  StoredProcedure [dbo].[lin_CleanTable]    Script Date: 24/02/2024 22:10:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[lin_CheckName]
(
@var_name NVARCHAR(25)
)
AS

SET NOCOUNT ON

declare @result  int
set @result = 1

-- check user_prohibit 
if exists(select char_name from user_prohibit (nolock) where char_name = @var_name)
begin
	RAISERROR ('Name is prohibited: name = [%s]', 16, 1, @var_name)
	set @result = -1
end

-- prohibit word
declare @user_prohibit_word nvarchar(20)
select top 1 @user_prohibit_word = words from user_prohibit_word (nolock) where PATINDEX('%' + words + '%', @var_name) > 0 
if @user_prohibit_word is not null
begin
	RAISERROR ('Name has prohibited word: name = [%s], word[%s]', 16, 1, @var_name, @user_prohibit_word)
	set @result = -2
end

-- check duplicated name
declare @dup_ch_name nvarchar(25)
select top 1 @dup_ch_name = char_name from user_data (nolock) where char_name = @var_name
if not @dup_ch_name is null
begin
	RAISERROR ('duplicated name[%s]', 16, 1, @var_name)
	set @result = -3
end

declare @dup_tmp_name nvarchar(25)
select top 1 @dup_tmp_name = char_name from temp_var_name (nolock) where char_name = @var_name
if not @dup_tmp_name is null
begin
	RAISERROR ('duplicated temp name[%s]', 16, 1, @var_name)
	set @result = -4
end

select @result

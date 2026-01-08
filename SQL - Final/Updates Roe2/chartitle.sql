USE [lin2world]
GO
/****** Object:  StoredProcedure [dbo].[lin_CreateChar]    Script Date: 02/10/2022 11:03:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[lin_CreateChar]
(  
@char_name NVARCHAR(24),  
@account_name NVARCHAR(24),  
@account_id INT,  
@pledge_id INT,  
@builder  TINYINT,  
@gender TINYINT,  
@race  TINYINT,  
@class  TINYINT,  
@world  SMALLINT,  
@xloc  INT,  
@yloc  INT,  
@zloc  INT,  
@HP  FLOAT,  
@MP  FLOAT,  
@SP  INT,  
@Exp  INT,  
@Lev  TINYINT,  
@align  SMALLINT,  
@PK  INT,  
@Duel  INT,  
@PKPardon  INT,  
@FaceIndex   INT = 0,  
@HairShapeIndex  INT = 0,  
@HairColorIndex  INT = 0,
@nickname NVARCHAR(32) = "L2 BestPvP"
)  
AS  
  
SET NOCOUNT ON  
  
SET @char_name = RTRIM(@char_name)  
DECLARE @char_id int  
SET @char_id = 0  
  

IF @char_name LIKE N' '   
BEGIN  
 RAISERROR ('Character name has space : name = [%s]', 16, 1, @char_name)  
 RETURN -1  
END  
  
-- check user_prohibit   
if exists(select char_name from user_prohibit (nolock) where char_name = @char_name)  
begin  
 RAISERROR ('Character name is prohibited: name = [%s]', 16, 1, @char_name)  
 RETURN -1   
end  
  
declare @user_prohibit_word nvarchar(20)  
select top 1 @user_prohibit_word = words from user_prohibit_word (nolock) where @char_name like '%' + words + '%'
if @user_prohibit_word is not null  
begin  
 RAISERROR ('Character name has prohibited word: name = [%s], word[%s]', 16, 1, @char_name, @user_prohibit_word)  
 RETURN -1   
end  
  
-- check reserved name  
declare @reserved_name nvarchar(50)  
declare @reserved_account_id int  
select top 1 @reserved_name = char_name, @reserved_account_id = account_id from user_name_reserved (nolock) where used = 0 and char_name = @char_name  
if not @reserved_name is null  
begin  
 if not @reserved_account_id = @account_id  
 begin  
  RAISERROR ('Character name is reserved by other player: name = [%s]', 16, 1, @char_name)  
  RETURN -1  
 end  
end  
  
IF @race>5
BEGIN  
 RAISERROR ('Race overflow : = [%s]', 16, 1, @char_name)  
 RETURN -1  
END  

IF @race=0 and @class!=0 and @class!=10
BEGIN  
 RAISERROR ('Class Overflow for Human: = [%s]', 16, 1, @class)  
 RETURN -1  
END  

IF @race=1 and @class!=18 and @class!=25
BEGIN  
 RAISERROR ('Class Overflow for Elf: = [%s]', 16, 1, @class)  
 RETURN -1  
END  

IF @race=2 and @class!=31 and @class!=38
BEGIN  
 RAISERROR ('Class Overflow for DE: = [%s]', 16, 1, @class)  
 RETURN -1  
END  

IF @race=3 and @class!=44 and @class!=49
BEGIN  
 RAISERROR ('Class Overflow for Orc: = [%s]', 16, 1, @class)  
 RETURN -1  
END  

IF @race=4 and @class!=53
BEGIN  
 RAISERROR ('Class Overflow for Dwarf: = [%s]', 16, 1, @class)  
 RETURN -1  
END  

IF @race=5 and @class!=123 and @class!=124
 BEGIN
 RAISERROR ('Class Overflow for Kamael: = [%s]', 16, 1, @class)
 RETURN -1
END

-- insert user_data  
INSERT INTO user_data   
( char_name, account_name, account_id, pledge_id, builder, gender, race, class, subjob0_class, 
world, xloc, yloc, zloc, HP, MP, max_hp, max_mp, SP, Exp, Lev, align, PK, PKpardon, duel, create_date, face_index, hair_shape_index, hair_color_index, nickname)  
VALUES  
(@char_name, @account_name, @account_id, @pledge_id, @builder, @gender, @race, @class, @class, 
@world, @xloc, @yloc, @zloc, @HP, @MP, @HP, @MP, @SP, @Exp, @Lev, @align, @PK, @Duel, @PKPardon, GETDATE(), @FaceIndex, @HairShapeIndex, @HairColorIndex, @nickname)  
  
IF (@@error = 0)  
BEGIN  
 SET @char_id = @@IDENTITY  
 INSERT INTO quest (char_id) VALUES (@char_id)  
END  
  
SELECT @char_id  
  
if @char_id > 0  
begin  
 -- make user_history  
 exec lin_InsertUserHistory @char_name, @char_id, 1, @account_name, NULL  
 if not @reserved_name is null  
  update user_name_reserved set used = 1 where char_name = @reserved_name  
end

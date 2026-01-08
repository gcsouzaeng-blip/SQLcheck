USE [lin2world]
GO

/****** Object:  Table [dbo].[war_declare]    Script Date: 10/15/2021 23:11:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[alliance_war](
	[war_id] int NOT NULL,
	[challengee] [int] NOT NULL,
	[challenger] [int] NOT NULL,
	[begin_time] [int] NOT NULL,
	[status] [int] NOT NULL,)
GO



USE [lin2world]
go

GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[pledge_war](
    [war_id] int NOT NULL,
	[challenger] [int] NOT NULL,
	[challengee] [int] NOT NULL,
	[begin_time] [int] NOT NULL,
	[status] [int] NOT NULL
	,)
GO

/****** Object:  StoredProcedure [dbo].[lin_LoadAllAllianceWarData]    Script Date: 10/15/2021 23:24:54 ******/
DROP PROCEDURE [lin_LoadAllAllianceWarData]
go

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[lin_LoadAllAllianceWarData]
(
	@status	int
)
AS
SET NOCOUNT ON

SELECT 
	war_id, begin_time, challenger, challengee 
FROM 
	alliance_war (nolock)  
WHERE 
	status = @status

GO

DROP PROCEDURE [lin_LoadAllWarData]
go
/****** Object:  StoredProcedure [dbo].[lin_LoadAllWarData]    Script Date: 10/15/2021 23:26:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[lin_LoadAllWarData]
(
	@status	int
)
AS
SET NOCOUNT ON

SELECT 
	war_id, begin_time, challenger, challengee 
FROM 
	pledge_war (nolock)  
WHERE 
	status = @status

GO



USE [lin2db]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[hauthd_log](
		[time] [datetime] NOT NULL,
		[account] [varchar](14) NOT NULL,
		[ip] [varchar](15) NOT NULL,
		[hkey] [varchar](16)
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF 
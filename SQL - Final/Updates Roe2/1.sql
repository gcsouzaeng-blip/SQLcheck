ALTER TABLE [dbo].[user_data] ADD
	[daily_pvp] [int] NOT NULL,
	[daily_pvp_timestamp] [int] NOT NULL

ALTER TABLE [dbo].[user_data] ADD  DEFAULT ((0)) FOR [daily_pvp]
GO

ALTER TABLE [dbo].[user_data] ADD  DEFAULT ((0)) FOR [daily_pvp_timestamp]
GO


CREATE TABLE [dbo].[DailyPvP](
	[char_id] [int] NOT NULL,
	[hardware_id] [int] NOT NULL,
	[timestamp] [int] NOT NULL
) ON [PRIMARY]
GO

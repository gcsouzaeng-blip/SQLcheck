USE [lin2world]
GO

DROP TABLE Auction
GO

/****** Object:  Table [dbo].[Auction]    Script Date: 17/11/2022 20:44:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Auction](
	[auction_id] [int] IDENTITY(1,1) NOT NULL,
	[seller_id] [int] NOT NULL DEFAULT ((0)),
	[seller_name] [nvarchar](25) NOT NULL DEFAULT (N''),
	[item_id] [int] NOT NULL DEFAULT ((0)),
	[amount] [int] NOT NULL DEFAULT ((0)),
	[enchant] [int] NOT NULL DEFAULT ((0)),
	[augmentation] [int] NOT NULL DEFAULT ((0)),
	[priceid] [int] NOT NULL DEFAULT ((0)),
	[price] [int] NOT NULL DEFAULT ((0)),
	[expire_time] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]

GO


DROP TABLE AuctionPayment
GO

/****** Object:  Table [dbo].[AuctionPayment]    Script Date: 17/11/2022 20:44:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AuctionPayment](
	[job_id] [int] IDENTITY(1,1) NOT NULL,
	[char_id] [int] NOT NULL,
	[price_id] [int] NOT NULL,
	[price_amount] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[item_amount] [int] NOT NULL,
	[buyer] [nvarchar](25) NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AuctionPayment] ADD  DEFAULT ((0)) FOR [char_id]
GO

ALTER TABLE [dbo].[AuctionPayment] ADD  DEFAULT ((0)) FOR [price_id]
GO

ALTER TABLE [dbo].[AuctionPayment] ADD  DEFAULT ((0)) FOR [price_amount]
GO

ALTER TABLE [dbo].[AuctionPayment] ADD  DEFAULT ((0)) FOR [item_id]
GO

ALTER TABLE [dbo].[AuctionPayment] ADD  DEFAULT ((0)) FOR [item_amount]
GO

ALTER TABLE [dbo].[AuctionPayment] ADD  DEFAULT (N'') FOR [buyer]
GO

/****** Object:  StoredProcedure [dbo].[lin_AuctionAddPaymentJob]    Script Date: 17/11/2022 20:45:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[lin_AuctionAddPaymentJob]
(
	@charId as INT,
	@priceId as INT,
	@priceAmount as INT,
	@itemId as INT,
	@itemAmount as INT,
	@buyer as nvarchar(25)
)
AS
SET NOCOUNT on;
BEGIN
	INSERT INTO [AuctionPayment] ([char_id], [price_id], [price_amount], [item_id], [item_amount], [buyer]) VALUES (@charId, @priceId, @priceAmount, @itemId, @itemAmount, @buyer)
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[lin_AuctionCreate]
(
	@sellerId as INT,
	@sellerName as nvarchar(25),
	@itemId as INT,
	@amount as INT,
	@enchant as INT,
	@augmentation as INT,
	@price as INT,
	@priceID as INT,
	@expireTime as INT
)
AS

SET NOCOUNT ON;
DECLARE @auctionId int  
SET @auctionId = 0
INSERT INTO [Auction] ( seller_id, seller_name, item_id, amount, enchant, augmentation, priceID,  price,expire_time ) VALUES (@sellerId, @sellerName, @itemId, @amount, @enchant, @augmentation, @price, @priceID, @expireTime)
IF (@@error = 0)  
BEGIN  
	SET @auctionId = @@IDENTITY
END  
  
SELECT @auctionId 


/****** Object:  StoredProcedure [dbo].[lin_AuctionLoadItems]    Script Date: 17/11/2022 20:46:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[lin_AuctionLoadItems]
AS

SET NOCOUNT ON;
SELECT [auction_id], [seller_id], [seller_name], [item_id], [amount], [enchant], [augmentation], [priceid], [price], [expire_time]  FROM [Auction]


/****** Object:  StoredProcedure [dbo].[lin_AuctionModdifyAmount]    Script Date: 17/11/2022 20:46:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[lin_AuctionModdifyAmount]
(
	@auctionId as INT,
	@amount as INT
)
AS

SET NOCOUNT ON;
UPDATE [Auction] SET [amount] = @amount WHERE [auction_id] = @auctionId


/****** Object:  StoredProcedure [dbo].[lin_AuctionPaymentAsk]    Script Date: 17/11/2022 20:46:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[lin_AuctionPaymentAsk]
(
	@charId as INT
)
AS

SET NOCOUNT ON;
BEGIN
	SELECT * FROM [AuctionPayment] WHERE [char_id] = @charId
END


/****** Object:  StoredProcedure [dbo].[lin_AuctionPaymentDone]    Script Date: 17/11/2022 20:46:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[lin_AuctionPaymentDone]
(
	@charId as INT,
	@jobId as INT
)
AS

SET NOCOUNT ON;

BEGIN
	DELETE FROM [AuctionPayment] WHERE [char_id] = @charId AND [job_id] = @jobId
END


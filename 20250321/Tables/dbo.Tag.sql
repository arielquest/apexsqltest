SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Tag] (
		[TagID]              [int] IDENTITY(1, 1) NOT NULL,
		[TagNumber]          [int] NOT NULL,
		[TagMeaning]         [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TagDescription]     [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TagLong]            [int] NULL,
		CONSTRAINT [PK_Tag]
		PRIMARY KEY
		CLUSTERED
		([TagID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Tag] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Table_202407031] (
		[Id]        [int] IDENTITY(1, 1) NOT NULL,
		[Col1]      [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Col2]      [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Col3]      [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Col4]      [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Col5]      [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Col6]      [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Col7]      [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Col8]      [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Col9]      [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Col10]     [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [PK__Table_20__3214EC0775A3EC7F]
		PRIMARY KEY
		CLUSTERED
		([Id])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Table_202407031] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Sigma].[DSIGMA_CARGA] (
		[CARPETA]     [varchar](36) COLLATE Modern_Spanish_CI_AS NULL,
		[NUE]         [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[CODDEJ]      [varchar](5) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Sigma].[DSIGMA_CARGA] SET (LOCK_ESCALATION = TABLE)
GO
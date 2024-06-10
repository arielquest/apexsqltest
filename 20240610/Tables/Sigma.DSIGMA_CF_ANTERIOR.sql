SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Sigma].[DSIGMA_CF_ANTERIOR] (
		[CARPETA]      [varchar](36) COLLATE Modern_Spanish_CI_AS NULL,
		[NUE]          [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[CODDEJ]       [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[CODASU]       [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[CODCLAS]      [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		[CODJURIS]     [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
		[CODTIDEJ]     [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
		[FECHA]        [date] NULL,
		[FINEST]       [varchar](1) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Sigma].[DSIGMA_CF_ANTERIOR] SET (LOCK_ESCALATION = TABLE)
GO

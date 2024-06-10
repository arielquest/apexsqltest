SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Sigma].[DSIGMA] (
		[IDFEP]                   [bigint] NULL,
		[CARPETA]                 [varchar](36) COLLATE Modern_Spanish_CI_AS NULL,
		[NUE]                     [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[CODDEJ]                  [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[CODASU]                  [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		[CODCLAS]                 [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		[CODJURIS]                [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
		[CODTIDEJ]                [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
		[FECHA]                   [datetime2](7) NULL,
		[FINEST]                  [varchar](1) COLLATE Modern_Spanish_CI_AS NULL,
		[CODESTASU_TER]           [int] NULL,
		[CODESTASU_ACT]           [int] NULL,
		[FEINNUE]                 [datetime2](7) NULL,
		[FECENT]                  [datetime2](7) NULL,
		[FECTER]                  [datetime2](7) NULL,
		[FECREENT]                [datetime2](7) NULL,
		[BALANCE_CF]              [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
		[BALANCE_CI]              [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
		[CODJUTRA]                [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[CODJUDEC]                [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[CODSUBEST]               [varchar](11) COLLATE Modern_Spanish_CI_AS NULL,
		[CODFAS]                  [smallint] NULL,
		[CODESTASU_ACT_FECHA]     [datetime2](7) NULL
) ON [PRIMARY]
GO
ALTER TABLE [Sigma].[DSIGMA] SET (LOCK_ESCALATION = TABLE)
GO

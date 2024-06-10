SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Sigma].[DSIGMA_LISTADO] (
		[Carpeta]                 [varchar](36) COLLATE Modern_Spanish_CI_AS NULL,
		[Nue]                     [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[CodDej]                  [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[CodAsu]                  [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		[CodClas]                 [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		[CodJuris]                [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
		[CodtiDej]                [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
		[FeIniNue]                [datetime2](7) NULL,
		[FecEnt]                  [datetime2](7) NULL,
		[FecTer]                  [datetime2](7) NULL,
		[Motivo_TER]              [int] NULL,
		[Estado_ACT]              [int] NULL,
		[FecReent]                [datetime2](7) NULL,
		[Balance_CF]              [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
		[Balance_CI]              [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
		[CodJuTra]                [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[CodJuDec]                [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[CodSubEst]               [varchar](11) COLLATE Modern_Spanish_CI_AS NULL,
		[CodFas]                  [varchar](6) COLLATE Modern_Spanish_CI_AS NULL,
		[CodEstasu_Act_Fecha]     [datetime2](7) NULL
) ON [PRIMARY]
GO
ALTER TABLE [Sigma].[DSIGMA_LISTADO] SET (LOCK_ESCALATION = TABLE)
GO

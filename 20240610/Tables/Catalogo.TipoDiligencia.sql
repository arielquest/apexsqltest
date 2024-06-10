SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoDiligencia] (
		[TN_CodTipoDiligencia]     [smallint] NOT NULL,
		[TC_Descripcion]           [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]          [datetime2](7) NULL,
		[TDIT_TIPO]                [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_TipoDiligencia]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoDiligencia])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoDiligencia]
	ADD
	CONSTRAINT [DF_TipoDiligencia_TN_CodTipoDiligencia]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoDiligencia]) FOR [TN_CodTipoDiligencia]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de dictamen.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoDiligencia', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de diligencia.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoDiligencia', 'COLUMN', N'TN_CodTipoDiligencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de diligencia.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoDiligencia', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoDiligencia', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoDiligencia', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoDiligencia] SET (LOCK_ESCALATION = TABLE)
GO

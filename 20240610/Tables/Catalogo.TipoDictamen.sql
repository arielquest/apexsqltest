SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoDictamen] (
		[TN_CodTipoDictamen]     [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[TDT_TIPO]               [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_TipoDictamen]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoDictamen])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoDictamen]
	ADD
	CONSTRAINT [DF_TipoDictamen_TN_CodTipoDictamen]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoDictamen]) FOR [TN_CodTipoDictamen]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de dictamen.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoDictamen', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de dictamen.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoDictamen', 'COLUMN', N'TN_CodTipoDictamen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de dictamen.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoDictamen', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoDictamen', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoDictamen', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoDictamen] SET (LOCK_ESCALATION = TABLE)
GO

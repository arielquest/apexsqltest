SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoCuantia] (
		[TN_CodTipoCuantia]      [tinyint] NOT NULL,
		[TC_Descripcion]         [varchar](70) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODCUANTIA]             [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_TipoCuantia]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoCuantia])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoCuantia]
	ADD
	CONSTRAINT [DF_TipoCuantia_TN_CodTipoCuantia]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoCuantia]) FOR [TN_CodTipoCuantia]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de cuantia.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoCuantia', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de cuantia.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoCuantia', 'COLUMN', N'TN_CodTipoCuantia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de cuantia.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoCuantia', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoCuantia', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoCuantia', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoCuantia', 'COLUMN', N'CODCUANTIA'
GO
ALTER TABLE [Catalogo].[TipoCuantia] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoIntervencion] (
		[TN_CodTipoIntervencion]     [smallint] NOT NULL,
		[TC_Descripcion]             [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Intervencion]            [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]         [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]            [datetime2](7) NULL,
		[CODINT]                     [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_TipoIntervencion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoIntervencion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoIntervencion]
	ADD
	CONSTRAINT [CK_TipoIntervencion]
	CHECK
	([TC_Intervencion]='A' OR [TC_Intervencion]='P' OR [TC_Intervencion]='N')
GO
ALTER TABLE [Catalogo].[TipoIntervencion]
CHECK CONSTRAINT [CK_TipoIntervencion]
GO
ALTER TABLE [Catalogo].[TipoIntervencion]
	ADD
	CONSTRAINT [DF_TipoIntervencion_TC_CodTipoIntervencion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoIntervencion]) FOR [TN_CodTipoIntervencion]
GO
ALTER TABLE [Catalogo].[TipoIntervencion]
	ADD
	CONSTRAINT [DF_TipoIntervencion_TC_Intervencion]
	DEFAULT ('N') FOR [TC_Intervencion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de intervención.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIntervencion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de intervención.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIntervencion', 'COLUMN', N'TN_CodTipoIntervencion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de tipo de intervención.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIntervencion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la intervención es ''A'' (activa), ''P'' (pasiva) o ''N'' (neutra).', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIntervencion', 'COLUMN', N'TC_Intervencion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIntervencion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIntervencion', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIntervencion', 'COLUMN', N'CODINT'
GO
ALTER TABLE [Catalogo].[TipoIntervencion] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoAudiencia] (
		[TN_CodTipoAudiencia]     [smallint] NOT NULL,
		[TC_Descripcion]          [varchar](120) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]      [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]         [datetime2](3) NULL,
		[CODTIPDOC]               [varchar](12) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Catalogo_TipoAudiencia]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoAudiencia])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoAudiencia]
	ADD
	CONSTRAINT [DF_Catalogo_TipoAudiencia_TN_CodTipoAudiencia]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoAudiencia]) FOR [TN_CodTipoAudiencia]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipo: "TipoAudiencia"', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudiencia', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudiencia', 'COLUMN', N'TN_CodTipoAudiencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudiencia', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudiencia', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudiencia', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudiencia', 'COLUMN', N'CODTIPDOC'
GO
ALTER TABLE [Catalogo].[TipoAudiencia] SET (LOCK_ESCALATION = TABLE)
GO

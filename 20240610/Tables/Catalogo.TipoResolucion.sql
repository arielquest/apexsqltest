SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoResolucion] (
		[TN_CodTipoResolucion]     [smallint] NOT NULL,
		[TC_Descripcion]           [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]          [datetime2](7) NULL,
		[TB_EnvioSCIJ]             [bit] NOT NULL,
		[CODRES]                   [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_TipoResolucion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoResolucion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoResolucion]
	ADD
	CONSTRAINT [DF_TipoResolucion_TN_CodTipoResolucion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoResolucion]) FOR [TN_CodTipoResolucion]
GO
ALTER TABLE [Catalogo].[TipoResolucion]
	ADD
	CONSTRAINT [DF_TipoResolucion_TB_EnvioSCIJ]
	DEFAULT ((0)) FOR [TB_EnvioSCIJ]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de resolución.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoResolucion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de resolución.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoResolucion', 'COLUMN', N'TN_CodTipoResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de resolución.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoResolucion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoResolucion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoResolucion', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador para enviar al SCIJ.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoResolucion', 'COLUMN', N'TB_EnvioSCIJ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoResolucion', 'COLUMN', N'CODRES'
GO
ALTER TABLE [Catalogo].[TipoResolucion] SET (LOCK_ESCALATION = TABLE)
GO

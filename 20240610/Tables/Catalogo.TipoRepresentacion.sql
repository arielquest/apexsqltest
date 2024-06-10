SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoRepresentacion] (
		[TN_CodTipoRepresentacion]     [smallint] NOT NULL,
		[TC_Descripcion]               [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]           [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]              [datetime2](7) NULL,
		[CODREP]                       [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_TipoRepresentacion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoRepresentacion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoRepresentacion]
	ADD
	CONSTRAINT [DF_TipoRepresentacion_TN_CodTipoRepresentacion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoRepresentante]) FOR [TN_CodTipoRepresentacion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de representación.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoRepresentacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de representación.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoRepresentacion', 'COLUMN', N'TN_CodTipoRepresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de representación.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoRepresentacion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoRepresentacion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoRepresentacion', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoRepresentacion', 'COLUMN', N'CODREP'
GO
ALTER TABLE [Catalogo].[TipoRepresentacion] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoCivil] (
		[TN_CodEstadoCivil]      [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODESCIV]               [varchar](1) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_EstadoCivil]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstadoCivil])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoCivil]
	ADD
	CONSTRAINT [DF_EstadoCivil_TN_CodEstadoCivil]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEstadoCivil]) FOR [TN_CodEstadoCivil]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de estado civil.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoCivil', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado civil.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoCivil', 'COLUMN', N'TN_CodEstadoCivil'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del estado civil.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoCivil', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoCivil', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoCivil', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoCivil', 'COLUMN', N'CODESCIV'
GO
ALTER TABLE [Catalogo].[EstadoCivil] SET (LOCK_ESCALATION = TABLE)
GO

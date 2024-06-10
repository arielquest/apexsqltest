SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[FormatoArchivo] (
		[TN_CodFormatoArchivo]     [int] NOT NULL,
		[TC_Descripcion]           [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Extensiones]           [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]          [datetime2](7) NULL,
		CONSTRAINT [PK_TipoDocumento]
		PRIMARY KEY
		CLUSTERED
		([TN_CodFormatoArchivo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[FormatoArchivo]
	ADD
	CONSTRAINT [DF_TipoArchivo_TC_CodTipoArchivo]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaFormatoArchivo]) FOR [TN_CodFormatoArchivo]
GO
ALTER TABLE [Catalogo].[FormatoArchivo]
	ADD
	CONSTRAINT [DF_TipoArchivo_TC_Extensiones]
	DEFAULT ('') FOR [TC_Extensiones]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de formatos de archivo.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoArchivo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del formato de archivo.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoArchivo', 'COLUMN', N'TN_CodFormatoArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del formato de archivo.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoArchivo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lista de extensiones validas para el formato de archivo.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoArchivo', 'COLUMN', N'TC_Extensiones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoArchivo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoArchivo', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[FormatoArchivo] SET (LOCK_ESCALATION = TABLE)
GO

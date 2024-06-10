SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Catalogo].[TipoOficinaFormatoArchivo] (
		[TN_CodTipoOficina]           [smallint] NOT NULL,
		[TN_CodFormatoArchivo]        [int] NOT NULL,
		[TN_LimiteSubida]             [bigint] NOT NULL,
		[TN_LimiteSubidaMasivo]       [bigint] NOT NULL,
		[TN_LimiteDescargaMasivo]     [bigint] NOT NULL,
		[TF_Inicio_Vigencia]          [datetime2](7) NOT NULL,
		CONSTRAINT [PK_LimiteDocumento_1]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoOficina], [TN_CodFormatoArchivo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoOficinaFormatoArchivo]
	WITH CHECK
	ADD CONSTRAINT [FK_LimiteDocumento_TipoOficina]
	FOREIGN KEY ([TN_CodTipoOficina]) REFERENCES [Catalogo].[TipoOficina] ([TN_CodTipoOficina])
ALTER TABLE [Catalogo].[TipoOficinaFormatoArchivo]
	CHECK CONSTRAINT [FK_LimiteDocumento_TipoOficina]

GO
ALTER TABLE [Catalogo].[TipoOficinaFormatoArchivo]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaFormatoArchivo_FormatoArchivo]
	FOREIGN KEY ([TN_CodFormatoArchivo]) REFERENCES [Catalogo].[FormatoArchivo] ([TN_CodFormatoArchivo])
ALTER TABLE [Catalogo].[TipoOficinaFormatoArchivo]
	CHECK CONSTRAINT [FK_TipoOficinaFormatoArchivo_FormatoArchivo]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia los tipos de oficina con sus formatos de archivo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaFormatoArchivo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaFormatoArchivo', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de formato de archivo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaFormatoArchivo', 'COLUMN', N'TN_CodFormatoArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tamaño límite de subida de un archivo en bytes.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaFormatoArchivo', 'COLUMN', N'TN_LimiteSubida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tamaño límite de subida de varios archivos en bytes.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaFormatoArchivo', 'COLUMN', N'TN_LimiteSubidaMasivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tamaño límite de descarga de varios archivos en bytes.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaFormatoArchivo', 'COLUMN', N'TN_LimiteDescargaMasivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaFormatoArchivo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoOficinaFormatoArchivo] SET (LOCK_ESCALATION = TABLE)
GO

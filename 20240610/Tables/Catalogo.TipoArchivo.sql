SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoArchivo] (
		[TN_CodTipoArchivo]      [int] NOT NULL,
		[TC_Descripcion]         [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodPrioridad]        [smallint] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_TipoArchivo]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoArchivo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoArchivo]
	ADD
	CONSTRAINT [DF_TipoArchivo_TN_CodTipoArchivo]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoArchivo]) FOR [TN_CodTipoArchivo]
GO
ALTER TABLE [Catalogo].[TipoArchivo]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoArchivo_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[TipoArchivo]
	CHECK CONSTRAINT [FK_TipoArchivo_Materia]

GO
ALTER TABLE [Catalogo].[TipoArchivo]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoArchivo_Prioridad]
	FOREIGN KEY ([TN_CodPrioridad]) REFERENCES [Catalogo].[Prioridad] ([TN_CodPrioridad])
ALTER TABLE [Catalogo].[TipoArchivo]
	CHECK CONSTRAINT [FK_TipoArchivo_Prioridad]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que engloba la característica propia del documento incorporado en el sistema, como escritos, documentos, audiencias orales, etc.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoArchivo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de archivo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoArchivo', 'COLUMN', N'TN_CodTipoArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de archivo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoArchivo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoArchivo', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la prioridad.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoArchivo', 'COLUMN', N'TN_CodPrioridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoArchivo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoArchivo', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoArchivo] SET (LOCK_ESCALATION = TABLE)
GO

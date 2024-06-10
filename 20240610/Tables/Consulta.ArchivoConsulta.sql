SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Consulta].[ArchivoConsulta] (
		[TU_CodArchivo]            [uniqueidentifier] NOT NULL,
		[TC_Estado]                [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_RutaArchivo]           [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaModificacion]     [datetime2](3) NOT NULL,
		CONSTRAINT [PK_ArchivoConsulta]
		PRIMARY KEY
		CLUSTERED
		([TU_CodArchivo])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Consulta].[ArchivoConsulta]
	ADD
	CONSTRAINT [CK_ArchivoConsulta]
	CHECK
	([TC_Estado]='P' OR [TC_Estado]='E' OR [TC_Estado]='F')
GO
EXEC sp_addextendedproperty N'MS_Description', N'El estado sólo puede tener 2 valores: P=Pendiente y E=Enviado.', 'SCHEMA', N'Consulta', 'TABLE', N'ArchivoConsulta', 'CONSTRAINT', N'CK_ArchivoConsulta'
GO
ALTER TABLE [Consulta].[ArchivoConsulta]
CHECK CONSTRAINT [CK_ArchivoConsulta]
GO
ALTER TABLE [Consulta].[ArchivoConsulta]
	ADD
	CONSTRAINT [DF__ArchivoCo__TF_Fe__3E5D3103]
	DEFAULT (getdate()) FOR [TF_FechaModificacion]
GO
ALTER TABLE [Consulta].[ArchivoConsulta]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoConsulta_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Consulta].[ArchivoConsulta]
	CHECK CONSTRAINT [FK_ArchivoConsulta_Archivo]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Relaciona la llave primaria del código de archivo con el código de la tabla Archivo', 'SCHEMA', N'Consulta', 'TABLE', N'ArchivoConsulta', 'CONSTRAINT', N'FK_ArchivoConsulta_Archivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del archivo que se publicará para el módulo de consultas.', 'SCHEMA', N'Consulta', 'TABLE', N'ArchivoConsulta', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado del archivo: P=Pendiente, E=Enviando, F=Finalizado.', 'SCHEMA', N'Consulta', 'TABLE', N'ArchivoConsulta', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene la ruta donde se almacenó el archivo para ser publicado.', 'SCHEMA', N'Consulta', 'TABLE', N'ArchivoConsulta', 'COLUMN', N'TC_RutaArchivo'
GO
ALTER TABLE [Consulta].[ArchivoConsulta] SET (LOCK_ESCALATION = TABLE)
GO

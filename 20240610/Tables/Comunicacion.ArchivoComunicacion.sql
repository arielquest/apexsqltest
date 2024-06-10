SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Comunicacion].[ArchivoComunicacion] (
		[TU_CodArchivoComunicacion]     [uniqueidentifier] NOT NULL,
		[TU_CodComunicacion]            [uniqueidentifier] NOT NULL,
		[TB_EsActa]                     [bit] NOT NULL,
		[TF_FechaAsociacion]            [datetime2](7) NOT NULL,
		[TU_CodArchivo]                 [uniqueidentifier] NULL,
		[TB_EsPrincipal]                [bit] NOT NULL,
		[TF_Particion]                  [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ArchivoComunicacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodArchivoComunicacion])
	ON [PRIMARY]
) ON [ComunicacionPS] ([TF_Particion])
GO
ALTER TABLE [Comunicacion].[ArchivoComunicacion]
	ADD
	CONSTRAINT [DF_ArchivoComunicacion_TB_EsActa]
	DEFAULT ((0)) FOR [TB_EsActa]
GO
ALTER TABLE [Comunicacion].[ArchivoComunicacion]
	ADD
	CONSTRAINT [DF_ArchivoComunicacion_TB_EsPrincipal]
	DEFAULT ((0)) FOR [TB_EsPrincipal]
GO
ALTER TABLE [Comunicacion].[ArchivoComunicacion]
	ADD
	CONSTRAINT [DF__ArchivoCo__TF_Pa__5D6D5EB6]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Comunicacion].[ArchivoComunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoComunicacion_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Comunicacion].[ArchivoComunicacion]
	CHECK CONSTRAINT [FK_ArchivoComunicacion_Archivo]

GO
CREATE CLUSTERED INDEX [IX_Comunicacion_ArchivoComunicacion_TF_Particion]
	ON [Comunicacion].[ArchivoComunicacion] ([TF_Particion])
	ON [ComunicacionPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_ARCHIVO_COMUNICACION_MIGRACION_PRINCIPAL]
	ON [Comunicacion].[ArchivoComunicacion] ([TU_CodArchivo], [TB_EsPrincipal])
	ON [ComunicacionPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_ArchivoComunicacion_CodArchivo]
	ON [Comunicacion].[ArchivoComunicacion] ([TU_CodArchivo])
	ON [ComunicacionPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_ArchivoComunicacion_ConsultarArchivosComunicacion]
	ON [Comunicacion].[ArchivoComunicacion] ([TU_CodComunicacion])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice creado para optimizar Comunicacion.PA_ConsultarArchivosComunicacion.', 'SCHEMA', N'Comunicacion', 'TABLE', N'ArchivoComunicacion', 'INDEX', N'IX_ArchivoComunicacion_ConsultarArchivosComunicacion'
GO
CREATE NONCLUSTERED INDEX [IX_Comunicacion_ArchivoComunicacion_Migracion]
	ON [Comunicacion].[ArchivoComunicacion] ([TU_CodComunicacion], [TB_EsActa], [TU_CodArchivo], [TB_EsPrincipal])
	ON [ComunicacionPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla liga las comunicaciones judiciales con archivos y documentos', 'SCHEMA', N'Comunicacion', 'TABLE', N'ArchivoComunicacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único del registro que genera la asociación de un archivo con la comunicación judicial', 'SCHEMA', N'Comunicacion', 'TABLE', N'ArchivoComunicacion', 'COLUMN', N'TU_CodArchivoComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador único del registro de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'ArchivoComunicacion', 'COLUMN', N'TU_CodComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el documento asociado es un acta de comunicación ', 'SCHEMA', N'Comunicacion', 'TABLE', N'ArchivoComunicacion', 'COLUMN', N'TB_EsActa'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se asocia el documento con la comunicación judicial', 'SCHEMA', N'Comunicacion', 'TABLE', N'ArchivoComunicacion', 'COLUMN', N'TF_FechaAsociacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único que identifica a un archivo del expediente', 'SCHEMA', N'Comunicacion', 'TABLE', N'ArchivoComunicacion', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica cual es el documento principal de una comunicación, solo un documento puede ser principal', 'SCHEMA', N'Comunicacion', 'TABLE', N'ArchivoComunicacion', 'COLUMN', N'TB_EsPrincipal'
GO
ALTER TABLE [Comunicacion].[ArchivoComunicacion] SET (LOCK_ESCALATION = TABLE)
GO

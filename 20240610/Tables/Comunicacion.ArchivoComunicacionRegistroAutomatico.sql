SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Comunicacion].[ArchivoComunicacionRegistroAutomatico] (
		[TU_CodArchivoComunicacionAut]     [uniqueidentifier] NOT NULL,
		[TU_CodComunicacionAut]            [uniqueidentifier] NOT NULL,
		[TU_CodArchivo]                    [uniqueidentifier] NULL,
		[TB_EsPrincipal]                   [bit] NOT NULL,
		[TF_Particion]                     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ArchivoComunicacionRegistroAutomatico]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodArchivoComunicacionAut], [TU_CodComunicacionAut])
	ON [PRIMARY]
) ON [FG_Comunicacion]
GO
ALTER TABLE [Comunicacion].[ArchivoComunicacionRegistroAutomatico]
	ADD
	CONSTRAINT [DF_ArchivoComunicacionRegistroAutomatico_TB_EsPrincipal]
	DEFAULT ((0)) FOR [TB_EsPrincipal]
GO
ALTER TABLE [Comunicacion].[ArchivoComunicacionRegistroAutomatico]
	ADD
	CONSTRAINT [DF_ArchivoComunicacionRegistroAutomatico_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Comunicacion].[ArchivoComunicacionRegistroAutomatico]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoComunicacionRegistroAutomatico_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Comunicacion].[ArchivoComunicacionRegistroAutomatico]
	CHECK CONSTRAINT [FK_ArchivoComunicacionRegistroAutomatico_Archivo]

GO
ALTER TABLE [Comunicacion].[ArchivoComunicacionRegistroAutomatico]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoComunicacionRegistroAutomatico_ComunicacionRegistroAutomatico]
	FOREIGN KEY ([TU_CodComunicacionAut]) REFERENCES [Comunicacion].[ComunicacionRegistroAutomatico] ([TU_CodComunicacionAut])
ALTER TABLE [Comunicacion].[ArchivoComunicacionRegistroAutomatico]
	CHECK CONSTRAINT [FK_ArchivoComunicacionRegistroAutomatico_ComunicacionRegistroAutomatico]

GO
CREATE CLUSTERED INDEX [IX_Comunicacion_ArchivoComunicacionRegistroAutomatico_TF_Particion]
	ON [Comunicacion].[ArchivoComunicacionRegistroAutomatico] ([TF_Particion])
	ON [FG_Comunicacion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla liga los preregistros de las comunicaciones judiciales con archivos y documentos', 'SCHEMA', N'Comunicacion', 'TABLE', N'ArchivoComunicacionRegistroAutomatico', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único del registro que genera la asociación de un archivo con el pre registro la comunicación judicial', 'SCHEMA', N'Comunicacion', 'TABLE', N'ArchivoComunicacionRegistroAutomatico', 'COLUMN', N'TU_CodArchivoComunicacionAut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador único del pre registro de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'ArchivoComunicacionRegistroAutomatico', 'COLUMN', N'TU_CodComunicacionAut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único que identifica a un archivo del expediente', 'SCHEMA', N'Comunicacion', 'TABLE', N'ArchivoComunicacionRegistroAutomatico', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica cual es el documento principal de una comunicación, solo un documento puede ser principal', 'SCHEMA', N'Comunicacion', 'TABLE', N'ArchivoComunicacionRegistroAutomatico', 'COLUMN', N'TB_EsPrincipal'
GO
ALTER TABLE [Comunicacion].[ArchivoComunicacionRegistroAutomatico] SET (LOCK_ESCALATION = TABLE)
GO

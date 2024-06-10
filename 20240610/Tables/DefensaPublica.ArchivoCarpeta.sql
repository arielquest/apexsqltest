SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [DefensaPublica].[ArchivoCarpeta] (
		[TU_CodArchivo]          [uniqueidentifier] NOT NULL,
		[TC_NRD]                 [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodGrupoTrabajo]     [smallint] NOT NULL,
		[TF_Particion]           [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ArchivoCarpeta]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodArchivo], [TC_NRD])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[ArchivoCarpeta]
	ADD
	CONSTRAINT [DF__ArchivoCarpetaParticion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[ArchivoCarpeta]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoCarpeta_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [DefensaPublica].[ArchivoCarpeta]
	CHECK CONSTRAINT [FK_ArchivoCarpeta_Archivo]

GO
ALTER TABLE [DefensaPublica].[ArchivoCarpeta]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoCarpeta_Carpeta]
	FOREIGN KEY ([TC_NRD]) REFERENCES [DefensaPublica].[Carpeta] ([TC_NRD])
ALTER TABLE [DefensaPublica].[ArchivoCarpeta]
	CHECK CONSTRAINT [FK_ArchivoCarpeta_Carpeta]

GO
ALTER TABLE [DefensaPublica].[ArchivoCarpeta]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoCarpeta_GrupoTrabajo]
	FOREIGN KEY ([TN_CodGrupoTrabajo]) REFERENCES [Catalogo].[GrupoTrabajo] ([TN_CodGrupoTrabajo])
ALTER TABLE [DefensaPublica].[ArchivoCarpeta]
	CHECK CONSTRAINT [FK_ArchivoCarpeta_GrupoTrabajo]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_ArchivoCarpeta_TF_Particion]
	ON [DefensaPublica].[ArchivoCarpeta] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de los archivos asociados a la carpeta.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ArchivoCarpeta', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del archivo.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ArchivoCarpeta', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de NRD al que pertenece el archivo.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ArchivoCarpeta', 'COLUMN', N'TC_NRD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del grupo de trabajo que tiene asignado el archivo.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ArchivoCarpeta', 'COLUMN', N'TN_CodGrupoTrabajo'
GO
ALTER TABLE [DefensaPublica].[ArchivoCarpeta] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ArchivoExpediente] (
		[TU_CodArchivo]           [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]     [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodGrupoTrabajo]      [smallint] NOT NULL,
		[TB_Notifica]             [bit] NOT NULL,
		[TB_Eliminado]            [bit] NOT NULL,
		[TN_Consecutivo]          [int] NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ArchivoExpediente]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodArchivo], [TC_NumeroExpediente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[ArchivoExpediente]
	ADD
	CONSTRAINT [DF__ArchivoEx__TB_No__4E4B16B7]
	DEFAULT ((0)) FOR [TB_Notifica]
GO
ALTER TABLE [Expediente].[ArchivoExpediente]
	ADD
	CONSTRAINT [DF__ArchivoEx__TB_El__4F3F3AF0]
	DEFAULT ((0)) FOR [TB_Eliminado]
GO
ALTER TABLE [Expediente].[ArchivoExpediente]
	ADD
	CONSTRAINT [DF__ArchivoEx__TF_Pa__67EAED29]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[ArchivoExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoExpediente_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Expediente].[ArchivoExpediente]
	CHECK CONSTRAINT [FK_ArchivoExpediente_Archivo]

GO
ALTER TABLE [Expediente].[ArchivoExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoExpediente_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[ArchivoExpediente]
	CHECK CONSTRAINT [FK_ArchivoExpediente_Expediente]

GO
ALTER TABLE [Expediente].[ArchivoExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoExpediente_GrupoTrabajo]
	FOREIGN KEY ([TN_CodGrupoTrabajo]) REFERENCES [Catalogo].[GrupoTrabajo] ([TN_CodGrupoTrabajo])
ALTER TABLE [Expediente].[ArchivoExpediente]
	CHECK CONSTRAINT [FK_ArchivoExpediente_GrupoTrabajo]

GO
CREATE CLUSTERED INDEX [IX_Expediente_ArchivoExpediente_TF_Particion]
	ON [Expediente].[ArchivoExpediente] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_Expediente_ArchivoExpediente_Include3]
	ON [Expediente].[ArchivoExpediente] ([TB_Eliminado])
	INCLUDE ([TU_CodArchivo], [TC_NumeroExpediente], [TN_CodGrupoTrabajo], [TN_Consecutivo])
	WITH ( FILLFACTOR = 100)
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_ArchivoExpediente_TC_NumeroExpediente]
	ON [Expediente].[ArchivoExpediente] ([TC_NumeroExpediente])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TB_Eliminado_Includes]
	ON [Expediente].[ArchivoExpediente] ([TB_Eliminado])
	INCLUDE ([TU_CodArchivo], [TC_NumeroExpediente], [TN_CodGrupoTrabajo], [TB_Notifica])
	WITH ( FILLFACTOR = 100)
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de los archivos asociados al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ArchivoExpediente', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del archivo.', 'SCHEMA', N'Expediente', 'TABLE', N'ArchivoExpediente', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del expediente al que pertenece el archivo.', 'SCHEMA', N'Expediente', 'TABLE', N'ArchivoExpediente', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del grupo de trabajo que tiene asignado el archivo.', 'SCHEMA', N'Expediente', 'TABLE', N'ArchivoExpediente', 'COLUMN', N'TN_CodGrupoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el archivo se puede notificar', 'SCHEMA', N'Expediente', 'TABLE', N'ArchivoExpediente', 'COLUMN', N'TB_Notifica'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el archivo fue eliminado lógicamente, por lo cual no se debe de mostrar en la aplicación.', 'SCHEMA', N'Expediente', 'TABLE', N'ArchivoExpediente', 'COLUMN', N'TB_Eliminado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Consecutivo asignado para el Historial Procesal', 'SCHEMA', N'Expediente', 'TABLE', N'ArchivoExpediente', 'COLUMN', N'TN_Consecutivo'
GO
ALTER TABLE [Expediente].[ArchivoExpediente] SET (LOCK_ESCALATION = TABLE)
GO

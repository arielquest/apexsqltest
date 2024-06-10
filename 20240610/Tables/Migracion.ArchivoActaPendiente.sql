SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Migracion].[ArchivoActaPendiente] (
		[TN_Idaco]                [int] NOT NULL,
		[TC_Carpeta]              [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroExpediente]     [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodArchivo]           [uniqueidentifier] NULL ROWGUIDCOL,
		[TB_MigradoDatos]         [bit] NOT NULL,
		CONSTRAINT [PK_Migracion_ArchivoActaPendiente]
		PRIMARY KEY
		CLUSTERED
		([TN_Idaco], [TC_Carpeta], [TC_NumeroExpediente], [TC_CodContexto])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Migracion].[ArchivoActaPendiente]
	ADD
	CONSTRAINT [DF__ArchivoAc__TB_Mi__3651FAE7]
	DEFAULT ((0)) FOR [TB_MigradoDatos]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del acontecimiento asociado a la notificación, en la base de datos origen', 'SCHEMA', N'Migracion', 'TABLE', N'ArchivoActaPendiente', 'COLUMN', N'TN_Idaco'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de carpeta donde se encuentra el documento, en la base de datos origen', 'SCHEMA', N'Migracion', 'TABLE', N'ArchivoActaPendiente', 'COLUMN', N'TC_Carpeta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente asociado al documento de acta', 'SCHEMA', N'Migracion', 'TABLE', N'ArchivoActaPendiente', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto que generó el acontecimiento asociado al acta en Gestión', 'SCHEMA', N'Migracion', 'TABLE', N'ArchivoActaPendiente', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el documento de acra, fue exitosamente asociado a un documento como parte del proceso de actualización de los datos de las actas.', 'SCHEMA', N'Migracion', 'TABLE', N'ArchivoActaPendiente', 'COLUMN', N'TB_MigradoDatos'
GO
ALTER TABLE [Migracion].[ArchivoActaPendiente] SET (LOCK_ESCALATION = TABLE)
GO

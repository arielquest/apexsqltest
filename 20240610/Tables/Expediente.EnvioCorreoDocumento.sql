SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[EnvioCorreoDocumento] (
		[TU_CodEnvioCorreo]     [uniqueidentifier] NOT NULL,
		[TU_CodArchivo]         [uniqueidentifier] NOT NULL,
		[TN_Tamanio]            [bigint] NULL,
		[TF_Particion]          [datetime2](7) NOT NULL,
		CONSTRAINT [PK_EnvioCorreoDocumento]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodEnvioCorreo], [TU_CodArchivo])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Expediente].[EnvioCorreoDocumento]
	ADD
	CONSTRAINT [DF_EnvioCorreoDocumento_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[EnvioCorreoDocumento]
	WITH CHECK
	ADD CONSTRAINT [FK_EnvioCorreoDocumento_EnvioCorreo]
	FOREIGN KEY ([TU_CodEnvioCorreo]) REFERENCES [Expediente].[EnvioCorreo] ([TU_CodEnvioCorreo])
ALTER TABLE [Expediente].[EnvioCorreoDocumento]
	CHECK CONSTRAINT [FK_EnvioCorreoDocumento_EnvioCorreo]

GO
CREATE CLUSTERED INDEX [IX_Expediente_EnvioCorreoDocumento_TF_Particion]
	ON [Expediente].[EnvioCorreoDocumento] ([TF_Particion])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estructura para almacenar los registros de los documentos asociados a los envíos de expedientes por correo electrónico.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreoDocumento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del envío de documentos de correo electrónico, del expediente o legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreoDocumento', 'COLUMN', N'TU_CodEnvioCorreo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del documento del expediente que se adjunta al correo.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreoDocumento', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tamaño del documento que se adjunta al correo.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreoDocumento', 'COLUMN', N'TN_Tamanio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Permite el particionamiento de la base de datos.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreoDocumento', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Expediente].[EnvioCorreoDocumento] SET (LOCK_ESCALATION = TABLE)
GO

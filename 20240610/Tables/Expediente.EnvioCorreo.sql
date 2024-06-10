SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[EnvioCorreo] (
		[TU_CodEnvioCorreo]                [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]              [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodLegajo]                     [uniqueidentifier] NULL,
		[TC_CorreoPara]                    [varchar](150) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CorreosCopia]                  [varchar](600) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Asunto]                        [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_IncluirDatosGenerales]         [bit] NOT NULL,
		[TB_IncluirIntervenciones]         [bit] NOT NULL,
		[TB_IncluirNotificaciones]         [bit] NOT NULL,
		[TB_IncluirDocumentosEscritos]     [bit] NOT NULL,
		[TC_Mensaje]                       [varchar](8000) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaEnvio]                    [datetime2](7) NULL,
		[TC_Estado]                        [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaRecepcion]                [datetime2](7) NULL,
		[TC_CodContexto]                   [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodPuestoTrabajo]              [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_UsuarioRed]                    [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_MensajeErrorEnvio]             [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_EnvioCorreo]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodEnvioCorreo])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Expediente].[EnvioCorreo]
	ADD
	CONSTRAINT [CK_EnvioCorreo_Estado]
	CHECK
	([TC_Estado]='B' OR [TC_Estado]='E' OR [TC_Estado]='D' OR [TC_Estado]='N' OR [TC_Estado]='X')
GO
ALTER TABLE [Expediente].[EnvioCorreo]
CHECK CONSTRAINT [CK_EnvioCorreo_Estado]
GO
ALTER TABLE [Expediente].[EnvioCorreo]
	ADD
	CONSTRAINT [DF_EnvioCorreo_TC_Estado]
	DEFAULT ('B') FOR [TC_Estado]
GO
ALTER TABLE [Expediente].[EnvioCorreo]
	ADD
	CONSTRAINT [DF_EnvioCorreo_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[EnvioCorreo]
	WITH CHECK
	ADD CONSTRAINT [FK_EnvioCorreo_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[EnvioCorreo]
	CHECK CONSTRAINT [FK_EnvioCorreo_Contexto]

GO
ALTER TABLE [Expediente].[EnvioCorreo]
	WITH CHECK
	ADD CONSTRAINT [FK_EnvioCorreo_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[EnvioCorreo]
	CHECK CONSTRAINT [FK_EnvioCorreo_Expediente]

GO
ALTER TABLE [Expediente].[EnvioCorreo]
	WITH CHECK
	ADD CONSTRAINT [FK_EnvioCorreo_Funcionario]
	FOREIGN KEY ([TC_UsuarioRed]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Expediente].[EnvioCorreo]
	CHECK CONSTRAINT [FK_EnvioCorreo_Funcionario]

GO
ALTER TABLE [Expediente].[EnvioCorreo]
	WITH CHECK
	ADD CONSTRAINT [FK_EnvioCorreo_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[EnvioCorreo]
	CHECK CONSTRAINT [FK_EnvioCorreo_Legajo]

GO
ALTER TABLE [Expediente].[EnvioCorreo]
	WITH CHECK
	ADD CONSTRAINT [FK_EnvioCorreo_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Expediente].[EnvioCorreo]
	CHECK CONSTRAINT [FK_EnvioCorreo_PuestoTrabajo]

GO
CREATE CLUSTERED INDEX [IX_Expediente_EnvioCorreo_TF_Particion]
	ON [Expediente].[EnvioCorreo] ([TF_Particion])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_EnvioCorreo]
	ON [Expediente].[EnvioCorreo] ([TC_NumeroExpediente], [TU_CodLegajo])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice para consultar los envíos de correos electrónicos de expedientes o legajos', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'INDEX', N'IX_Expediente_EnvioCorreo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estructura para almacenar los registros de envios de expedientes por correo electrónico.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del envío de documentos de correo electrónico, del expediente o legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TU_CodEnvioCorreo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de expediente único, al cual se asocia el envío de documentos por correo electrónico.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo, al cual se asocia el envío de documentos por correo electrónico.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Correo electrónico como destino principal del envío de documentos por correo, solo permite un correo.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TC_CorreoPara'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lista de correos electrónicos a los cuales se señala en la copia del envío de documentos por correo. Se indican separados por punto y coma.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TC_CorreosCopia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Asunto del correo electrónico.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TC_Asunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si como parte del contenido del correo electrónico se envía la información de los datos generales del expediente o legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TB_IncluirDatosGenerales'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si como parte del contenido del correo electrónico se envía la lista de intervenciones del expediente o legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TB_IncluirIntervenciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si como parte del contenido del correo electrónico se envía la lista de notificaciones del expediente o legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TB_IncluirNotificaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si como parte del contenido del correo electrónico se envía la lista de los documentos y escritos del expediente o legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TB_IncluirDocumentosEscritos'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mensaje a incluir en el contendio del correo electrónico.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TC_Mensaje'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se presionó el botón para realizar el envío de los documentos por correo electrónico.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TF_FechaEnvio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado del envío de correo electrónico. (B=Borrador, E=Enviado, D=Entregado, N=NoEntregado y X=ErrorEnvio)', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que el correo fue entregado exitosamente al destinatario principal (indicado en el campo TC_CorreoPara).', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TF_FechaRecepcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto desde el cuál se envía el correo electrónico.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo que envia el correo.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario de red del funcionario que envia el correo.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mensaje de erros devuelto en caso de error al enviar el correo.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TC_MensajeErrorEnvio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Permite el particionamiento de la base de datos.', 'SCHEMA', N'Expediente', 'TABLE', N'EnvioCorreo', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Expediente].[EnvioCorreo] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[SolicitudDefensor] (
		[TU_CodSolicitudDefensor]        [uniqueidentifier] NOT NULL,
		[TC_EstadoSolicitudDefensor]     [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_TipoSolicitudDefensor]       [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_UsuarioRedSolicita]          [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Observaciones]               [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_LugarDiligencia]             [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
		[TU_Evento]                      [uniqueidentifier] NULL,
		[TU_CodArchivo]                  [uniqueidentifier] NULL,
		[TF_FechaCreacion]               [datetime2](7) NOT NULL,
		[TF_FechaEnvio]                  [datetime2](7) NULL,
		[TF_Actualizacion]               [datetime2](7) NOT NULL,
		[TC_CodOficinaSolicita]          [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodOficinaDefensa]           [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_NumeroExpediente]            [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]                 [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodPuestoTrabajo]            [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_EstadoSolicitudDefensa]      [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                   [datetime2](7) NOT NULL,
		[IDACOSOL]                       [varbinary](20) NULL,
		[TF_Inicio_Vigencia]             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_SolicitudDefensor]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitudDefensor])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[SolicitudDefensor]
	ADD
	CONSTRAINT [CK_SolicitudDefensor_EstadoSolicitudDefensa]
	CHECK
	([TC_EstadoSolicitudDefensa]='P' OR [TC_EstadoSolicitudDefensa]='O')
GO
ALTER TABLE [Expediente].[SolicitudDefensor]
CHECK CONSTRAINT [CK_SolicitudDefensor_EstadoSolicitudDefensa]
GO
ALTER TABLE [Expediente].[SolicitudDefensor]
	ADD
	CONSTRAINT [CK_SolicitudDefensor_EstadoSolicitudDefensor]
	CHECK
	([TC_EstadoSolicitudDefensor]='R' OR [TC_EstadoSolicitudDefensor]='E')
GO
ALTER TABLE [Expediente].[SolicitudDefensor]
CHECK CONSTRAINT [CK_SolicitudDefensor_EstadoSolicitudDefensor]
GO
ALTER TABLE [Expediente].[SolicitudDefensor]
	ADD
	CONSTRAINT [CK_SolicitudDefensor_TipoSolicitudDefensor]
	CHECK
	([TC_TipoSolicitudDefensor]='C' OR [TC_TipoSolicitudDefensor]='D')
GO
ALTER TABLE [Expediente].[SolicitudDefensor]
CHECK CONSTRAINT [CK_SolicitudDefensor_TipoSolicitudDefensor]
GO
ALTER TABLE [Expediente].[SolicitudDefensor]
	ADD
	CONSTRAINT [DF_SolicitudDefensor_TB_EsSolicitudDiligencia]
	DEFAULT ((0)) FOR [TC_TipoSolicitudDefensor]
GO
ALTER TABLE [Expediente].[SolicitudDefensor]
	ADD
	CONSTRAINT [DF_SolicitudDefensor_TC_Observaciones]
	DEFAULT ('') FOR [TC_Observaciones]
GO
ALTER TABLE [Expediente].[SolicitudDefensor]
	ADD
	CONSTRAINT [DF__Solicitud__TF_Ac__766C7FFC]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[SolicitudDefensor]
	ADD
	CONSTRAINT [DF__Solicitud__TF_Pa__4689F95E]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[SolicitudDefensor]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudDefensor_ExpedienteAsignado]
	FOREIGN KEY ([TC_NumeroExpediente], [TC_CodContexto], [TC_CodPuestoTrabajo], [TF_Inicio_Vigencia]) REFERENCES [Historico].[ExpedienteAsignado] ([TC_NumeroExpediente], [TC_CodContexto], [TC_CodPuestoTrabajo], [TF_Inicio_Vigencia])
ALTER TABLE [Expediente].[SolicitudDefensor]
	CHECK CONSTRAINT [FK_SolicitudDefensor_ExpedienteAsignado]

GO
ALTER TABLE [Expediente].[SolicitudDefensor]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudDefensor_Funcionario]
	FOREIGN KEY ([TU_UsuarioRedSolicita]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Expediente].[SolicitudDefensor]
	CHECK CONSTRAINT [FK_SolicitudDefensor_Funcionario]

GO
ALTER TABLE [Expediente].[SolicitudDefensor]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudDefensor_OficinaDefensa]
	FOREIGN KEY ([TC_CodOficinaDefensa]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Expediente].[SolicitudDefensor]
	CHECK CONSTRAINT [FK_SolicitudDefensor_OficinaDefensa]

GO
ALTER TABLE [Expediente].[SolicitudDefensor]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudDefensor_OficinaSolicita]
	FOREIGN KEY ([TC_CodOficinaSolicita]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Expediente].[SolicitudDefensor]
	CHECK CONSTRAINT [FK_SolicitudDefensor_OficinaSolicita]

GO
ALTER TABLE [Expediente].[SolicitudDefensor]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudDefensorArchivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Expediente].[SolicitudDefensor]
	CHECK CONSTRAINT [FK_SolicitudDefensorArchivo]

GO
CREATE CLUSTERED INDEX [IX_Expediente_SolicitudDefensor_TF_Particion]
	ON [Expediente].[SolicitudDefensor] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_SolicitudDefensor_Migracion]
	ON [Expediente].[SolicitudDefensor] ([TC_NumeroExpediente], [TF_FechaCreacion], [TC_TipoSolicitudDefensor], [TC_CodOficinaDefensa], [TC_CodContexto])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de solicitudes de defensor realizadas a la Defensa Pública.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la solicitud de defensor.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TU_CodSolicitudDefensor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de la solicitud (R = Registrada, E = Enviada).', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TC_EstadoSolicitudDefensor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el tipo de solicitud de defensor (D = Diligencia, C = Caso).', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TC_TipoSolicitudDefensor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que crea el registro de la solicitud de defensor.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TU_UsuarioRedSolicita'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones adicionales de la solicitud.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lugar en que se realizará la diligencia.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TC_LugarDiligencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del evento relacionado a la declaración o diligencia.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TU_Evento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del archivo de solicitud de defensor público.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación del trámite.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TF_FechaCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha envía la solicitud a la Defensa Pública.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TF_FechaEnvio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la oficina que realiza la solicitud de defensor.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TC_CodOficinaSolicita'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la oficina de la defensa pública a la que se asigna la solicitud.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TC_CodOficinaDefensa'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente al que corresponde el asignado(a).', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto al que corresponde el asignado(a).', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo al que corresponde el asignado(a).', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de la solicitud en la defensa pública (P = Pendiente de procesar, O = Procesada).', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensor', 'COLUMN', N'TC_EstadoSolicitudDefensa'
GO
ALTER TABLE [Expediente].[SolicitudDefensor] SET (LOCK_ESCALATION = TABLE)
GO

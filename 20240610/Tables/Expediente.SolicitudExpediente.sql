SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[SolicitudExpediente] (
		[TU_CodSolicitudExpediente]      [uniqueidentifier] NOT NULL,
		[TN_CodEstadoItineracion]        [smallint] NOT NULL,
		[TF_FechaCreacion]               [datetime2](3) NOT NULL,
		[TF_FechaEnvio]                  [datetime2](3) NULL,
		[TF_FechaRecepcion]              [datetime2](3) NULL,
		[TC_CodContextoOrigen]           [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodOficinaDestino]           [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContextoDestino]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodMotivoItineracion]        [smallint] NOT NULL,
		[TC_Descripcion]                 [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodHistoricoItineracion]     [uniqueidentifier] NULL,
		[TN_CodTipoItineracion]          [smallint] NOT NULL,
		[TC_NumeroExpediente]            [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodClaseAsunto]              [int] NOT NULL,
		[TU_CodArchivo]                  [uniqueidentifier] NULL,
		[TU_CodResultadoSolicitud]       [uniqueidentifier] NULL,
		[TF_Particion]                   [datetime2](7) NOT NULL,
		[IDACOSOL]                       [int] NULL,
		[IDACO]                          [int] NULL,
		[TU_CodLegajo]                   [uniqueidentifier] NULL,
		CONSTRAINT [PK_Expediente_SolicitudExpediente]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitudExpediente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[SolicitudExpediente]
	ADD
	CONSTRAINT [DF__Solicitud__TF_Pa__42B9687A]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[SolicitudExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_SolicitudExpediente_TC_CodContextoDestino]
	FOREIGN KEY ([TC_CodContextoDestino]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[SolicitudExpediente]
	CHECK CONSTRAINT [FK_Expediente_SolicitudExpediente_TC_CodContextoDestino]

GO
ALTER TABLE [Expediente].[SolicitudExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_SolicitudExpediente_TC_CodContextoOrigen]
	FOREIGN KEY ([TC_CodContextoOrigen]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[SolicitudExpediente]
	CHECK CONSTRAINT [FK_Expediente_SolicitudExpediente_TC_CodContextoOrigen]

GO
ALTER TABLE [Expediente].[SolicitudExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_SolicitudExpediente_TN_CodClaseAsunto]
	FOREIGN KEY ([TN_CodClaseAsunto]) REFERENCES [Catalogo].[ClaseAsunto] ([TN_CodClaseAsunto])
ALTER TABLE [Expediente].[SolicitudExpediente]
	CHECK CONSTRAINT [FK_Expediente_SolicitudExpediente_TN_CodClaseAsunto]

GO
ALTER TABLE [Expediente].[SolicitudExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudExpediente_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[SolicitudExpediente]
	CHECK CONSTRAINT [FK_SolicitudExpediente_Legajo]

GO
CREATE CLUSTERED INDEX [IX_Expediente_SolicitudExpediente_TF_Particion]
	ON [Expediente].[SolicitudExpediente] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_SolicitudExpediente_ItineracionRecibir]
	ON [Expediente].[SolicitudExpediente] ([TC_CodContextoDestino])
	INCLUDE ([TU_CodSolicitudExpediente], [TF_FechaCreacion], [TF_FechaEnvio], [TC_CodContextoOrigen], [TN_CodMotivoItineracion], [TC_Descripcion], [TU_CodHistoricoItineracion], [TC_NumeroExpediente])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_SolicitudExpediente_Migracion]
	ON [Expediente].[SolicitudExpediente] ([TC_NumeroExpediente], [TF_FechaCreacion], [TC_CodContextoOrigen], [TC_CodContextoDestino])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_SolicitudExpedienteContexto]
	ON [Expediente].[SolicitudExpediente] ([TC_CodContextoOrigen])
	INCLUDE ([TU_CodSolicitudExpediente], [TN_CodEstadoItineracion], [TC_CodContextoDestino], [TC_NumeroExpediente])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Entidad para conservar las solicitudes asociados a un expediente', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la solicitud asociada al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TU_CodSolicitudExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del estado de itineracion de la solicitud asociada al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TN_CodEstadoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creacion de la solicitud.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TF_FechaCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de envió de la solicitud asociada al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TF_FechaEnvio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de recepción de la solicitud asociada al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TF_FechaRecepcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del contexto origen de donde se recibe la solicitud asociada al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TC_CodContextoOrigen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la oficina destino a donde se enviara la solicitud asociada al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TC_CodOficinaDestino'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la contexto destino a donde se enviara la solicitud asociada al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TC_CodContextoDestino'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de motivo de itineracion asignado a la solicitud asociada al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TN_CodMotivoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la solicitud asociada al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código relacionada a la itineración , una vez enviado la solicitud', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TU_CodHistoricoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de intervención asignada a la solicitud asociada al expediente', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TN_CodTipoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del expediente asociado a la solicitud', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clase de Asunto asociada a la solicitud asociada al expediente', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TN_CodClaseAsunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del archivo relacionado a la soliictud asociada al expediente', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del resultado de solucion asociado a la solucion del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'TU_CodResultadoSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Guarda el IDACO de la solicitud para identificar la respuesta del envío', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'IDACOSOL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Guarda el ID del Acontecimiento de la Solicitud', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudExpediente', 'COLUMN', N'IDACO'
GO
ALTER TABLE [Expediente].[SolicitudExpediente] SET (LOCK_ESCALATION = TABLE)
GO

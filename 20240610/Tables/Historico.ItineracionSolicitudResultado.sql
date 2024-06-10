SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[ItineracionSolicitudResultado] (
		[TU_CodItineracionSolicitud]     [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]            [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodSolicitud]                [uniqueidentifier] NULL,
		[TU_CodLegajo]                   [uniqueidentifier] NULL,
		[TU_CodResultadoSolicitud]       [uniqueidentifier] NULL,
		[TU_CodItineracionResultado]     [uniqueidentifier] NULL,
		[TF_Actualizacion]               [datetime2](7) NOT NULL,
		[TF_Particion]                   [datetime2](7) NOT NULL,
		[CARPETA]                        [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[IDACOSOL]                       [bigint] NULL,
		CONSTRAINT [PK_ItineracionSolicitudResultado]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodItineracionSolicitud])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	ADD
	CONSTRAINT [DF__Itineraci__TF_Ac__08388C81]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	ADD
	CONSTRAINT [DF__Itineraci__TF_Pa__092CB0BA]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	WITH CHECK
	ADD CONSTRAINT [FK_ItineracionSolicitudResultado_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	CHECK CONSTRAINT [FK_ItineracionSolicitudResultado_Expediente]

GO
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	WITH CHECK
	ADD CONSTRAINT [FK_ItineracionSolicitudResultado_Itineracion]
	FOREIGN KEY ([TU_CodItineracionSolicitud]) REFERENCES [Historico].[Itineracion] ([TU_CodHistoricoItineracion])
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	CHECK CONSTRAINT [FK_ItineracionSolicitudResultado_Itineracion]

GO
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	WITH CHECK
	ADD CONSTRAINT [FK_ItineracionSolicitudResultado_Itineracion_Resultado]
	FOREIGN KEY ([TU_CodItineracionResultado]) REFERENCES [Historico].[Itineracion] ([TU_CodHistoricoItineracion])
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	CHECK CONSTRAINT [FK_ItineracionSolicitudResultado_Itineracion_Resultado]

GO
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	WITH CHECK
	ADD CONSTRAINT [FK_ItineracionSolicitudResultado_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	CHECK CONSTRAINT [FK_ItineracionSolicitudResultado_Legajo]

GO
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	WITH CHECK
	ADD CONSTRAINT [FK_ItineracionSolicitudResultado_ResultadoSolicitud]
	FOREIGN KEY ([TU_CodResultadoSolicitud]) REFERENCES [Expediente].[ResultadoSolicitud] ([TU_CodResultadoSolicitud])
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	CHECK CONSTRAINT [FK_ItineracionSolicitudResultado_ResultadoSolicitud]

GO
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	WITH CHECK
	ADD CONSTRAINT [FK_ItineracionSolicitudResultado_Solicitud]
	FOREIGN KEY ([TU_CodSolicitud]) REFERENCES [Expediente].[SolicitudExpediente] ([TU_CodSolicitudExpediente])
ALTER TABLE [Historico].[ItineracionSolicitudResultado]
	CHECK CONSTRAINT [FK_ItineracionSolicitudResultado_Solicitud]

GO
CREATE CLUSTERED INDEX [IX_Historico_ItineracionSolicitudResultado_TF_Particion]
	ON [Historico].[ItineracionSolicitudResultado] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la itineración de la solicitud', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionSolicitudResultado', 'COLUMN', N'TU_CodItineracionSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente al que pertenece la itineración de la Solicitud', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionSolicitudResultado', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único de la solicitud itinerada', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionSolicitudResultado', 'COLUMN', N'TU_CodSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo creado producto de la recepción de la Solicitud', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionSolicitudResultado', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único del resultado de la solicitud', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionSolicitudResultado', 'COLUMN', N'TU_CodResultadoSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la itineración del resultado de la Solicitud', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionSolicitudResultado', 'COLUMN', N'TU_CodItineracionResultado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionSolicitudResultado', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora del registro', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionSolicitudResultado', 'COLUMN', N'TF_Particion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Guarda el IDACO de la solicitud para identificar la respuesta del envío', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionSolicitudResultado', 'COLUMN', N'IDACOSOL'
GO
ALTER TABLE [Historico].[ItineracionSolicitudResultado] SET (LOCK_ESCALATION = TABLE)
GO

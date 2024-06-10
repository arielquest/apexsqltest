SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[Itineracion] (
		[TU_CodItineracion]                          [uniqueidentifier] NULL,
		[TC_NumeroExpediente]                        [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodHistoricoItineracion]                 [uniqueidentifier] NOT NULL,
		[TN_CodTipoItineracion]                      [smallint] NOT NULL,
		[TC_CodContextoOrigen]                       [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContextoDestino]                      [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]                              [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodEstadoItineracion]                    [smallint] NOT NULL,
		[TF_FechaEstado]                             [datetime2](3) NULL,
		[TC_MensajeError]                            [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]                           [datetime2](3) NULL,
		[CARPETA]                                    [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                               [datetime2](7) NOT NULL,
		[TC_DescripcionMotivoRechazoItineracion]     [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodMotivoRechazoItineracion]             [smallint] NULL,
		[TF_FechaRechazo]                            [datetime2](3) NULL,
		[ID_NAUTIUS]                                 [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TU_CodHistoricoItineracionPadre]            [uniqueidentifier] NULL,
		[TU_CodRegistroItineracion]                  [uniqueidentifier] NULL,
		[TF_FechaEnvio]                              [datetime2](3) NULL,
		[TN_CodMotivoItineracion]                    [smallint] NULL,
		CONSTRAINT [PK_Itineracion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodHistoricoItineracion])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[Itineracion]
	ADD
	CONSTRAINT [DF__Itineraci__TF_Ac__1AA9E072]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Historico].[Itineracion]
	ADD
	CONSTRAINT [DF__Expedient__TF_Pa__6F8C0EF1]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[Itineracion]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteItineracion_ContextoOrigen]
	FOREIGN KEY ([TC_CodContextoOrigen]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[Itineracion]
	CHECK CONSTRAINT [FK_ExpedienteItineracion_ContextoOrigen]

GO
ALTER TABLE [Historico].[Itineracion]
	WITH CHECK
	ADD CONSTRAINT [FK_Itineracion_ContextoDestino]
	FOREIGN KEY ([TC_CodContextoDestino]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[Itineracion]
	CHECK CONSTRAINT [FK_Itineracion_ContextoDestino]

GO
ALTER TABLE [Historico].[Itineracion]
	WITH CHECK
	ADD CONSTRAINT [FK_Itineracion_EstadoItineracion]
	FOREIGN KEY ([TN_CodEstadoItineracion]) REFERENCES [Catalogo].[EstadoItineracion] ([TN_CodEstadoItineracion])
ALTER TABLE [Historico].[Itineracion]
	CHECK CONSTRAINT [FK_Itineracion_EstadoItineracion]

GO
ALTER TABLE [Historico].[Itineracion]
	WITH CHECK
	ADD CONSTRAINT [FK_Itineracion_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[Itineracion]
	CHECK CONSTRAINT [FK_Itineracion_Expediente]

GO
ALTER TABLE [Historico].[Itineracion]
	WITH CHECK
	ADD CONSTRAINT [FK_Itineracion_Funcionario]
	FOREIGN KEY ([TC_UsuarioRed]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Historico].[Itineracion]
	CHECK CONSTRAINT [FK_Itineracion_Funcionario]

GO
ALTER TABLE [Historico].[Itineracion]
	WITH CHECK
	ADD CONSTRAINT [FK_Itineracion_TipoItineracion]
	FOREIGN KEY ([TN_CodTipoItineracion]) REFERENCES [Catalogo].[TipoItineracion] ([TN_CodTipoItineracion])
ALTER TABLE [Historico].[Itineracion]
	CHECK CONSTRAINT [FK_Itineracion_TipoItineracion]

GO
CREATE CLUSTERED INDEX [IX_Historico_Itineracion.TF_Particion]
	ON [Historico].[Itineracion] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_Itineracion_ID_NAUTIUS]
	ON [Historico].[Itineracion] ([TC_CodContextoDestino], [ID_NAUTIUS])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_Itineracion_Migracion]
	ON [Historico].[Itineracion] ([TC_NumeroExpediente], [TN_CodTipoItineracion], [TC_CodContextoOrigen], [TC_CodContextoDestino], [TF_FechaEstado])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_HistoricoItineracion_Contexto]
	ON [Historico].[Itineracion] ([TC_CodContextoDestino])
	INCLUDE ([TU_CodHistoricoItineracion], [TC_CodContextoOrigen])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra el historico de tineraciones de un expediente en las diferentes oficinas.', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de la itineración.', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TU_CodItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de expediente único a lo largo de la vida del expediente.', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de histórico de itineraciones.', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TU_CodHistoricoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo itineración.', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TN_CodTipoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contexto del que se origina la itineración.', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TC_CodContextoOrigen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contexto al que se destina la itineración.', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TC_CodContextoDestino'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Funcionario que envía la itineración.', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de la itineración.', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TN_CodEstadoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de estado.', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TF_FechaEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mensaje de error de la itineración', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TC_MensajeError'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la lectura del registro por SIGMA.', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de la itineración generado al enviar la itineración a Gestión, se crea el campo para la recepción de la respuesta de la itineración.', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'ID_NAUTIUS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo en el que se almacena el código del histórico de itineración del expediente padre, en los expediente acumulados', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TU_CodHistoricoItineracionPadre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código GUID correspondiente a la tabla asociada del registro de itineración, determinada según el campo TN_CodTipoItineracion (RecursoExpediente, SolicitudExpediente, ResultadoRecurso, ResultadoSolicitud, ExpedienteEntradaSalida o LegajoEntradaSalida)', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TU_CodRegistroItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de envío de la itineración', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TF_FechaEnvio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de itineración', 'SCHEMA', N'Historico', 'TABLE', N'Itineracion', 'COLUMN', N'TN_CodMotivoItineracion'
GO
ALTER TABLE [Historico].[Itineracion] SET (LOCK_ESCALATION = TABLE)
GO

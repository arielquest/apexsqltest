SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Agenda].[SolicitudLiberacionParticipacion] (
		[TU_CodSolicitudLiberacion]     [uniqueidentifier] NOT NULL,
		[TU_CodParticipacion]           [uniqueidentifier] NOT NULL,
		[TC_DescripcionSolicitud]       [varchar](200) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaInicioLiberacion]      [datetime2](7) NOT NULL,
		[TF_FechaFinLiberacion]         [datetime2](7) NOT NULL,
		[TF_FechaSolicitud]             [datetime2](7) NOT NULL,
		[TF_FechaResultado]             [datetime2](7) NULL,
		[TC_Observaciones]              [varchar](200) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_Aprobada]                   [bit] NULL,
		[TF_Particion]                  [datetime2](7) NOT NULL,
		CONSTRAINT [PK_SolicitudLiberacionTarea]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitudLiberacion])
	ON [PRIMARY]
) ON [AgendaPS] ([TF_Particion])
GO
ALTER TABLE [Agenda].[SolicitudLiberacionParticipacion]
	ADD
	CONSTRAINT [DF__Solicitud__TF_Pa__43AD8CB3]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Agenda].[SolicitudLiberacionParticipacion]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudLiberacionTarea_Tarea]
	FOREIGN KEY ([TU_CodParticipacion]) REFERENCES [Agenda].[ParticipanteEvento] ([TU_CodParticipacion])
ALTER TABLE [Agenda].[SolicitudLiberacionParticipacion]
	CHECK CONSTRAINT [FK_SolicitudLiberacionTarea_Tarea]

GO
CREATE CLUSTERED INDEX [IX_Agenda_SolicitudLiberacionParticipacion_TF_Participacion]
	ON [Agenda].[SolicitudLiberacionParticipacion] ([TF_Particion])
	ON [AgendaPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para alamcenar las solicitudes que realizan los participantes de los eventos para que se les libere su participación parcial o total en el evento', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudLiberacionParticipacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la solicitud', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudLiberacionParticipacion', 'COLUMN', N'TU_CodSolicitudLiberacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la participación en el evento', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudLiberacionParticipacion', 'COLUMN', N'TU_CodParticipacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la solictud, el porque se debe liberar la participación en el tiempo indicado', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudLiberacionParticipacion', 'COLUMN', N'TC_DescripcionSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha inicio en que se debe liberar la particiapación', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudLiberacionParticipacion', 'COLUMN', N'TF_FechaInicioLiberacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha fin en que se debe liberar la particiapación', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudLiberacionParticipacion', 'COLUMN', N'TF_FechaFinLiberacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se realiza la solicitud', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudLiberacionParticipacion', 'COLUMN', N'TF_FechaSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se resuelve la solicitud', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudLiberacionParticipacion', 'COLUMN', N'TF_FechaResultado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observación sobre la atención de la solicitud', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudLiberacionParticipacion', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la solicitud fue aprobada o rechazada, se indica nulo en caso que no se haya asignado resultado.', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudLiberacionParticipacion', 'COLUMN', N'TB_Aprobada'
GO
ALTER TABLE [Agenda].[SolicitudLiberacionParticipacion] SET (LOCK_ESCALATION = TABLE)
GO

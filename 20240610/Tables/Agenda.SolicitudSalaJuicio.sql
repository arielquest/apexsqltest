SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Agenda].[SolicitudSalaJuicio] (
		[TU_CodSolicitud]           [uniqueidentifier] NOT NULL,
		[TU_CodEvento]              [uniqueidentifier] NOT NULL,
		[TN_CantidadPersonas]       [smallint] NULL,
		[TF_FechaSolicitud]         [datetime2](7) NOT NULL,
		[TC_ResultadoSolicitud]     [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaResultado]         [datetime2](7) NULL,
		[TC_Observaciones]          [varchar](150) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]              [datetime2](7) NOT NULL,
		CONSTRAINT [PK_SolicitudSalaJuicio]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitud])
	ON [PRIMARY]
) ON [AgendaPS] ([TF_Particion])
GO
ALTER TABLE [Agenda].[SolicitudSalaJuicio]
	ADD
	CONSTRAINT [CK_Resultado]
	CHECK
	([TC_ResultadoSolicitud]='A' OR [TC_ResultadoSolicitud]='R')
GO
ALTER TABLE [Agenda].[SolicitudSalaJuicio]
CHECK CONSTRAINT [CK_Resultado]
GO
ALTER TABLE [Agenda].[SolicitudSalaJuicio]
	ADD
	CONSTRAINT [DF__Solicitud__TF_Pa__53E3F47C]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Agenda].[SolicitudSalaJuicio]
	WITH NOCHECK
	ADD CONSTRAINT [FK_SolicitudSalaJuicio_Evento]
	FOREIGN KEY ([TU_CodEvento]) REFERENCES [Agenda].[Evento] ([TU_CodEvento])
ALTER TABLE [Agenda].[SolicitudSalaJuicio]
	CHECK CONSTRAINT [FK_SolicitudSalaJuicio_Evento]

GO
CREATE CLUSTERED INDEX [IX_Agenda_SolicitudSalaJuicio_TF_Particion]
	ON [Agenda].[SolicitudSalaJuicio] ([TF_Particion])
	ON [AgendaPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Agenda_ParticipanteSolicitudSalaJuicio_Migracion]
	ON [Agenda].[SolicitudSalaJuicio] ([TU_CodEvento])
	ON [AgendaPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que almacena las solicitudes de salas de jucio para los eventos de la agenda', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudSalaJuicio', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la solicitud', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudSalaJuicio', 'COLUMN', N'TU_CodSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del evento de la agenda', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudSalaJuicio', 'COLUMN', N'TU_CodEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Se indica la cantidad de personas que harán uso de la sala de juicio ', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudSalaJuicio', 'COLUMN', N'TN_CantidadPersonas'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la solicitud', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudSalaJuicio', 'COLUMN', N'TF_FechaSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo para indicar el resultado de la solicitud. WITH CHECK ADD  CONSTRAINT para asegurarse de que solo reciba dos valores A y R. Donde A = Asignado y R = Rechazado', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudSalaJuicio', 'COLUMN', N'TC_ResultadoSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de asignación de la sala', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudSalaJuicio', 'COLUMN', N'TF_FechaResultado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones de la solicitud', 'SCHEMA', N'Agenda', 'TABLE', N'SolicitudSalaJuicio', 'COLUMN', N'TC_Observaciones'
GO
ALTER TABLE [Agenda].[SolicitudSalaJuicio] SET (LOCK_ESCALATION = TABLE)
GO

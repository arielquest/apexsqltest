SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Agenda].[ParticipanteEvento] (
		[TU_CodParticipacion]           [uniqueidentifier] NOT NULL,
		[TU_CodEvento]                  [uniqueidentifier] NOT NULL,
		[TC_CodPuestoTrabajo]           [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodEstadoParticipacion]     [smallint] NOT NULL,
		[TC_Observaciones]              [varchar](200) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                  [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Tarea]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodParticipacion])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Agenda].[ParticipanteEvento]
	ADD
	CONSTRAINT [DF__Participa__TF_Pa__71745763]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Agenda].[ParticipanteEvento]
	WITH NOCHECK
	ADD CONSTRAINT [FK_ParticipanteEvento_Evento]
	FOREIGN KEY ([TU_CodEvento]) REFERENCES [Agenda].[Evento] ([TU_CodEvento])
ALTER TABLE [Agenda].[ParticipanteEvento]
	CHECK CONSTRAINT [FK_ParticipanteEvento_Evento]

GO
ALTER TABLE [Agenda].[ParticipanteEvento]
	WITH CHECK
	ADD CONSTRAINT [FK_ParticipanteEvento_PuestoDeTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Agenda].[ParticipanteEvento]
	CHECK CONSTRAINT [FK_ParticipanteEvento_PuestoDeTrabajo]

GO
ALTER TABLE [Agenda].[ParticipanteEvento]
	WITH CHECK
	ADD CONSTRAINT [FK_Tarea_EstadoTarea]
	FOREIGN KEY ([TN_CodEstadoParticipacion]) REFERENCES [Catalogo].[EstadoParticipacionEvento] ([TN_CodEstadoParticipacion])
ALTER TABLE [Agenda].[ParticipanteEvento]
	CHECK CONSTRAINT [FK_Tarea_EstadoTarea]

GO
CREATE NONCLUSTERED INDEX [IX_Agenda_ParticipanteEvento_Migracion]
	ON [Agenda].[ParticipanteEvento] ([TU_CodEvento], [TC_CodPuestoTrabajo], [TN_CodEstadoParticipacion])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Agenda_ParticipanteEvento_TF_Particion]
	ON [Agenda].[ParticipanteEvento] ([TF_Particion])
	ON [AgendaPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_ParticipanteEvento_ConsultarSolicitudSalaJuicio]
	ON [Agenda].[ParticipanteEvento] ([TU_CodEvento])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice creado para optimizar Agenda.PA_ConsultarSolicitudSalaJuicio', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteEvento', 'INDEX', N'IX_ParticipanteEvento_ConsultarSolicitudSalaJuicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que liga a los participantes con el evento', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteEvento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la participacion', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteEvento', 'COLUMN', N'TU_CodParticipacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del evento', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteEvento', 'COLUMN', N'TU_CodEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo del participante del evento', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteEvento', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado de la participación', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteEvento', 'COLUMN', N'TN_CodEstadoParticipacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones sobre la participación del funcionario', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteEvento', 'COLUMN', N'TC_Observaciones'
GO
ALTER TABLE [Agenda].[ParticipanteEvento] SET (LOCK_ESCALATION = TABLE)
GO

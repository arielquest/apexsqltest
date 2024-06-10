SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Agenda].[IntervinienteEvento] (
		[TU_CodInterviniente]     [uniqueidentifier] NOT NULL,
		[TU_CodEvento]            [uniqueidentifier] NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_IntervinienteEvento]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodInterviniente], [TU_CodEvento])
	ON [PRIMARY]
) ON [AgendaPS] ([TF_Particion])
GO
ALTER TABLE [Agenda].[IntervinienteEvento]
	ADD
	CONSTRAINT [DF__Intervini__TF_Pa__735C9FD5]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Agenda].[IntervinienteEvento]
	WITH NOCHECK
	ADD CONSTRAINT [FK_IntervinienteEvento_Evento]
	FOREIGN KEY ([TU_CodEvento]) REFERENCES [Agenda].[Evento] ([TU_CodEvento])
ALTER TABLE [Agenda].[IntervinienteEvento]
	CHECK CONSTRAINT [FK_IntervinienteEvento_Evento]

GO
ALTER TABLE [Agenda].[IntervinienteEvento]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteEvento_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Agenda].[IntervinienteEvento]
	CHECK CONSTRAINT [FK_IntervinienteEvento_Intervencion]

GO
CREATE CLUSTERED INDEX [IX_Agenda_IntervinienteEvento_TF_Particion]
	ON [Agenda].[IntervinienteEvento] ([TF_Particion])
	ON [AgendaPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_IntervinienteEvento_ConsultarSolicitudSalaJuicio]
	ON [Agenda].[IntervinienteEvento] ([TU_CodEvento])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice creado para optimizar Agenda.PA_ConsultarSolicitudSalaJuicio', 'SCHEMA', N'Agenda', 'TABLE', N'IntervinienteEvento', 'INDEX', N'IX_IntervinienteEvento_ConsultarSolicitudSalaJuicio'
GO
CREATE NONCLUSTERED INDEX [IX_IntervinienteEvento_Interviniente]
	ON [Agenda].[IntervinienteEvento] ([TU_CodInterviniente])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice creado para optimizar Comunicacion.PA_ConsultarBuzon', 'SCHEMA', N'Agenda', 'TABLE', N'IntervinienteEvento', 'INDEX', N'IX_IntervinienteEvento_Interviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que liga los intervinientes a un evento', 'SCHEMA', N'Agenda', 'TABLE', N'IntervinienteEvento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del interviniente ligado al evento', 'SCHEMA', N'Agenda', 'TABLE', N'IntervinienteEvento', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del evento', 'SCHEMA', N'Agenda', 'TABLE', N'IntervinienteEvento', 'COLUMN', N'TU_CodEvento'
GO
ALTER TABLE [Agenda].[IntervinienteEvento] SET (LOCK_ESCALATION = TABLE)
GO

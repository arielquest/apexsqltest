SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Agenda].[FechaParticipanteParcial] (
		[TU_CodParticipacion]             [uniqueidentifier] NOT NULL,
		[TU_CodFechaEvento]               [uniqueidentifier] NOT NULL,
		[TF_FechaInicioParticipacion]     [datetime2](7) NOT NULL,
		[TF_FechaFinParticipacion]        [datetime2](7) NOT NULL,
		[TF_Particion]                    [datetime2](7) NOT NULL,
		CONSTRAINT [PK_FechaParticipanteParcial]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodParticipacion], [TU_CodFechaEvento])
	ON [PRIMARY]
) ON [AgendaPS] ([TF_Particion])
GO
ALTER TABLE [Agenda].[FechaParticipanteParcial]
	ADD
	CONSTRAINT [DF__FechaPart__TF_Pa__0D1C71D8]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Agenda].[FechaParticipanteParcial]
	WITH CHECK
	ADD CONSTRAINT [FK_FechaParticipanteParcial_ParticipanteFechaEvento]
	FOREIGN KEY ([TU_CodParticipacion], [TU_CodFechaEvento]) REFERENCES [Agenda].[ParticipanteFechaEvento] ([TU_CodParticipacion], [TU_CodFechaEvento])
ALTER TABLE [Agenda].[FechaParticipanteParcial]
	CHECK CONSTRAINT [FK_FechaParticipanteParcial_ParticipanteFechaEvento]

GO
CREATE CLUSTERED INDEX [IX_Agenda_FechaParticipanteParcial_TF_Particion]
	ON [Agenda].[FechaParticipanteParcial] ([TF_Particion])
	ON [AgendaPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena las fechas para los participantes que solo están parcialmente en el evento. Su participación es diferente a la totalidad del evento', 'SCHEMA', N'Agenda', 'TABLE', N'FechaParticipanteParcial', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la participación', 'SCHEMA', N'Agenda', 'TABLE', N'FechaParticipanteParcial', 'COLUMN', N'TU_CodParticipacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identifcador de la fecha del evento es que participa', 'SCHEMA', N'Agenda', 'TABLE', N'FechaParticipanteParcial', 'COLUMN', N'TU_CodFechaEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que inicia la participación parcial, se indica la hora. La fecha debe coincidir con la fecha asociada a la participación ', 'SCHEMA', N'Agenda', 'TABLE', N'FechaParticipanteParcial', 'COLUMN', N'TF_FechaInicioParticipacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que finaliza la participación parcial , se indica la hora. La fecha debe coincidir con la fecha asociada a la participación ', 'SCHEMA', N'Agenda', 'TABLE', N'FechaParticipanteParcial', 'COLUMN', N'TF_FechaFinParticipacion'
GO
ALTER TABLE [Agenda].[FechaParticipanteParcial] SET (LOCK_ESCALATION = TABLE)
GO

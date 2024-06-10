SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Agenda].[ParticipanteFechaEvento] (
		[TU_CodParticipacion]         [uniqueidentifier] NOT NULL,
		[TU_CodFechaEvento]           [uniqueidentifier] NOT NULL,
		[TB_ParticipacionParcial]     [bit] NOT NULL,
		[TF_Particion]                [date] NOT NULL,
		CONSTRAINT [PK_ParticipanteFechaEvento]
		PRIMARY KEY
		CLUSTERED
		([TU_CodParticipacion], [TU_CodFechaEvento])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Agenda].[ParticipanteFechaEvento]
	ADD
	CONSTRAINT [DF__Participa__TF_Pa__44A1B0EC]
	DEFAULT (getdate()) FOR [TF_Particion]
GO
ALTER TABLE [Agenda].[ParticipanteFechaEvento]
	WITH CHECK
	ADD CONSTRAINT [FK_ParticipanteFechaEvento_FechaEvento]
	FOREIGN KEY ([TU_CodFechaEvento]) REFERENCES [Agenda].[FechaEvento] ([TU_CodFechaEvento])
ALTER TABLE [Agenda].[ParticipanteFechaEvento]
	CHECK CONSTRAINT [FK_ParticipanteFechaEvento_FechaEvento]

GO
ALTER TABLE [Agenda].[ParticipanteFechaEvento]
	WITH CHECK
	ADD CONSTRAINT [FK_ParticipanteFechaEvento_ParticipanteEvento]
	FOREIGN KEY ([TU_CodParticipacion]) REFERENCES [Agenda].[ParticipanteEvento] ([TU_CodParticipacion])
ALTER TABLE [Agenda].[ParticipanteFechaEvento]
	CHECK CONSTRAINT [FK_ParticipanteFechaEvento_ParticipanteEvento]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que asocia los participantes con cada fecha del evento', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteFechaEvento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la participacion', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteFechaEvento', 'COLUMN', N'TU_CodParticipacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identifcador de la fecha del evento', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteFechaEvento', 'COLUMN', N'TU_CodFechaEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la participacion es parcial. Si es parcial debe consultarse la tabla de participación parcial para determinar la participación en el evento', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteFechaEvento', 'COLUMN', N'TB_ParticipacionParcial'
GO
ALTER TABLE [Agenda].[ParticipanteFechaEvento] SET (LOCK_ESCALATION = TABLE)
GO

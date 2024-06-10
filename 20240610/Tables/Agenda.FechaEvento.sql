SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Agenda].[FechaEvento] (
		[TU_CodFechaEvento]     [uniqueidentifier] NOT NULL,
		[TU_CodEvento]          [uniqueidentifier] NOT NULL,
		[TF_FechaInicio]        [datetime2](7) NOT NULL,
		[TF_FechaFin]           [datetime2](7) NOT NULL,
		[TN_CodSala]            [smallint] NULL,
		[TC_Observaciones]      [varchar](150) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_Cancelada]          [bit] NOT NULL,
		[TN_MontoRemate]        [decimal](18, 2) NULL,
		[TB_Lista]              [bit] NOT NULL,
		[TF_Particion]          [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Evento_1]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodFechaEvento])
	ON [PRIMARY]
) ON [AgendaPS] ([TF_Particion])
GO
ALTER TABLE [Agenda].[FechaEvento]
	ADD
	CONSTRAINT [DF__FechaEven__TF_Pa__477E1D97]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Agenda].[FechaEvento]
	WITH NOCHECK
	ADD CONSTRAINT [FK_Evento_EventoDetalle]
	FOREIGN KEY ([TU_CodEvento]) REFERENCES [Agenda].[Evento] ([TU_CodEvento])
ALTER TABLE [Agenda].[FechaEvento]
	CHECK CONSTRAINT [FK_Evento_EventoDetalle]

GO
ALTER TABLE [Agenda].[FechaEvento]
	WITH CHECK
	ADD CONSTRAINT [FK_FechaEvento_SalaJuicio]
	FOREIGN KEY ([TN_CodSala]) REFERENCES [Catalogo].[SalaJuicio] ([TN_CodSala])
ALTER TABLE [Agenda].[FechaEvento]
	CHECK CONSTRAINT [FK_FechaEvento_SalaJuicio]

GO
CREATE CLUSTERED INDEX [IX_Expediente_FechaEvento_TF_Particion]
	ON [Agenda].[FechaEvento] ([TF_Particion])
	ON [AgendaPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Agenda_FechaEvento_Migracion]
	ON [Agenda].[FechaEvento] ([TU_CodEvento], [TF_FechaInicio], [TF_FechaFin])
	ON [AgendaPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_FechaEvento_ConsultarSolicitudSalaJuicio]
	ON [Agenda].[FechaEvento] ([TB_Cancelada], [TB_Lista], [TF_FechaInicio], [TF_FechaFin])
	INCLUDE ([TU_CodEvento], [TN_CodSala])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice creado para optimizar Agenda.PA_ConsultarSolicitudSalaJuicio', 'SCHEMA', N'Agenda', 'TABLE', N'FechaEvento', 'INDEX', N'IX_FechaEvento_ConsultarSolicitudSalaJuicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que almacena las fechas de los eventos de la agenda. Todas las fechas ligadas a un mismo evento conforman la totalidad del evento', 'SCHEMA', N'Agenda', 'TABLE', N'FechaEvento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identifcador de la fecha del evento', 'SCHEMA', N'Agenda', 'TABLE', N'FechaEvento', 'COLUMN', N'TU_CodFechaEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del evento de la agenda', 'SCHEMA', N'Agenda', 'TABLE', N'FechaEvento', 'COLUMN', N'TU_CodEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que  se inicia el evento', 'SCHEMA', N'Agenda', 'TABLE', N'FechaEvento', 'COLUMN', N'TF_FechaInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que finaliza el evento', 'SCHEMA', N'Agenda', 'TABLE', N'FechaEvento', 'COLUMN', N'TF_FechaFin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la sala para ese día', 'SCHEMA', N'Agenda', 'TABLE', N'FechaEvento', 'COLUMN', N'TN_CodSala'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Agrega observaciones sobre un día específico del evento', 'SCHEMA', N'Agenda', 'TABLE', N'FechaEvento', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si para ese día del evento ha sido cancelado, esto libera el tiempo de la agenda', 'SCHEMA', N'Agenda', 'TABLE', N'FechaEvento', 'COLUMN', N'TB_Cancelada'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que solo aplica para los montos de los remates judiciales', 'SCHEMA', N'Agenda', 'TABLE', N'FechaEvento', 'COLUMN', N'TN_MontoRemate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el evento se ha efectuado', 'SCHEMA', N'Agenda', 'TABLE', N'FechaEvento', 'COLUMN', N'TB_Lista'
GO
ALTER TABLE [Agenda].[FechaEvento] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Agenda].[Recordatorio] (
		[TU_CodRecordatorio]       [uniqueidentifier] NOT NULL,
		[TU_CodEvento]             [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]      [uniqueidentifier] NOT NULL,
		[TC_NumeroMovil]           [varchar](11) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaInicioEvento]     [datetime2](7) NOT NULL,
		[TC_Mensaje]               [varchar](200) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Recordatorio]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodRecordatorio])
	ON [PRIMARY]
) ON [AgendaPS] ([TF_Particion])
GO
ALTER TABLE [Agenda].[Recordatorio]
	ADD
	CONSTRAINT [DF__Recordato__TF_Pa__69D3359B]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Agenda].[Recordatorio]
	WITH NOCHECK
	ADD CONSTRAINT [FK_Recordatorio_Evento]
	FOREIGN KEY ([TU_CodEvento]) REFERENCES [Agenda].[Evento] ([TU_CodEvento])
ALTER TABLE [Agenda].[Recordatorio]
	CHECK CONSTRAINT [FK_Recordatorio_Evento]

GO
ALTER TABLE [Agenda].[Recordatorio]
	WITH CHECK
	ADD CONSTRAINT [FK_Recordatorio_Interviniente]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Agenda].[Recordatorio]
	CHECK CONSTRAINT [FK_Recordatorio_Interviniente]

GO
CREATE CLUSTERED INDEX [IX_Agenda_Recordatorio_TF_Particion]
	ON [Agenda].[Recordatorio] ([TF_Particion])
	ON [AgendaPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los recordatorios de la agenda para los intervinientes', 'SCHEMA', N'Agenda', 'TABLE', N'Recordatorio', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del recordatorio', 'SCHEMA', N'Agenda', 'TABLE', N'Recordatorio', 'COLUMN', N'TU_CodRecordatorio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del evento ', 'SCHEMA', N'Agenda', 'TABLE', N'Recordatorio', 'COLUMN', N'TU_CodEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del interviniente ligado al evento', 'SCHEMA', N'Agenda', 'TABLE', N'Recordatorio', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del télefono móvil', 'SCHEMA', N'Agenda', 'TABLE', N'Recordatorio', 'COLUMN', N'TC_NumeroMovil'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que  se inicia el evento', 'SCHEMA', N'Agenda', 'TABLE', N'Recordatorio', 'COLUMN', N'TF_FechaInicioEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mensaje del recordatorio a comunicar ', 'SCHEMA', N'Agenda', 'TABLE', N'Recordatorio', 'COLUMN', N'TC_Mensaje'
GO
ALTER TABLE [Agenda].[Recordatorio] SET (LOCK_ESCALATION = TABLE)
GO

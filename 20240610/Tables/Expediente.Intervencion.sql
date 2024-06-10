SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[Intervencion] (
		[TU_CodInterviniente]         [uniqueidentifier] NOT NULL,
		[TC_TipoParticipacion]        [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodPersona]               [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]         [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]          [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]             [datetime2](7) NULL,
		[TF_Actualizacion]            [datetime2](7) NOT NULL,
		[TU_RelacionIntervencion]     [uniqueidentifier] NULL,
		[TF_Particion]                [datetime2](7) NOT NULL,
		[IDINT]                       [bigint] NULL,
		CONSTRAINT [PK_Intervencion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodInterviniente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[Intervencion]
	ADD
	CONSTRAINT [CK_Intervencion]
	CHECK
	([TC_TipoParticipacion]='P' OR [TC_TipoParticipacion]='R')
GO
ALTER TABLE [Expediente].[Intervencion]
CHECK CONSTRAINT [CK_Intervencion]
GO
ALTER TABLE [Expediente].[Intervencion]
	ADD
	CONSTRAINT [DF_Intervencion_TC_TipoParticipacion]
	DEFAULT ('P') FOR [TC_TipoParticipacion]
GO
ALTER TABLE [Expediente].[Intervencion]
	ADD
	CONSTRAINT [DF__Intervenc__TF_Ac__2744C181]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[Intervencion]
	ADD
	CONSTRAINT [DF__Intervenc__TF_Pa__782154F2]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[Intervencion]
	WITH CHECK
	ADD CONSTRAINT [FK_Intervencion_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[Intervencion]
	CHECK CONSTRAINT [FK_Intervencion_Expediente]

GO
ALTER TABLE [Expediente].[Intervencion]
	WITH CHECK
	ADD CONSTRAINT [FK_Intervencion_Intervecion]
	FOREIGN KEY ([TU_RelacionIntervencion]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[Intervencion]
	CHECK CONSTRAINT [FK_Intervencion_Intervecion]

GO
ALTER TABLE [Expediente].[Intervencion]
	WITH CHECK
	ADD CONSTRAINT [FK_Intervencion_Persona]
	FOREIGN KEY ([TU_CodPersona]) REFERENCES [Persona].[Persona] ([TU_CodPersona])
ALTER TABLE [Expediente].[Intervencion]
	CHECK CONSTRAINT [FK_Intervencion_Persona]

GO
CREATE CLUSTERED INDEX [IX_Expediente_Intervencion_TF_Particion]
	ON [Expediente].[Intervencion] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_Intervencion_Migracion]
	ON [Expediente].[Intervencion] ([TC_TipoParticipacion], [TU_CodPersona], [TC_NumeroExpediente])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Intervencion_TC_NumeroExpediente]
	ON [Expediente].[Intervencion] ([TC_NumeroExpediente])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [TF_Fin_Vigencia_Includes]
	ON [Expediente].[Intervencion] ([TF_Fin_Vigencia])
	INCLUDE ([TU_CodInterviniente], [TC_TipoParticipacion], [TU_CodPersona], [TC_NumeroExpediente], [TF_Inicio_Vigencia], [TF_Actualizacion], [IDINT])
	WITH ( FILLFACTOR = 100)
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [TU_CodPersona]
	ON [Expediente].[Intervencion] ([TU_CodPersona])
	WITH ( FILLFACTOR = 100)
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena las intervenciones de las personas en los expedientes. ', 'SCHEMA', N'Expediente', 'TABLE', N'Intervencion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de interviniente', 'SCHEMA', N'Expediente', 'TABLE', N'Intervencion', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de participación del interviniente en el expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'Intervencion', 'COLUMN', N'TC_TipoParticipacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la persona que será parte de la intervención', 'SCHEMA', N'Expediente', 'TABLE', N'Intervencion', 'COLUMN', N'TU_CodPersona'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de expediente', 'SCHEMA', N'Expediente', 'TABLE', N'Intervencion', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que inicia la intervencion', 'SCHEMA', N'Expediente', 'TABLE', N'Intervencion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que finaliza la intervencion', 'SCHEMA', N'Expediente', 'TABLE', N'Intervencion', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inclusion al sistema de la intervención', 'SCHEMA', N'Expediente', 'TABLE', N'Intervencion', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Interviniente relacionado', 'SCHEMA', N'Expediente', 'TABLE', N'Intervencion', 'COLUMN', N'TU_RelacionIntervencion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código que identifica a la intervención en Gestión, se registra para facilitar las itineraciones entre SIAGPJ y Gestión', 'SCHEMA', N'Expediente', 'TABLE', N'Intervencion', 'COLUMN', N'IDINT'
GO
ALTER TABLE [Expediente].[Intervencion] SET (LOCK_ESCALATION = TABLE)
GO

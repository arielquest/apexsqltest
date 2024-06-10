SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Agenda].[Evento] (
		[TU_CodEvento]              [uniqueidentifier] NOT NULL,
		[TC_CodContexto]            [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroExpediente]       [char](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Titulo]                 [varchar](80) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]            [varchar](300) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoEvento]          [smallint] NOT NULL,
		[TN_CodEstadoEvento]        [smallint] NOT NULL,
		[TN_CodMotivoEstado]        [smallint] NULL,
		[TN_CodPrioridadEvento]     [smallint] NOT NULL,
		[TC_UsuarioCrea]            [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_RequiereSala]           [bit] NOT NULL,
		[TF_FechaCreacion]          [datetime2](7) NOT NULL,
		[TF_Actualizacion]          [datetime2](7) NOT NULL,
		[TF_Particion]              [datetime2](7) NULL,
		[intIDApunte]               [int] NULL,
		[TU_CodLegajo]              [uniqueidentifier] NULL,
		CONSTRAINT [PK_Evento]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodEvento])
	ON [PRIMARY]
) ON [AgendaPS] ([TF_Particion])
GO
ALTER TABLE [Agenda].[Evento]
	ADD
	CONSTRAINT [DF__Evento__TF_Actua__52CE3E04]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Agenda].[Evento]
	ADD
	CONSTRAINT [DF_Evento_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Agenda].[Evento]
	WITH CHECK
	ADD CONSTRAINT [FK_Evento_Contextos]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Agenda].[Evento]
	CHECK CONSTRAINT [FK_Evento_Contextos]

GO
ALTER TABLE [Agenda].[Evento]
	WITH CHECK
	ADD CONSTRAINT [FK_Evento_EstadoEvento]
	FOREIGN KEY ([TN_CodEstadoEvento]) REFERENCES [Catalogo].[EstadoEvento] ([TN_CodEstadoEvento])
ALTER TABLE [Agenda].[Evento]
	CHECK CONSTRAINT [FK_Evento_EstadoEvento]

GO
ALTER TABLE [Agenda].[Evento]
	WITH CHECK
	ADD CONSTRAINT [FK_Evento_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Agenda].[Evento]
	CHECK CONSTRAINT [FK_Evento_Expediente]

GO
ALTER TABLE [Agenda].[Evento]
	WITH CHECK
	ADD CONSTRAINT [FK_Evento_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Agenda].[Evento]
	CHECK CONSTRAINT [FK_Evento_Legajo]

GO
ALTER TABLE [Agenda].[Evento]
	WITH CHECK
	ADD CONSTRAINT [FK_Evento_MotivoEstadoEvento]
	FOREIGN KEY ([TN_CodMotivoEstado]) REFERENCES [Catalogo].[MotivoEstadoEvento] ([TN_CodMotivoEstado])
ALTER TABLE [Agenda].[Evento]
	CHECK CONSTRAINT [FK_Evento_MotivoEstadoEvento]

GO
ALTER TABLE [Agenda].[Evento]
	WITH CHECK
	ADD CONSTRAINT [FK_Evento_PrioridadEvento]
	FOREIGN KEY ([TN_CodPrioridadEvento]) REFERENCES [Catalogo].[PrioridadEvento] ([TN_CodPrioridadEvento])
ALTER TABLE [Agenda].[Evento]
	CHECK CONSTRAINT [FK_Evento_PrioridadEvento]

GO
ALTER TABLE [Agenda].[Evento]
	WITH CHECK
	ADD CONSTRAINT [FK_Evento_TipoEvento]
	FOREIGN KEY ([TN_CodTipoEvento]) REFERENCES [Catalogo].[TipoEvento] ([TN_CodTipoEvento])
ALTER TABLE [Agenda].[Evento]
	CHECK CONSTRAINT [FK_Evento_TipoEvento]

GO
ALTER TABLE [Agenda].[Evento]
	WITH CHECK
	ADD CONSTRAINT [FK_Evento_Usuario]
	FOREIGN KEY ([TC_UsuarioCrea]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Agenda].[Evento]
	CHECK CONSTRAINT [FK_Evento_Usuario]

GO
CREATE CLUSTERED INDEX [IX_Agenda_Evento_TF_Particion]
	ON [Agenda].[Evento] ([TF_Particion])
	ON [AgendaPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_Agenda_Evento_TC_CodContexto_INCLUDE]
	ON [Agenda].[Evento] ([TC_CodContexto])
	INCLUDE ([TU_CodEvento], [TC_NumeroExpediente], [TC_Titulo], [TC_Descripcion], [TN_CodTipoEvento], [TN_CodEstadoEvento])
	WITH ( FILLFACTOR = 100)
	ON [AgendaPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Agenda_Evento_Migracion]
	ON [Agenda].[Evento] ([TC_NumeroExpediente], [TC_CodContexto], [TN_CodTipoEvento], [TF_FechaCreacion])
	ON [AgendaPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que almacena la información de los eventos de la agenda', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del evento ', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', 'COLUMN', N'TU_CodEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto.', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del expediente al que corresponde el evento.', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Titulo del evento', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', 'COLUMN', N'TC_Titulo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del evento', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de evento', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', 'COLUMN', N'TN_CodTipoEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codifo del estado del evento', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', 'COLUMN', N'TN_CodEstadoEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo del estado del evento', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', 'COLUMN', N'TN_CodMotivoEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la prioridad del evento', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', 'COLUMN', N'TN_CodPrioridadEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del usuario que crea el evento', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', 'COLUMN', N'TC_UsuarioCrea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si requiera sala de jucio para el evento', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', 'COLUMN', N'TB_RequiereSala'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación del evento', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', 'COLUMN', N'TF_FechaCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización del evento. SIGMA', 'SCHEMA', N'Agenda', 'TABLE', N'Evento', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Agenda].[Evento] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[ExpedienteEntradaSalida] (
		[TU_CodExpedienteEntradaSalida]     [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]               [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]                    [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Entrada]                        [datetime2](3) NOT NULL,
		[TF_CreacionItineracion]            [datetime2](3) NULL,
		[TF_Salida]                         [datetime2](3) NULL,
		[TC_CodContextoDestino]             [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodMotivoItineracion]           [smallint] NULL,
		[TU_CodHistoricoItineracion]        [uniqueidentifier] NULL,
		[TF_Particion]                      [datetime2](7) NOT NULL,
		[ID_NAUTIUS]                        [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_ExpedienteEntradaSalida]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodExpedienteEntradaSalida])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[ExpedienteEntradaSalida]
	ADD
	CONSTRAINT [DF__Expedient__TF_Pa__3712ABA4]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[ExpedienteEntradaSalida]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteEntradaSalida_Contextos]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[ExpedienteEntradaSalida]
	CHECK CONSTRAINT [FK_ExpedienteEntradaSalida_Contextos]

GO
ALTER TABLE [Historico].[ExpedienteEntradaSalida]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteEntradaSalida_Contextos1]
	FOREIGN KEY ([TC_CodContextoDestino]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[ExpedienteEntradaSalida]
	CHECK CONSTRAINT [FK_ExpedienteEntradaSalida_Contextos1]

GO
ALTER TABLE [Historico].[ExpedienteEntradaSalida]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteEntradaSalida_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[ExpedienteEntradaSalida]
	CHECK CONSTRAINT [FK_ExpedienteEntradaSalida_Expediente]

GO
ALTER TABLE [Historico].[ExpedienteEntradaSalida]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteEntradaSalida_ExpedienteItineracion]
	FOREIGN KEY ([TU_CodHistoricoItineracion]) REFERENCES [Historico].[Itineracion] ([TU_CodHistoricoItineracion])
ALTER TABLE [Historico].[ExpedienteEntradaSalida]
	CHECK CONSTRAINT [FK_ExpedienteEntradaSalida_ExpedienteItineracion]

GO
ALTER TABLE [Historico].[ExpedienteEntradaSalida]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteEntradaSalida_MotivoItineracion]
	FOREIGN KEY ([TN_CodMotivoItineracion]) REFERENCES [Catalogo].[MotivoItineracion] ([TN_CodMotivoItineracion])
ALTER TABLE [Historico].[ExpedienteEntradaSalida]
	CHECK CONSTRAINT [FK_ExpedienteEntradaSalida_MotivoItineracion]

GO
CREATE CLUSTERED INDEX [IX_Historico_ExpedienteEntradaSalida_TF_Particion]
	ON [Historico].[ExpedienteEntradaSalida] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_ExpedienteEntradaSalida_ContextoDestino]
	ON [Historico].[ExpedienteEntradaSalida] ([TC_CodContexto], [TC_CodContextoDestino])
	INCLUDE ([TU_CodExpedienteEntradaSalida], [TC_NumeroExpediente])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_ExpedienteEntradaSalida_TU_CodHistoricoItineracion]
	ON [Historico].[ExpedienteEntradaSalida] ([TU_CodHistoricoItineracion])
	INCLUDE ([TC_NumeroExpediente], [TF_CreacionItineracion], [TF_Salida], [TN_CodMotivoItineracion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_ExpedienteEntradaSalida_Migracion]
	ON [Historico].[ExpedienteEntradaSalida] ([TC_NumeroExpediente], [TC_CodContexto], [TF_Entrada], [TC_CodContextoDestino])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra el historico de entrada y salidas de un expediente en las diferentes oficinas.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteEntradaSalida', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de registro de expediente entrada salida.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteEntradaSalida', 'COLUMN', N'TU_CodExpedienteEntradaSalida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de expediente único a lo largo de la vida del expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteEntradaSalida', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto del que se originó la itineración.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteEntradaSalida', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se realiza la entrada del expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteEntradaSalida', 'COLUMN', N'TF_Entrada'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha real en que se debe realizar la salida del expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteEntradaSalida', 'COLUMN', N'TF_CreacionItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se realiza la salida del expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteEntradaSalida', 'COLUMN', N'TF_Salida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto destino.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteEntradaSalida', 'COLUMN', N'TC_CodContextoDestino'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de itineración.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteEntradaSalida', 'COLUMN', N'TN_CodMotivoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de historico de itineración.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteEntradaSalida', 'COLUMN', N'TU_CodHistoricoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de la itineración asociada al movimiento de salida de un expediente en Gestión, se crea el campo para la recepción de itineraciones de Gestión.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteEntradaSalida', 'COLUMN', N'ID_NAUTIUS'
GO
ALTER TABLE [Historico].[ExpedienteEntradaSalida] SET (LOCK_ESCALATION = TABLE)
GO

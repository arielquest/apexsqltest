SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[LegajoEntradaSalida] (
		[TU_CodLegajoEntradaSalida]      [uniqueidentifier] NOT NULL,
		[TU_CodLegajo]                   [uniqueidentifier] NULL,
		[TC_CodContexto]                 [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Entrada]                     [datetime2](3) NOT NULL,
		[TF_CreacionItineracion]         [datetime2](3) NULL,
		[TF_Salida]                      [datetime2](3) NULL,
		[TC_CodContextoDestino]          [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodMotivoItineracion]        [smallint] NULL,
		[TU_CodHistoricoItineracion]     [uniqueidentifier] NULL,
		[TF_Particion]                   [datetime2](7) NOT NULL,
		[ID_NAUTIUS]                     [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_LegajoEntradaSalida]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodLegajoEntradaSalida])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[LegajoEntradaSalida]
	ADD
	CONSTRAINT [DF__LegajoEnt__TF_Pa__11E126F5]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[LegajoEntradaSalida]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoEntradaSalida_Contextos]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[LegajoEntradaSalida]
	CHECK CONSTRAINT [FK_LegajoEntradaSalida_Contextos]

GO
ALTER TABLE [Historico].[LegajoEntradaSalida]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoEntradaSalida_Contextos1]
	FOREIGN KEY ([TC_CodContextoDestino]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[LegajoEntradaSalida]
	CHECK CONSTRAINT [FK_LegajoEntradaSalida_Contextos1]

GO
ALTER TABLE [Historico].[LegajoEntradaSalida]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoEntradaSalida_ExpedienteItineracion]
	FOREIGN KEY ([TU_CodHistoricoItineracion]) REFERENCES [Historico].[Itineracion] ([TU_CodHistoricoItineracion])
ALTER TABLE [Historico].[LegajoEntradaSalida]
	CHECK CONSTRAINT [FK_LegajoEntradaSalida_ExpedienteItineracion]

GO
ALTER TABLE [Historico].[LegajoEntradaSalida]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoEntradaSalida_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Historico].[LegajoEntradaSalida]
	CHECK CONSTRAINT [FK_LegajoEntradaSalida_Legajo]

GO
ALTER TABLE [Historico].[LegajoEntradaSalida]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoEntradaSalida_MotivoItineracion]
	FOREIGN KEY ([TN_CodMotivoItineracion]) REFERENCES [Catalogo].[MotivoItineracion] ([TN_CodMotivoItineracion])
ALTER TABLE [Historico].[LegajoEntradaSalida]
	CHECK CONSTRAINT [FK_LegajoEntradaSalida_MotivoItineracion]

GO
CREATE CLUSTERED INDEX [IX_Historico_LegajoEntradaSalida_TF_Particion]
	ON [Historico].[LegajoEntradaSalida] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_LegajoEntradaSalida_Migracion]
	ON [Historico].[LegajoEntradaSalida] ([TU_CodLegajo], [TC_CodContexto], [TF_Entrada], [TC_CodContextoDestino])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_LegajoEntradaSalida_CodHistoricoItineracion]
	ON [Historico].[LegajoEntradaSalida] ([TU_CodHistoricoItineracion])
	INCLUDE ([TU_CodLegajo])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_LegajoEntradaSalida_ContextoDestino]
	ON [Historico].[LegajoEntradaSalida] ([TC_CodContexto], [TC_CodContextoDestino])
	INCLUDE ([TU_CodLegajoEntradaSalida], [TU_CodLegajo])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra el historico de entrada y salidas de un legajo en las diferentes oficinas.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoEntradaSalida', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de registro de expediente entrada salida.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoEntradaSalida', 'COLUMN', N'TU_CodLegajoEntradaSalida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoEntradaSalida', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto del que se originó la itineración.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoEntradaSalida', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se realiza la entrada del legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoEntradaSalida', 'COLUMN', N'TF_Entrada'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha real en que se debe realizar la salida del legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoEntradaSalida', 'COLUMN', N'TF_CreacionItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se realiza la salida del legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoEntradaSalida', 'COLUMN', N'TF_Salida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto destino.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoEntradaSalida', 'COLUMN', N'TC_CodContextoDestino'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de itineración.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoEntradaSalida', 'COLUMN', N'TN_CodMotivoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de historico de itineración.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoEntradaSalida', 'COLUMN', N'TU_CodHistoricoItineracion'
GO
EXEC sp_addextendedproperty N'Description', N'Campo equivalente al valor de ID NAUTIUS de DHISITI de Gestion', 'SCHEMA', N'Historico', 'TABLE', N'LegajoEntradaSalida', 'COLUMN', N'ID_NAUTIUS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo equivalente al valor de ID NAUTIUS de DHISITI de Gestion', 'SCHEMA', N'Historico', 'TABLE', N'LegajoEntradaSalida', 'COLUMN', N'ID_NAUTIUS'
GO
ALTER TABLE [Historico].[LegajoEntradaSalida] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[ItineracionRecursoResultado] (
		[TU_CodItineracionRecurso]       [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]            [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodRecurso]                  [uniqueidentifier] NULL,
		[TU_CodLegajo]                   [uniqueidentifier] NULL,
		[TU_CodResultadoRecurso]         [uniqueidentifier] NULL,
		[TU_CodItineracionResultado]     [uniqueidentifier] NULL,
		[TF_Actualizacion]               [datetime2](7) NOT NULL,
		[TF_Particion]                   [datetime2](7) NOT NULL,
		[CARPETA]                        [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[IDACOREC]                       [bigint] NULL,
		CONSTRAINT [PK_ItineracionRecursoResultado]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodItineracionRecurso])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	ADD
	CONSTRAINT [DF__Itineraci__TF_Ac__71552729]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	ADD
	CONSTRAINT [DF__Itineraci__TF_Pa__72494B62]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	WITH CHECK
	ADD CONSTRAINT [FK_ItineracionRecursoResultado_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	CHECK CONSTRAINT [FK_ItineracionRecursoResultado_Expediente]

GO
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	WITH CHECK
	ADD CONSTRAINT [FK_ItineracionRecursoResultado_Itineracion]
	FOREIGN KEY ([TU_CodItineracionRecurso]) REFERENCES [Historico].[Itineracion] ([TU_CodHistoricoItineracion])
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	CHECK CONSTRAINT [FK_ItineracionRecursoResultado_Itineracion]

GO
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	WITH CHECK
	ADD CONSTRAINT [FK_ItineracionRecursoResultado_Itineracion_Resultado]
	FOREIGN KEY ([TU_CodItineracionResultado]) REFERENCES [Historico].[Itineracion] ([TU_CodHistoricoItineracion])
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	CHECK CONSTRAINT [FK_ItineracionRecursoResultado_Itineracion_Resultado]

GO
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	WITH CHECK
	ADD CONSTRAINT [FK_ItineracionRecursoResultado_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	CHECK CONSTRAINT [FK_ItineracionRecursoResultado_Legajo]

GO
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	WITH CHECK
	ADD CONSTRAINT [FK_ItineracionRecursoResultado_Recurso]
	FOREIGN KEY ([TU_CodRecurso]) REFERENCES [Expediente].[RecursoExpediente] ([TU_CodRecurso])
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	CHECK CONSTRAINT [FK_ItineracionRecursoResultado_Recurso]

GO
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	WITH CHECK
	ADD CONSTRAINT [FK_ItineracionRecursoResultado_ResultadoRecurso]
	FOREIGN KEY ([TU_CodResultadoRecurso]) REFERENCES [Expediente].[ResultadoRecurso] ([TU_CodResultadoRecurso])
ALTER TABLE [Historico].[ItineracionRecursoResultado]
	CHECK CONSTRAINT [FK_ItineracionRecursoResultado_ResultadoRecurso]

GO
CREATE CLUSTERED INDEX [IX_Historico_ItineracionRecursoResultado_TF_Particion]
	ON [Historico].[ItineracionRecursoResultado] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_ItineracionRecursoResultado_Legajo]
	ON [Historico].[ItineracionRecursoResultado] ([TU_CodLegajo])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la itineración del recurso', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionRecursoResultado', 'COLUMN', N'TU_CodItineracionRecurso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente al que pertenece la itineración del recurso', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionRecursoResultado', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único del recurso itinerado', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionRecursoResultado', 'COLUMN', N'TU_CodRecurso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo creado producto de la recepción del recurso', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionRecursoResultado', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único del resultado del recurso', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionRecursoResultado', 'COLUMN', N'TU_CodResultadoRecurso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la itineración del resultado del recurso', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionRecursoResultado', 'COLUMN', N'TU_CodItineracionResultado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionRecursoResultado', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora del registro', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionRecursoResultado', 'COLUMN', N'TF_Particion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código que identifica al Recurso en Gestión, se registra para facilitar las itineraciones entre SIAGPJ y Gestión', 'SCHEMA', N'Historico', 'TABLE', N'ItineracionRecursoResultado', 'COLUMN', N'IDACOREC'
GO
ALTER TABLE [Historico].[ItineracionRecursoResultado] SET (LOCK_ESCALATION = TABLE)
GO

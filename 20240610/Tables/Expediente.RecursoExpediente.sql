SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[RecursoExpediente] (
		[TU_CodRecurso]                  [uniqueidentifier] NOT NULL,
		[TN_CodClaseAsunto]              [int] NOT NULL,
		[TC_CodContextoDestino]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoIntervencion]         [smallint] NOT NULL,
		[TC_NumeroExpediente]            [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodLegajo]                   [uniqueidentifier] NULL,
		[TU_CodResolucion]               [uniqueidentifier] NULL,
		[TF_Fecha_Creacion]              [datetime2](3) NOT NULL,
		[TF_Fecha_Envio]                 [datetime2](3) NULL,
		[TF_Fecha_Recepcion]             [datetime2](3) NULL,
		[TU_CodHistoricoItineracion]     [uniqueidentifier] NULL,
		[TU_CodResultadoRecurso]         [uniqueidentifier] NULL,
		[TN_CodMotivoItineracion]        [smallint] NULL,
		[TN_CodEstadoItineracion]        [smallint] NULL,
		[TC_CodContextoOrigen]           [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[IDACOREC]                       [int] NULL,
		[TF_Particion]                   [datetime2](7) NOT NULL,
		[IDACO]                          [int] NULL,
		CONSTRAINT [PK_RecursoExpediente]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodRecurso])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[RecursoExpediente]
	ADD
	CONSTRAINT [DF__RecursoEx__TF_Pa__68DF1162]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[RecursoExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_RecursoExpediente_ClaseAsunto]
	FOREIGN KEY ([TN_CodClaseAsunto]) REFERENCES [Catalogo].[ClaseAsunto] ([TN_CodClaseAsunto])
ALTER TABLE [Expediente].[RecursoExpediente]
	CHECK CONSTRAINT [FK_RecursoExpediente_ClaseAsunto]

GO
ALTER TABLE [Expediente].[RecursoExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_RecursoExpediente_ContextoDestino]
	FOREIGN KEY ([TC_CodContextoDestino]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[RecursoExpediente]
	CHECK CONSTRAINT [FK_RecursoExpediente_ContextoDestino]

GO
ALTER TABLE [Expediente].[RecursoExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_RecursoExpediente_ContextoOrigen]
	FOREIGN KEY ([TC_CodContextoOrigen]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[RecursoExpediente]
	CHECK CONSTRAINT [FK_RecursoExpediente_ContextoOrigen]

GO
ALTER TABLE [Expediente].[RecursoExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_RecursoExpediente_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[RecursoExpediente]
	CHECK CONSTRAINT [FK_RecursoExpediente_Legajo]

GO
CREATE CLUSTERED INDEX [IX_Expediente_RecursoExpediente_TF_Particion]
	ON [Expediente].[RecursoExpediente] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_RecursoExpediente_Migracion]
	ON [Expediente].[RecursoExpediente] ([TC_CodContextoDestino], [TC_NumeroExpediente], [TF_Fecha_Creacion], [TC_CodContextoOrigen])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Legajo_RecursoExpediente]
	ON [Expediente].[RecursoExpediente] ([TU_CodLegajo])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de cada uno de los recurdos de un expediente', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TU_CodRecurso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clase de asunto relacionado en el recurso', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TN_CodClaseAsunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contexto destino hacía el cual va dirigido el recurso', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TC_CodContextoDestino'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de intervención (Presentación) del recurso', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TN_CodTipoIntervencion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente al cual pertence el recurso', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico del legajo', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Resolución relacionada al recurso', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TU_CodResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación del recurso', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TF_Fecha_Creacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en la que se envió el recurso al contexto destino', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TF_Fecha_Envio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en la que el despacho destino recibe el recurso', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TF_Fecha_Recepcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código relacionada a la itineración , una vez enviado el recurso', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TU_CodHistoricoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Resultado del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TU_CodResultadoRecurso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificar único del motivo de la itineración', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TN_CodMotivoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del estado de la itineración.', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TN_CodEstadoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del contexto del cual procede el recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'TC_CodContextoOrigen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Guarda el ID del Acontecimiento del Recurso', 'SCHEMA', N'Expediente', 'TABLE', N'RecursoExpediente', 'COLUMN', N'IDACO'
GO
ALTER TABLE [Expediente].[RecursoExpediente] SET (LOCK_ESCALATION = TABLE)
GO

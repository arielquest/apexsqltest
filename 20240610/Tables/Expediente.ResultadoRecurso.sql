SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ResultadoRecurso] (
		[TU_CodResultadoRecurso]         [uniqueidentifier] NOT NULL,
		[TU_CodLegajo]                   [uniqueidentifier] NULL,
		[TN_CodResultadoLegajo]          [smallint] NOT NULL,
		[TN_CodEstadoItineracion]        [smallint] NOT NULL,
		[TF_FechaCreacion]               [datetime2](3) NOT NULL,
		[TF_FechaEnvio]                  [datetime2](3) NULL,
		[TF_FechaRecepcion]              [datetime2](3) NULL,
		[TC_CodContextoOrigen]           [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]                  [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodHistoricoItineracion]     [uniqueidentifier] NULL,
		[TN_CodMotivoItineracion]        [smallint] NOT NULL,
		[TF_Particion]                   [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Expediente_ResultadoRecursoArchivos]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodResultadoRecurso])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[ResultadoRecurso]
	ADD
	CONSTRAINT [DF__Resultado__TF_Pa__230BB2F7]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[ResultadoRecurso]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ResultadoRecurso_TC_CodContextoOrigen]
	FOREIGN KEY ([TC_CodContextoOrigen]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[ResultadoRecurso]
	CHECK CONSTRAINT [FK_Expediente_ResultadoRecurso_TC_CodContextoOrigen]

GO
ALTER TABLE [Expediente].[ResultadoRecurso]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ResultadoRecurso_TC_UsuarioRed]
	FOREIGN KEY ([TC_UsuarioRed]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Expediente].[ResultadoRecurso]
	CHECK CONSTRAINT [FK_Expediente_ResultadoRecurso_TC_UsuarioRed]

GO
ALTER TABLE [Expediente].[ResultadoRecurso]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ResultadoRecurso_TN_CodEstadoItineracion]
	FOREIGN KEY ([TN_CodEstadoItineracion]) REFERENCES [Catalogo].[EstadoItineracion] ([TN_CodEstadoItineracion])
ALTER TABLE [Expediente].[ResultadoRecurso]
	CHECK CONSTRAINT [FK_Expediente_ResultadoRecurso_TN_CodEstadoItineracion]

GO
ALTER TABLE [Expediente].[ResultadoRecurso]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ResultadoRecurso_TN_CodMotivoItineracion]
	FOREIGN KEY ([TN_CodMotivoItineracion]) REFERENCES [Catalogo].[MotivoItineracion] ([TN_CodMotivoItineracion])
ALTER TABLE [Expediente].[ResultadoRecurso]
	CHECK CONSTRAINT [FK_Expediente_ResultadoRecurso_TN_CodMotivoItineracion]

GO
ALTER TABLE [Expediente].[ResultadoRecurso]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ResultadoRecurso_TN_CodResultadoLegajo]
	FOREIGN KEY ([TN_CodResultadoLegajo]) REFERENCES [Catalogo].[ResultadoLegajo] ([TN_CodResultadoLegajo])
ALTER TABLE [Expediente].[ResultadoRecurso]
	CHECK CONSTRAINT [FK_Expediente_ResultadoRecurso_TN_CodResultadoLegajo]

GO
ALTER TABLE [Expediente].[ResultadoRecurso]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ResultadoRecurso_TU_CodHistoricoItineracion]
	FOREIGN KEY ([TU_CodHistoricoItineracion]) REFERENCES [Historico].[Itineracion] ([TU_CodHistoricoItineracion])
ALTER TABLE [Expediente].[ResultadoRecurso]
	CHECK CONSTRAINT [FK_Expediente_ResultadoRecurso_TU_CodHistoricoItineracion]

GO
ALTER TABLE [Expediente].[ResultadoRecurso]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ResultadoRecurso_TU_CodLegajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[ResultadoRecurso]
	CHECK CONSTRAINT [FK_Expediente_ResultadoRecurso_TU_CodLegajo]

GO
CREATE CLUSTERED INDEX [IX_Expediente_ResultadoRecurso_TF_Particion]
	ON [Expediente].[ResultadoRecurso] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_ResultadoRecurso_ItineracionRecibir]
	ON [Expediente].[ResultadoRecurso] ([TU_CodHistoricoItineracion])
	INCLUDE ([TU_CodResultadoRecurso], [TU_CodLegajo], [TN_CodResultadoLegajo], [TF_FechaCreacion], [TF_FechaEnvio], [TN_CodMotivoItineracion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Entidad para conservar los resultados asociados a un recurso', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecurso', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del resultado del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecurso', 'COLUMN', N'TU_CodResultadoRecurso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del legajo asociado al resultado (si se trata de un resultado recibido de Gestión, este campo se deja nulo, porque no existe legajo en SIAGPJ).', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecurso', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del resultado de legajo asociado al resultado del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecurso', 'COLUMN', N'TN_CodResultadoLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del estado de itineracion del resultado del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecurso', 'COLUMN', N'TN_CodEstadoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creacion del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecurso', 'COLUMN', N'TF_FechaCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de envió del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecurso', 'COLUMN', N'TF_FechaEnvio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de recepción del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecurso', 'COLUMN', N'TF_FechaRecepcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del contexto origen de donde se recibe el resultado del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecurso', 'COLUMN', N'TC_CodContextoOrigen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Funcionario que resolvio el recurso generando un resultado.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecurso', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor de ID de HI asociado a su correspondiente legajo (recurso o solicitud). Inclusive nulo.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecurso', 'COLUMN', N'TU_CodHistoricoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Se asigna por defecto el motivo de itineración como “Devolución” del catálogo correspondiente', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecurso', 'COLUMN', N'TN_CodMotivoItineracion'
GO
ALTER TABLE [Expediente].[ResultadoRecurso] SET (LOCK_ESCALATION = TABLE)
GO

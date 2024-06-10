SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[ExpedienteMovimientoCirculanteFase] (
		[TU_CodExpedienteFase]                     [uniqueidentifier] NOT NULL,
		[TN_CodExpedienteMovimientoCirculante]     [bigint] NOT NULL,
		[TC_NumeroExpediente]                      [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fecha]                                 [datetime2](7) NOT NULL,
		[TF_Particion]                             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ExpedienteMovimientoCirculanteFase]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodExpedienteFase], [TN_CodExpedienteMovimientoCirculante], [TF_Fecha])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[ExpedienteMovimientoCirculanteFase]
	ADD
	CONSTRAINT [DF_ExpedienteMovimientoCirculanteFase_TF_particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[ExpedienteMovimientoCirculanteFase]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteMovimientoCirculanteFase_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[ExpedienteMovimientoCirculanteFase]
	CHECK CONSTRAINT [FK_ExpedienteMovimientoCirculanteFase_Expediente]

GO
ALTER TABLE [Historico].[ExpedienteMovimientoCirculanteFase]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteMovimientoCirculanteFase_ExpedienteFase]
	FOREIGN KEY ([TU_CodExpedienteFase]) REFERENCES [Historico].[ExpedienteFase] ([TU_CodExpedienteFase])
ALTER TABLE [Historico].[ExpedienteMovimientoCirculanteFase]
	CHECK CONSTRAINT [FK_ExpedienteMovimientoCirculanteFase_ExpedienteFase]

GO
ALTER TABLE [Historico].[ExpedienteMovimientoCirculanteFase]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteMovimientoCirculanteFase_ExpedienteMovimientoCirculante]
	FOREIGN KEY ([TN_CodExpedienteMovimientoCirculante]) REFERENCES [Historico].[ExpedienteMovimientoCirculante] ([TN_CodExpedienteMovimientoCirculante])
ALTER TABLE [Historico].[ExpedienteMovimientoCirculanteFase]
	CHECK CONSTRAINT [FK_ExpedienteMovimientoCirculanteFase_ExpedienteMovimientoCirculante]

GO
CREATE CLUSTERED INDEX [ IX_Historico_ExpedienteMovimientoCirculanteFase_TF_Particion]
	ON [Historico].[ExpedienteMovimientoCirculanteFase] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_por_Carga_1105]
	ON [Historico].[ExpedienteMovimientoCirculanteFase] ([TC_NumeroExpediente])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_ExpedienteMovimientoCirculanteFase]
	ON [Historico].[ExpedienteMovimientoCirculanteFase] ([TU_CodExpedienteFase], [TN_CodExpedienteMovimientoCirculante], [TC_NumeroExpediente], [TF_Fecha])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del historico de fases de la fase asignada al Expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculanteFase', 'COLUMN', N'TU_CodExpedienteFase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del movimiento de circulante donde se obtiene el estado asignado al Expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculanteFase', 'COLUMN', N'TN_CodExpedienteMovimientoCirculante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del expediente al que corresponde el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculanteFase', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se realiza el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculanteFase', 'COLUMN', N'TF_Fecha'
GO
ALTER TABLE [Historico].[ExpedienteMovimientoCirculanteFase] SET (LOCK_ESCALATION = TABLE)
GO

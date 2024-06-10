SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[LegajoMovimientoCirculanteFase] (
		[TU_CodLegajoFase]                     [uniqueidentifier] NOT NULL,
		[TN_CodLegajoMovimientoCirculante]     [bigint] NOT NULL,
		[TC_NumeroExpediente]                  [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodLegajo]                         [uniqueidentifier] NOT NULL,
		[TF_Fecha]                             [datetime2](7) NOT NULL,
		[TF_Particion]                         [datetime2](7) NOT NULL,
		CONSTRAINT [PK_LegajoMovimientoCirculanteFase]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodLegajoFase], [TN_CodLegajoMovimientoCirculante], [TF_Fecha])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[LegajoMovimientoCirculanteFase]
	ADD
	CONSTRAINT [DF_LegajoMovimientoCirculanteFase_TF_Fecha]
	DEFAULT (sysdatetime()) FOR [TF_Fecha]
GO
ALTER TABLE [Historico].[LegajoMovimientoCirculanteFase]
	ADD
	CONSTRAINT [DF_LegajoMovimientoCirculanteFase_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[LegajoMovimientoCirculanteFase]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoMovimientoCirculanteFase_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[LegajoMovimientoCirculanteFase]
	CHECK CONSTRAINT [FK_LegajoMovimientoCirculanteFase_Expediente]

GO
ALTER TABLE [Historico].[LegajoMovimientoCirculanteFase]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoMovimientoCirculanteFase_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Historico].[LegajoMovimientoCirculanteFase]
	CHECK CONSTRAINT [FK_LegajoMovimientoCirculanteFase_Legajo]

GO
ALTER TABLE [Historico].[LegajoMovimientoCirculanteFase]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoMovimientoCirculanteFase_LegajoFase]
	FOREIGN KEY ([TU_CodLegajoFase]) REFERENCES [Historico].[LegajoFase] ([TU_CodLegajoFase])
ALTER TABLE [Historico].[LegajoMovimientoCirculanteFase]
	CHECK CONSTRAINT [FK_LegajoMovimientoCirculanteFase_LegajoFase]

GO
ALTER TABLE [Historico].[LegajoMovimientoCirculanteFase]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoMovimientoCirculanteFase_LegajoMovimientoCirculante]
	FOREIGN KEY ([TN_CodLegajoMovimientoCirculante]) REFERENCES [Historico].[LegajoMovimientoCirculante] ([TN_CodLegajoMovimientoCirculante])
ALTER TABLE [Historico].[LegajoMovimientoCirculanteFase]
	CHECK CONSTRAINT [FK_LegajoMovimientoCirculanteFase_LegajoMovimientoCirculante]

GO
CREATE CLUSTERED INDEX [IX_Historico_LegajoMovimientoCirculanteFase_TF_Particion]
	ON [Historico].[LegajoMovimientoCirculanteFase] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_LegajoMovimientoCirculanteFase]
	ON [Historico].[LegajoMovimientoCirculanteFase] ([TU_CodLegajoFase], [TN_CodLegajoMovimientoCirculante], [TF_Fecha])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del historico de fases de la fase asignada al legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculanteFase', 'COLUMN', N'TU_CodLegajoFase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del movimiento de circulante donde se obtiene el estado asignado al legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculanteFase', 'COLUMN', N'TN_CodLegajoMovimientoCirculante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del expediente al que corresponde el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculanteFase', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo al que corresponde el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculanteFase', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se realiza el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculanteFase', 'COLUMN', N'TF_Fecha'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha utilizada para particionar la tabla por año y optimizar las consultas.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculanteFase', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Historico].[LegajoMovimientoCirculanteFase] SET (LOCK_ESCALATION = TABLE)
GO

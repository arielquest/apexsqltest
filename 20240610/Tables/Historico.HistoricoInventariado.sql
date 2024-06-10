SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[HistoricoInventariado] (
		[TU_CodHistoricoInventariado]     [uniqueidentifier] NOT NULL,
		[TU_CodPeriodo]                   [uniqueidentifier] NOT NULL,
		[TU_CodLegajo]                    [uniqueidentifier] NULL,
		[TC_NumeroExpediente]             [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_DetalleInventariado]          [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaAplicacion]              [datetime2](7) NOT NULL,
		[TC_UsuarioRed]                   [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Actualizacion]                [datetime2](7) NOT NULL,
		[TF_Particion]                    [datetime2](7) NOT NULL,
		CONSTRAINT [PK_HistoricoInventariado]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodHistoricoInventariado])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[HistoricoInventariado]
	ADD
	CONSTRAINT [DF_HistoricoInventariado_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Historico].[HistoricoInventariado]
	ADD
	CONSTRAINT [DF_HistoricoInventariado_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[HistoricoInventariado]
	WITH CHECK
	ADD CONSTRAINT [FK_HistoricoInventariado_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[HistoricoInventariado]
	CHECK CONSTRAINT [FK_HistoricoInventariado_Expediente]

GO
ALTER TABLE [Historico].[HistoricoInventariado]
	WITH CHECK
	ADD CONSTRAINT [FK_HistoricoInventariado_PeriodoInventariado]
	FOREIGN KEY ([TU_CodPeriodo]) REFERENCES [Expediente].[PeriodoInventariado] ([TU_CodPeriodo])
ALTER TABLE [Historico].[HistoricoInventariado]
	CHECK CONSTRAINT [FK_HistoricoInventariado_PeriodoInventariado]

GO
CREATE CLUSTERED INDEX [IX_HistoricoInventariado_Particion]
	ON [Historico].[HistoricoInventariado] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_HistoricoInventariado_TU_CodLegajo_TC_NumeroExpediente]
	ON [Historico].[HistoricoInventariado] ([TU_CodLegajo], [TC_NumeroExpediente])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_HistoricoInventariado_CodLegajo]
	ON [Historico].[HistoricoInventariado] ([TU_CodLegajo])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HistoricoInventariado_CodLegajo_NumeroExpediente]
	ON [Historico].[HistoricoInventariado] ([TU_CodLegajo], [TC_NumeroExpediente])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para manejar el historico del inventariado de los expedientes. ', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoInventariado', NULL, NULL
GO
ALTER TABLE [Historico].[HistoricoInventariado] SET (LOCK_ESCALATION = TABLE)
GO

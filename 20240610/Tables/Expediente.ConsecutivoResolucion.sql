SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ConsecutivoResolucion] (
		[TC_Oficina]           [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_Periodo]           [smallint] NOT NULL,
		[TN_Consecutivo]       [int] NOT NULL,
		[TB_Automatico]        [bit] NOT NULL,
		[TF_Desactivacion]     [datetime2](7) NULL,
		[TF_Actualizacion]     [datetime2](7) NOT NULL,
		[TF_Particion]         [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ConsecutivoSentencia]
		PRIMARY KEY
		NONCLUSTERED
		([TC_Oficina], [TN_Periodo])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[ConsecutivoResolucion]
	ADD
	CONSTRAINT [DF_ConsecutivoSentencia_TF_UltAct]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[ConsecutivoResolucion]
	ADD
	CONSTRAINT [DF__Consecuti__TF_Pa__2BA0F8F8]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
CREATE CLUSTERED INDEX [IX_Expediente_ConsecutivoResolucion_TF_Particion]
	ON [Expediente].[ConsecutivoResolucion] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almance la información de consecutivos de resoluciones.', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoResolucion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la oficina.', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoResolucion', 'COLUMN', N'TC_Oficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Año de cuatro digitos que representa el periodo.', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoResolucion', 'COLUMN', N'TN_Periodo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de consecutivo de asignación de resolución.', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoResolucion', 'COLUMN', N'TN_Consecutivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el consecutivo de la oficina se genera automáticamente o solo manualmente.', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoResolucion', 'COLUMN', N'TB_Automatico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se desactivo el registro.', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoResolucion', 'COLUMN', N'TF_Desactivacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la última actualización del registro.', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoResolucion', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Expediente].[ConsecutivoResolucion] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[CalculoIndexacionTramo] (
		[TU_CodigoTramoIndexacion]       [uniqueidentifier] NOT NULL,
		[TU_CodigoCalculoIndexacion]     [uniqueidentifier] NOT NULL,
		[TF_FechaInicio]                 [datetime2](7) NOT NULL,
		[TF_FechaFinal]                  [datetime2](7) NOT NULL,
		[TN_IndicadorInicial]            [decimal](18, 15) NOT NULL,
		[TN_IndicadorFinal]              [decimal](18, 15) NOT NULL,
		[TN_MontoAIndexar]               [decimal](18, 2) NOT NULL,
		[TN_MontoIndexado]               [decimal](18, 2) NOT NULL,
		[TN_MontoTotalIndexado]          [decimal](18, 2) NOT NULL,
		[TN_MontoAguinaldoIndexado]      [decimal](18, 2) NOT NULL,
		[TF_Particion]                   [datetime2](7) NOT NULL,
		CONSTRAINT [PK_CalculoIndexacionTramo]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodigoTramoIndexacion])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[CalculoIndexacionTramo]
	ADD
	CONSTRAINT [DF__CalculoIn__TF_Pa__4C42D2B4]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[CalculoIndexacionTramo]
	WITH CHECK
	ADD CONSTRAINT [FK_CalculoIndexacionTramo_CalculoIndexacion]
	FOREIGN KEY ([TU_CodigoCalculoIndexacion]) REFERENCES [Expediente].[CalculoIndexacion] ([TU_CodigoCalculoIndexacion])
ALTER TABLE [Expediente].[CalculoIndexacionTramo]
	CHECK CONSTRAINT [FK_CalculoIndexacionTramo_CalculoIndexacion]

GO
CREATE CLUSTERED INDEX [IX_Expediente_CalculoIndexacionTramo_TF_Particion]
	ON [Expediente].[CalculoIndexacionTramo] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene la información de los tramos de un cálculo de indexación', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacionTramo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tramo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacionTramo', 'COLUMN', N'TU_CodigoTramoIndexacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cálculo de indexación', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacionTramo', 'COLUMN', N'TU_CodigoCalculoIndexacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio del tramo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacionTramo', 'COLUMN', N'TF_FechaInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha final del tramo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacionTramo', 'COLUMN', N'TF_FechaFinal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'IPC Inicial del cálculo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacionTramo', 'COLUMN', N'TN_IndicadorInicial'
GO
EXEC sp_addextendedproperty N'MS_Description', N'IPC Final del cálculo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacionTramo', 'COLUMN', N'TN_IndicadorFinal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto que se utilizará en el cálculo de indexación para el tramo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacionTramo', 'COLUMN', N'TN_MontoAIndexar'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto resultado de la indexación', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacionTramo', 'COLUMN', N'TN_MontoIndexado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto total del cálculo de indexación', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacionTramo', 'COLUMN', N'TN_MontoTotalIndexado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aguinaldo calculado del monto indexado', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacionTramo', 'COLUMN', N'TN_MontoAguinaldoIndexado'
GO
ALTER TABLE [Expediente].[CalculoIndexacionTramo] SET (LOCK_ESCALATION = TABLE)
GO

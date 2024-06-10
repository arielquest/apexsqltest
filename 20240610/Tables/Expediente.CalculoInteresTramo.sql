SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[CalculoInteresTramo] (
		[TU_CodigoTramoInteres]       [uniqueidentifier] NOT NULL,
		[TF_FechaInicio]              [datetime2](7) NOT NULL,
		[TF_FechaFinal]               [datetime2](7) NOT NULL,
		[TU_CodigoCalculoInteres]     [uniqueidentifier] NOT NULL,
		[TN_CodigoTasaInteres]        [uniqueidentifier] NULL,
		[TN_ValorTasaInteres]         [decimal](8, 5) NULL,
		[TN_MontoLiquidado]           [decimal](18, 2) NOT NULL,
		[TF_Particion]                [datetime2](7) NOT NULL,
		CONSTRAINT [PK_CalculoInteresTramo]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodigoTramoInteres])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[CalculoInteresTramo]
	ADD
	CONSTRAINT [DF__CalculoIn__TF_Pa__0B342966]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[CalculoInteresTramo]
	WITH CHECK
	ADD CONSTRAINT [FK_CalculoInteresDetalle_CalculoInteres]
	FOREIGN KEY ([TU_CodigoCalculoInteres]) REFERENCES [Expediente].[CalculoInteres] ([TU_CodigoCalculoInteres])
ALTER TABLE [Expediente].[CalculoInteresTramo]
	CHECK CONSTRAINT [FK_CalculoInteresDetalle_CalculoInteres]

GO
ALTER TABLE [Expediente].[CalculoInteresTramo]
	WITH CHECK
	ADD CONSTRAINT [FK_CalculoInteresTramo_TasaInteres]
	FOREIGN KEY ([TN_CodigoTasaInteres]) REFERENCES [Catalogo].[TasaInteres] ([TN_CodigoTasaInteres])
ALTER TABLE [Expediente].[CalculoInteresTramo]
	CHECK CONSTRAINT [FK_CalculoInteresTramo_TasaInteres]

GO
CREATE CLUSTERED INDEX [IX_Expediente_CalculoInteresTramo_TF_Particion]
	ON [Expediente].[CalculoInteresTramo] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene información de los tramos de un cálculo de intereses', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteresTramo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tramo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteresTramo', 'COLUMN', N'TU_CodigoTramoInteres'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha inicio del tramo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteresTramo', 'COLUMN', N'TF_FechaInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha final del tramo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteresTramo', 'COLUMN', N'TF_FechaFinal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de cálculo de interés', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteresTramo', 'COLUMN', N'TU_CodigoCalculoInteres'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la tasa de interés usada en el tramo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteresTramo', 'COLUMN', N'TN_CodigoTasaInteres'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor de la tasa de interés usada para el tramo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteresTramo', 'COLUMN', N'TN_ValorTasaInteres'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto del cálculo de intereses', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteresTramo', 'COLUMN', N'TN_MontoLiquidado'
GO
ALTER TABLE [Expediente].[CalculoInteresTramo] SET (LOCK_ESCALATION = TABLE)
GO

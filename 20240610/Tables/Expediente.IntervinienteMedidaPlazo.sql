SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[IntervinienteMedidaPlazo] (
		[TU_CodPlazo]          [uniqueidentifier] NOT NULL,
		[TU_CodMedida]         [uniqueidentifier] NOT NULL,
		[TF_FechaInicio]       [datetime2](3) NOT NULL,
		[TF_FechaFin]          [datetime2](3) NULL,
		[TF_Actualizacion]     [datetime2](3) NOT NULL,
		[TF_Particion]         [datetime2](7) NOT NULL,
		CONSTRAINT [PK_IntervinienteMedidaPlazo]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodPlazo])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[IntervinienteMedidaPlazo]
	ADD
	CONSTRAINT [DF_IntervinienteMedidaPlazo_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[IntervinienteMedidaPlazo]
	ADD
	CONSTRAINT [DF_IntervinienteMedidaPlazo_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervinienteMedidaPlazo]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteMedidaPlazo_IntervinienteMedida]
	FOREIGN KEY ([TU_CodMedida]) REFERENCES [Expediente].[IntervinienteMedida] ([TU_CodMedida])
ALTER TABLE [Expediente].[IntervinienteMedidaPlazo]
	CHECK CONSTRAINT [FK_IntervinienteMedidaPlazo_IntervinienteMedida]

GO
CREATE CLUSTERED INDEX [IX_Expediente_IntervinienteMedidaPlazo_TF_Particion]
	ON [Expediente].[IntervinienteMedidaPlazo] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para los registros de los plazos del registro de la medida', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedidaPlazo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico del registro del plazo', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedidaPlazo', 'COLUMN', N'TU_CodPlazo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la medida registrada', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedidaPlazo', 'COLUMN', N'TU_CodMedida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio del plazo de la medida', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedidaPlazo', 'COLUMN', N'TF_FechaInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin del plazo de la medida', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedidaPlazo', 'COLUMN', N'TF_FechaFin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización del registro ingresado. Campo necesario para estadisticas de SIGMA', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedidaPlazo', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de registro del dato ingreso. Campo necesario para los indices cluster de la tabla', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedidaPlazo', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Expediente].[IntervinienteMedidaPlazo] SET (LOCK_ESCALATION = TABLE)
GO

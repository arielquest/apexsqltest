SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[IntervinienteMedidaResolucion] (
		[TU_CodResolucion]     [uniqueidentifier] NOT NULL,
		[TU_CodMedida]         [uniqueidentifier] NOT NULL,
		[TF_Actualizacion]     [datetime2](3) NOT NULL,
		[TF_Particion]         [datetime2](7) NOT NULL,
		CONSTRAINT [PK_IntervinienteMedidaResolucion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodResolucion], [TU_CodMedida])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[IntervinienteMedidaResolucion]
	ADD
	CONSTRAINT [DF_IntervinienteMedidaResolucion_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[IntervinienteMedidaResolucion]
	ADD
	CONSTRAINT [DF_IntervinienteMedidaResolucion_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervinienteMedidaResolucion]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteMedidaResolucion_IntervinienteMedida]
	FOREIGN KEY ([TU_CodMedida]) REFERENCES [Expediente].[IntervinienteMedida] ([TU_CodMedida])
ALTER TABLE [Expediente].[IntervinienteMedidaResolucion]
	CHECK CONSTRAINT [FK_IntervinienteMedidaResolucion_IntervinienteMedida]

GO
ALTER TABLE [Expediente].[IntervinienteMedidaResolucion]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteMedidaResolucion_Resolucion]
	FOREIGN KEY ([TU_CodResolucion]) REFERENCES [Expediente].[Resolucion] ([TU_CodResolucion])
ALTER TABLE [Expediente].[IntervinienteMedidaResolucion]
	CHECK CONSTRAINT [FK_IntervinienteMedidaResolucion_Resolucion]

GO
CREATE CLUSTERED INDEX [IX_Expediente_IntervinienteMedidaResolucion_TF_Particion]
	ON [Expediente].[IntervinienteMedidaResolucion] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para los registros de las resoluciones asociadas al registro de la medida', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedidaResolucion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico del archivo de la resolución', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedidaResolucion', 'COLUMN', N'TU_CodResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del registro de la medida', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedidaResolucion', 'COLUMN', N'TU_CodMedida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización del registro ingresado. Campo necesario para estadisticas de SIGMA', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedidaResolucion', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de registro del dato ingreso. Campo necesario para los indices cluster de la tabla', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedidaResolucion', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Expediente].[IntervinienteMedidaResolucion] SET (LOCK_ESCALATION = TABLE)
GO

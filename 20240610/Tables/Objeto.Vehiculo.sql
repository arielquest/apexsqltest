SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Objeto].[Vehiculo] (
		[TU_CodObjeto]             [uniqueidentifier] NOT NULL,
		[TN_CodTipoVehiculo]       [smallint] NOT NULL,
		[TN_CodTipoPlaca]          [smallint] NOT NULL,
		[TC_Placa]                 [varchar](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodEstiloVehiculo]     [smallint] NOT NULL,
		[TN_CodMarcaVehiculo]      [smallint] NOT NULL,
		[TC_Cilindraje]            [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Anno]                  [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Cubicaje]              [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_NumeroMotor]           [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroChasis]          [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroVin]             [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		CONSTRAINT [UQ__Vehiculo__9E0B21239F6CF477]
		UNIQUE
		NONCLUSTERED
		([TU_CodObjeto])
		ON [PRIMARY],
		CONSTRAINT [PK_Vehiculo]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodObjeto])
	ON [PRIMARY]
) ON [ObjetoPS] ([TF_Particion])
GO
ALTER TABLE [Objeto].[Vehiculo]
	ADD
	CONSTRAINT [DF__Vehiculo__TF_Par__66F6C8F0]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Objeto].[Vehiculo]
	WITH CHECK
	ADD CONSTRAINT [FK_Vehiculo_EstiloVehiculo]
	FOREIGN KEY ([TN_CodEstiloVehiculo]) REFERENCES [Catalogo].[EstiloVehiculo] ([TN_CodEstiloVehiculo])
ALTER TABLE [Objeto].[Vehiculo]
	CHECK CONSTRAINT [FK_Vehiculo_EstiloVehiculo]

GO
ALTER TABLE [Objeto].[Vehiculo]
	WITH CHECK
	ADD CONSTRAINT [FK_Vehiculo_MarcaVehiculo]
	FOREIGN KEY ([TN_CodMarcaVehiculo]) REFERENCES [Catalogo].[MarcaVehiculo] ([TN_CodMarcaVehiculo])
ALTER TABLE [Objeto].[Vehiculo]
	CHECK CONSTRAINT [FK_Vehiculo_MarcaVehiculo]

GO
ALTER TABLE [Objeto].[Vehiculo]
	WITH CHECK
	ADD CONSTRAINT [FK_Vehiculo_Objeto]
	FOREIGN KEY ([TU_CodObjeto]) REFERENCES [Objeto].[Objeto] ([TU_CodObjeto])
ALTER TABLE [Objeto].[Vehiculo]
	CHECK CONSTRAINT [FK_Vehiculo_Objeto]

GO
ALTER TABLE [Objeto].[Vehiculo]
	WITH CHECK
	ADD CONSTRAINT [FK_Vehiculo_TipoPlaca]
	FOREIGN KEY ([TN_CodTipoPlaca]) REFERENCES [Catalogo].[TipoPlaca] ([TN_CodTipoPlaca])
ALTER TABLE [Objeto].[Vehiculo]
	CHECK CONSTRAINT [FK_Vehiculo_TipoPlaca]

GO
ALTER TABLE [Objeto].[Vehiculo]
	WITH CHECK
	ADD CONSTRAINT [FK_Vehiculo_TipoVehiculo]
	FOREIGN KEY ([TN_CodTipoVehiculo]) REFERENCES [Catalogo].[TipoVehiculo] ([TN_CodTipoVehiculo])
ALTER TABLE [Objeto].[Vehiculo]
	CHECK CONSTRAINT [FK_Vehiculo_TipoVehiculo]

GO
CREATE CLUSTERED INDEX [IX_Objeto_Vehiculo_TF_Particion]
	ON [Objeto].[Vehiculo] ([TF_Particion])
	ON [ObjetoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta tabla va a contener toda la informacion del objeto cuando el objeto sea de tipo vehículo', 'SCHEMA', N'Objeto', 'TABLE', N'Vehiculo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el codigo del objeto hace referencia a la tabla de Objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Vehiculo', 'COLUMN', N'TU_CodObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el tipo de vehículo,', 'SCHEMA', N'Objeto', 'TABLE', N'Vehiculo', 'COLUMN', N'TN_CodTipoVehiculo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el tipo de placa del vehículo,', 'SCHEMA', N'Objeto', 'TABLE', N'Vehiculo', 'COLUMN', N'TN_CodTipoPlaca'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el numero de placa del vehículo', 'SCHEMA', N'Objeto', 'TABLE', N'Vehiculo', 'COLUMN', N'TC_Placa'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el estilo de vehículo, hace referencia a la tabla de estilo de vehiculo', 'SCHEMA', N'Objeto', 'TABLE', N'Vehiculo', 'COLUMN', N'TN_CodEstiloVehiculo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener la marca del vehículo, hace referencia a la tabla de marca de vehículo', 'SCHEMA', N'Objeto', 'TABLE', N'Vehiculo', 'COLUMN', N'TN_CodMarcaVehiculo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el cilindraje del vehículo', 'SCHEMA', N'Objeto', 'TABLE', N'Vehiculo', 'COLUMN', N'TC_Cilindraje'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el anno del vehículo', 'SCHEMA', N'Objeto', 'TABLE', N'Vehiculo', 'COLUMN', N'TC_Anno'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo opcional que va a contener el cubicaje el vehículo', 'SCHEMA', N'Objeto', 'TABLE', N'Vehiculo', 'COLUMN', N'TC_Cubicaje'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el numero de motor del vehículo', 'SCHEMA', N'Objeto', 'TABLE', N'Vehiculo', 'COLUMN', N'TC_NumeroMotor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el numero de Chasis del vehículo', 'SCHEMA', N'Objeto', 'TABLE', N'Vehiculo', 'COLUMN', N'TC_NumeroChasis'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el numero de vin del vehículo', 'SCHEMA', N'Objeto', 'TABLE', N'Vehiculo', 'COLUMN', N'TC_NumeroVin'
GO
ALTER TABLE [Objeto].[Vehiculo] SET (LOCK_ESCALATION = TABLE)
GO

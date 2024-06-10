SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Objeto].[BienInmueble] (
		[TU_CodObjeto]         [uniqueidentifier] NOT NULL,
		[TC_NumeroFinca]       [varchar](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodProvincia]      [smallint] NOT NULL,
		[TN_CodCanton]         [smallint] NOT NULL,
		[TN_CodTipoMedida]     [smallint] NULL,
		[TF_Particion]         [datetime2](7) NOT NULL,
		CONSTRAINT [UQ__BienInmu__9E0B212388308649]
		UNIQUE
		NONCLUSTERED
		([TU_CodObjeto])
		ON [PRIMARY],
		CONSTRAINT [PK_BienInmueble]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodObjeto])
	ON [PRIMARY]
) ON [ObjetoPS] ([TF_Particion])
GO
ALTER TABLE [Objeto].[BienInmueble]
	ADD
	CONSTRAINT [DF__BienInmue__TF_Pa__1C5EB568]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Objeto].[BienInmueble]
	WITH CHECK
	ADD CONSTRAINT [FK_BienInmueble_Canton]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton]) REFERENCES [Catalogo].[Canton] ([TN_CodProvincia], [TN_CodCanton])
ALTER TABLE [Objeto].[BienInmueble]
	CHECK CONSTRAINT [FK_BienInmueble_Canton]

GO
ALTER TABLE [Objeto].[BienInmueble]
	WITH CHECK
	ADD CONSTRAINT [FK_BienInmueble_Objeto]
	FOREIGN KEY ([TU_CodObjeto]) REFERENCES [Objeto].[Objeto] ([TU_CodObjeto])
ALTER TABLE [Objeto].[BienInmueble]
	CHECK CONSTRAINT [FK_BienInmueble_Objeto]

GO
ALTER TABLE [Objeto].[BienInmueble]
	WITH CHECK
	ADD CONSTRAINT [FK_BienInmueble_TipoMedidaCautelar]
	FOREIGN KEY ([TN_CodTipoMedida]) REFERENCES [Catalogo].[TipoMedida] ([TN_CodTipoMedida])
ALTER TABLE [Objeto].[BienInmueble]
	CHECK CONSTRAINT [FK_BienInmueble_TipoMedidaCautelar]

GO
CREATE CLUSTERED INDEX [IX_Objeto_BienInmueble_TF_Particion]
	ON [Objeto].[BienInmueble] ([TF_Particion])
	ON [ObjetoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el codigo del objeto hace referencia a la tabla de BienInmueble', 'SCHEMA', N'Objeto', 'TABLE', N'BienInmueble', 'COLUMN', N'TU_CodObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el número de finca,', 'SCHEMA', N'Objeto', 'TABLE', N'BienInmueble', 'COLUMN', N'TC_NumeroFinca'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el código de provincia asociado,', 'SCHEMA', N'Objeto', 'TABLE', N'BienInmueble', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el código de cantón asociado,', 'SCHEMA', N'Objeto', 'TABLE', N'BienInmueble', 'COLUMN', N'TN_CodCanton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo opcional que va a definir el tipo de medida cautelar asociado al bien inmueble', 'SCHEMA', N'Objeto', 'TABLE', N'BienInmueble', 'COLUMN', N'TN_CodTipoMedida'
GO
ALTER TABLE [Objeto].[BienInmueble] SET (LOCK_ESCALATION = TABLE)
GO

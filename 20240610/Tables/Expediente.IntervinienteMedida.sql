SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[IntervinienteMedida] (
		[TU_CodMedida]            [uniqueidentifier] NOT NULL,
		[TC_CodContexto]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodInterviniente]     [uniqueidentifier] NOT NULL,
		[TN_CodTipoMedida]        [smallint] NOT NULL,
		[TN_CodEstado]            [smallint] NOT NULL,
		[TF_FechaEstado]          [datetime2](3) NOT NULL,
		[TC_Observaciones]        [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]        [datetime2](3) NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_IntervinienteMedida]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodMedida])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[IntervinienteMedida]
	ADD
	CONSTRAINT [DF_IntervinienteMedida_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[IntervinienteMedida]
	ADD
	CONSTRAINT [DF_IntervinienteMedida_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervinienteMedida]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteMedida_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[IntervinienteMedida]
	CHECK CONSTRAINT [FK_IntervinienteMedida_Contexto]

GO
ALTER TABLE [Expediente].[IntervinienteMedida]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteMedida_EstadoMedida]
	FOREIGN KEY ([TN_CodEstado]) REFERENCES [Catalogo].[EstadoMedida] ([TN_CodEstado])
ALTER TABLE [Expediente].[IntervinienteMedida]
	CHECK CONSTRAINT [FK_IntervinienteMedida_EstadoMedida]

GO
ALTER TABLE [Expediente].[IntervinienteMedida]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteMedida_Interviniente]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Interviniente] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[IntervinienteMedida]
	CHECK CONSTRAINT [FK_IntervinienteMedida_Interviniente]

GO
ALTER TABLE [Expediente].[IntervinienteMedida]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteMedida_TipoMedidaCautelar]
	FOREIGN KEY ([TN_CodTipoMedida]) REFERENCES [Catalogo].[TipoMedida] ([TN_CodTipoMedida])
ALTER TABLE [Expediente].[IntervinienteMedida]
	CHECK CONSTRAINT [FK_IntervinienteMedida_TipoMedidaCautelar]

GO
CREATE CLUSTERED INDEX [IX_Expediente_IntervinienteMedida_TF_Particion]
	ON [Expediente].[IntervinienteMedida] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para el registros de la medida', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedida', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico para los registros de las medidas', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedida', 'COLUMN', N'TU_CodMedida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del contexto asociado a la medida', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedida', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico del interviniente asociado a la Medida', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedida', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del tipo de medida asociado a la medida', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedida', 'COLUMN', N'TN_CodTipoMedida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del Estado de la medida asociado a la medida', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedida', 'COLUMN', N'TN_CodEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha asociada al estado de la medida seleccionado al registro de la medida', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedida', 'COLUMN', N'TF_FechaEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion del registro de la medida, este campo no es obligatorio', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedida', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización del registro ingresado. Campo necesario para estadisticas de SIGMA', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedida', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de registro del dato ingreso. Campo necesario para los indices cluster de la tabla', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteMedida', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Expediente].[IntervinienteMedida] SET (LOCK_ESCALATION = TABLE)
GO

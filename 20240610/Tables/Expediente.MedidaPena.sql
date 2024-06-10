SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[MedidaPena] (
		[TU_CodMedidaPena]                           [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]                        [uniqueidentifier] NOT NULL,
		[TU_CodResultadoResolucionInterviniente]     [uniqueidentifier] NULL,
		[TN_CodDelito]                               [int] NOT NULL,
		[TN_CodTipoPena]                             [smallint] NULL,
		[TN_CodTipoMedida]                           [smallint] NULL,
		[TC_CodMedidaPena]                           [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodSituacionLibertad]                    [smallint] NULL,
		[TF_SituacionLibertad]                       [datetime2](7) NULL,
		[TF_FechaImposicion]                         [datetime2](7) NOT NULL,
		[TF_Vencimiento]                             [datetime2](7) NOT NULL,
		[TF_Revocatoria]                             [datetime2](7) NULL,
		[TF_Revision]                                [datetime2](7) NULL,
		[TB_ControlFirma]                            [bit] NOT NULL,
		[TC_Observaciones]                           [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]                           [datetime2](7) NOT NULL,
		[TF_Particion]                               [datetime2](7) NOT NULL,
		CONSTRAINT [PK_MedidaPena]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodMedidaPena])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[MedidaPena]
	ADD
	CONSTRAINT [CK_MedidaPena]
	CHECK
	([TC_CodMedidaPena]='M' OR [TC_CodMedidaPena]='P')
GO
ALTER TABLE [Expediente].[MedidaPena]
CHECK CONSTRAINT [CK_MedidaPena]
GO
ALTER TABLE [Expediente].[MedidaPena]
	ADD
	CONSTRAINT [DF_MedidaPena_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[MedidaPena]
	ADD
	CONSTRAINT [DF__MedidaPen__TF_Pa__7ECE5281]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[MedidaPena]
	WITH CHECK
	ADD CONSTRAINT [FK_MedidaPena_IntervinienteDelito]
	FOREIGN KEY ([TU_CodInterviniente], [TN_CodDelito]) REFERENCES [Expediente].[IntervinienteDelito] ([TU_CodInterviniente], [TN_CodDelito])
ALTER TABLE [Expediente].[MedidaPena]
	CHECK CONSTRAINT [FK_MedidaPena_IntervinienteDelito]

GO
ALTER TABLE [Expediente].[MedidaPena]
	WITH CHECK
	ADD CONSTRAINT [FK_MedidaPena_SituacionLibertad]
	FOREIGN KEY ([TN_CodSituacionLibertad]) REFERENCES [Catalogo].[SituacionLibertad] ([TN_CodSituacionLibertad])
ALTER TABLE [Expediente].[MedidaPena]
	CHECK CONSTRAINT [FK_MedidaPena_SituacionLibertad]

GO
ALTER TABLE [Expediente].[MedidaPena]
	WITH CHECK
	ADD CONSTRAINT [FK_MedidaPena_TipoMedidaCautelar]
	FOREIGN KEY ([TN_CodTipoMedida]) REFERENCES [Catalogo].[TipoMedida] ([TN_CodTipoMedida])
ALTER TABLE [Expediente].[MedidaPena]
	CHECK CONSTRAINT [FK_MedidaPena_TipoMedidaCautelar]

GO
ALTER TABLE [Expediente].[MedidaPena]
	WITH CHECK
	ADD CONSTRAINT [FK_MedidaPena_TipoPena]
	FOREIGN KEY ([TN_CodTipoPena]) REFERENCES [Catalogo].[TipoPena] ([TN_CodTipoPena])
ALTER TABLE [Expediente].[MedidaPena]
	CHECK CONSTRAINT [FK_MedidaPena_TipoPena]

GO
CREATE CLUSTERED INDEX [IX_Expediente_MedidaPena_TF_Particion]
	ON [Expediente].[MedidaPena] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de medidas cautelares y penas del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la medida o pena.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TU_CodMedidaPena'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la resolución asociada.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TU_CodResultadoResolucionInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del delito.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TN_CodDelito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de pena.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TN_CodTipoPena'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo medida cuatelar.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TN_CodTipoMedida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'indica si es una medida cautelar (M) o una pena (P).', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TC_CodMedidaPena'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la situación de libertad.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TN_CodSituacionLibertad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la situación de libertad.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TF_SituacionLibertad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de imposición.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TF_FechaImposicion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de vencimiento.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TF_Vencimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de revocatoria.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TF_Revocatoria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la revisión.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TF_Revision'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si se requiere control de firmas para la medida cautelar.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TB_ControlFirma'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones adicionales.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'MedidaPena', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Expediente].[MedidaPena] SET (LOCK_ESCALATION = TABLE)
GO

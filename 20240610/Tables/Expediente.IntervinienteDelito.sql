SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[IntervinienteDelito] (
		[TU_CodInterviniente]         [uniqueidentifier] NOT NULL,
		[TN_CodDelito]                [int] NOT NULL,
		[TF_CalificacionDelito]       [datetime2](7) NOT NULL,
		[TB_CrimenOrganizado]         [bit] NOT NULL,
		[TF_Hecho]                    [datetime2](7) NOT NULL,
		[TF_Prescripcion]             [datetime2](7) NULL,
		[TB_Indagado]                 [bit] NOT NULL,
		[TN_CodMotivoAbsolutoria]     [smallint] NULL,
		[TF_Actualizacion]            [datetime2](7) NOT NULL,
		[TF_Particion]                [datetime2](7) NOT NULL,
		CONSTRAINT [PK_IntervinienteDelito_1]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodInterviniente], [TN_CodDelito])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[IntervinienteDelito]
	ADD
	CONSTRAINT [DF_IntervinienteDelito_Indagado]
	DEFAULT ((0)) FOR [TB_Indagado]
GO
ALTER TABLE [Expediente].[IntervinienteDelito]
	ADD
	CONSTRAINT [DF_IntervinienteDelito_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[IntervinienteDelito]
	ADD
	CONSTRAINT [DF__Intervini__TF_Pa__198248BD]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervinienteDelito]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteDelito_Interviniente]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Interviniente] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[IntervinienteDelito]
	CHECK CONSTRAINT [FK_IntervinienteDelito_Interviniente]

GO
CREATE CLUSTERED INDEX [IX_Expediente_IntervinienteDelito_TF_Particion]
	ON [Expediente].[IntervinienteDelito] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de los delitos asociados a los intervinientes.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDelito', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDelito', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del delito asociado al interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDelito', 'COLUMN', N'TN_CodDelito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de calificación del delito.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDelito', 'COLUMN', N'TF_CalificacionDelito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el delito es de crimen organizado.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDelito', 'COLUMN', N'TB_CrimenOrganizado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de los hechos.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDelito', 'COLUMN', N'TF_Hecho'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de prescripción del delito.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDelito', 'COLUMN', N'TF_Prescripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador de si el interviniente ya fue indagado.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDelito', 'COLUMN', N'TB_Indagado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de absolutoria.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDelito', 'COLUMN', N'TN_CodMotivoAbsolutoria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDelito', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Expediente].[IntervinienteDelito] SET (LOCK_ESCALATION = TABLE)
GO

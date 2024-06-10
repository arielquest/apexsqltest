SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[IntervinienteDiscapacidad] (
		[TU_CodInterviniente]     [uniqueidentifier] NOT NULL,
		[TN_CodDiscapacidad]      [smallint] NOT NULL,
		[TF_Actualizacion]        [datetime2](7) NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_IntervinienteDiscapacidad]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodInterviniente], [TN_CodDiscapacidad])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[IntervinienteDiscapacidad]
	ADD
	CONSTRAINT [DF_IntervinienteDiscapacidad_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[IntervinienteDiscapacidad]
	ADD
	CONSTRAINT [DF__Intervini__TF_Pa__1A766CF6]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervinienteDiscapacidad]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteDiscapacidad_Discapacidad]
	FOREIGN KEY ([TN_CodDiscapacidad]) REFERENCES [Catalogo].[Discapacidad] ([TN_CodDiscapacidad])
ALTER TABLE [Expediente].[IntervinienteDiscapacidad]
	CHECK CONSTRAINT [FK_IntervinienteDiscapacidad_Discapacidad]

GO
ALTER TABLE [Expediente].[IntervinienteDiscapacidad]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteDiscapacidad_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[IntervinienteDiscapacidad]
	CHECK CONSTRAINT [FK_IntervinienteDiscapacidad_Intervencion]

GO
CREATE CLUSTERED INDEX [IX_Expediente_IntervinienteDiscapacidad_TF_Particion]
	ON [Expediente].[IntervinienteDiscapacidad] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de las discapacidades asociadas a los intervinientes.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDiscapacidad', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDiscapacidad', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la discapacidad.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDiscapacidad', 'COLUMN', N'TN_CodDiscapacidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDiscapacidad', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Expediente].[IntervinienteDiscapacidad] SET (LOCK_ESCALATION = TABLE)
GO

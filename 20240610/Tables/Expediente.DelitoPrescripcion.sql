SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[DelitoPrescripcion] (
		[TU_CodDelitoPrescripcion]         [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]              [uniqueidentifier] NOT NULL,
		[TN_CodDelito]                     [int] NOT NULL,
		[TF_Prescribe]                     [datetime2](7) NULL,
		[TN_CodInterrupcion]               [smallint] NULL,
		[TN_CodSuspensionPrescripcion]     [smallint] NULL,
		[TF_FechaActo]                     [datetime2](7) NOT NULL,
		[TC_UsuarioRed]                    [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Actualizacion]                 [datetime2](7) NOT NULL,
		[TF_Particion]                     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_DelitoPrescripcion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodDelitoPrescripcion])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[DelitoPrescripcion]
	ADD
	CONSTRAINT [DF_DelitoPrescripcion_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[DelitoPrescripcion]
	ADD
	CONSTRAINT [DF__DelitoPre__TF_Pa__772D30B9]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[DelitoPrescripcion]
	WITH CHECK
	ADD CONSTRAINT [FK_DelitoPrescripcion_Funcionario]
	FOREIGN KEY ([TC_UsuarioRed]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Expediente].[DelitoPrescripcion]
	CHECK CONSTRAINT [FK_DelitoPrescripcion_Funcionario]

GO
ALTER TABLE [Expediente].[DelitoPrescripcion]
	WITH CHECK
	ADD CONSTRAINT [FK_DelitoPrescripcion_Interviniente]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Interviniente] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[DelitoPrescripcion]
	CHECK CONSTRAINT [FK_DelitoPrescripcion_Interviniente]

GO
CREATE CLUSTERED INDEX [IX_Expediente_DelitoPrescripcion_TF_Particion]
	ON [Expediente].[DelitoPrescripcion] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_DelitoPrescripcion_Migracion]
	ON [Expediente].[DelitoPrescripcion] ([TU_CodInterviniente], [TN_CodDelito], [TF_Prescribe])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de la prescripción de delitos del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'DelitoPrescripcion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la prescripción del delito.', 'SCHEMA', N'Expediente', 'TABLE', N'DelitoPrescripcion', 'COLUMN', N'TU_CodDelitoPrescripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'DelitoPrescripcion', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del delito.', 'SCHEMA', N'Expediente', 'TABLE', N'DelitoPrescripcion', 'COLUMN', N'TN_CodDelito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica la fecha en que prescribe el delito.', 'SCHEMA', N'Expediente', 'TABLE', N'DelitoPrescripcion', 'COLUMN', N'TF_Prescribe'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica tipo acto interruptor de la prescripción.', 'SCHEMA', N'Expediente', 'TABLE', N'DelitoPrescripcion', 'COLUMN', N'TN_CodInterrupcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el tipo de suspención de la prescripción.', 'SCHEMA', N'Expediente', 'TABLE', N'DelitoPrescripcion', 'COLUMN', N'TN_CodSuspensionPrescripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha del acto de prescripción.', 'SCHEMA', N'Expediente', 'TABLE', N'DelitoPrescripcion', 'COLUMN', N'TF_FechaActo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que realiza el trámite.', 'SCHEMA', N'Expediente', 'TABLE', N'DelitoPrescripcion', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la última actualización del registro.', 'SCHEMA', N'Expediente', 'TABLE', N'DelitoPrescripcion', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Expediente].[DelitoPrescripcion] SET (LOCK_ESCALATION = TABLE)
GO

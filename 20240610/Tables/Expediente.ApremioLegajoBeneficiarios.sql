SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[ApremioLegajoBeneficiarios] (
		[TU_CodApremio]           [uniqueidentifier] NOT NULL,
		[TU_CodLegajo]            [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]     [uniqueidentifier] NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ApremioLegajoBeneficiarios]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodApremio], [TU_CodLegajo], [TU_CodInterviniente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[ApremioLegajoBeneficiarios]
	ADD
	CONSTRAINT [DF_ApremioLegajoBeneficiarios_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[ApremioLegajoBeneficiarios]
	WITH CHECK
	ADD CONSTRAINT [FK_ApremioLegajoBeneficiarios_ApremioLegajo]
	FOREIGN KEY ([TU_CodApremio], [TU_CodLegajo]) REFERENCES [Expediente].[ApremioLegajo] ([TU_CodApremio], [TU_CodLegajo])
ALTER TABLE [Expediente].[ApremioLegajoBeneficiarios]
	CHECK CONSTRAINT [FK_ApremioLegajoBeneficiarios_ApremioLegajo]

GO
ALTER TABLE [Expediente].[ApremioLegajoBeneficiarios]
	WITH CHECK
	ADD CONSTRAINT [FK_ApremioLegajoBeneficiarios_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[ApremioLegajoBeneficiarios]
	CHECK CONSTRAINT [FK_ApremioLegajoBeneficiarios_Intervencion]

GO
ALTER TABLE [Expediente].[ApremioLegajoBeneficiarios]
	WITH CHECK
	ADD CONSTRAINT [FK_ApremioLegajoBeneficiarios_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[ApremioLegajoBeneficiarios]
	CHECK CONSTRAINT [FK_ApremioLegajoBeneficiarios_Legajo]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Permite registrar los beneficiarios de un legajo de apremio.', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajoBeneficiarios', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del apremio al que esta ligado el beneficiario.', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajoBeneficiarios', 'COLUMN', N'TU_CodApremio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo al que esta ligado el beneficiario.', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajoBeneficiarios', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del interviniente asociado como beneficiario al apremio y legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajoBeneficiarios', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de partición de la tabla que permitira separar los registros anualizados.', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajoBeneficiarios', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Expediente].[ApremioLegajoBeneficiarios] SET (LOCK_ESCALATION = TABLE)
GO

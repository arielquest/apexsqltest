SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[IntervinienteVulnerabilidad] (
		[TU_CodInterviniente]      [uniqueidentifier] NOT NULL,
		[TN_CodVulnerabilidad]     [smallint] NOT NULL,
		[TF_Actualizacion]         [datetime2](7) NOT NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_IntervinienteVulnerabilidad]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodInterviniente], [TN_CodVulnerabilidad])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[IntervinienteVulnerabilidad]
	ADD
	CONSTRAINT [DF_IntervinienteVunerabilidad_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[IntervinienteVulnerabilidad]
	ADD
	CONSTRAINT [DF__Intervini__TF_Pa__29B8B086]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervinienteVulnerabilidad]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteVulnerabilidad_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[IntervinienteVulnerabilidad]
	CHECK CONSTRAINT [FK_IntervinienteVulnerabilidad_Intervencion]

GO
ALTER TABLE [Expediente].[IntervinienteVulnerabilidad]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteVulnerabilidad_Vulnerabilidad]
	FOREIGN KEY ([TN_CodVulnerabilidad]) REFERENCES [Catalogo].[Vulnerabilidad] ([TN_CodVulnerabilidad])
ALTER TABLE [Expediente].[IntervinienteVulnerabilidad]
	CHECK CONSTRAINT [FK_IntervinienteVulnerabilidad_Vulnerabilidad]

GO
CREATE CLUSTERED INDEX [IX_Expediente_IntervinienteVulnerabilidad_TF_Particion]
	ON [Expediente].[IntervinienteVulnerabilidad] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de las vulnerabilidades del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVulnerabilidad', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVulnerabilidad', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de vulnerabilidad.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVulnerabilidad', 'COLUMN', N'TN_CodVulnerabilidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteVulnerabilidad', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Expediente].[IntervinienteVulnerabilidad] SET (LOCK_ESCALATION = TABLE)
GO

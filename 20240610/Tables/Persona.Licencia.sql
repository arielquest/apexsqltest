SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Persona].[Licencia] (
		[TU_CodPersona]          [uniqueidentifier] NOT NULL,
		[TN_CodTipoLicencia]     [smallint] NOT NULL,
		[TF_Caducidad]           [datetime2](7) NOT NULL,
		[TF_Expedicion]          [datetime2](7) NOT NULL,
		[TF_Tramite]             [datetime2](7) NOT NULL,
		[TF_Actualizacion]       [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Licencia_1]
		PRIMARY KEY
		CLUSTERED
		([TU_CodPersona], [TN_CodTipoLicencia], [TF_Caducidad])
	ON [FG_Persona]
) ON [FG_Persona]
GO
ALTER TABLE [Persona].[Licencia]
	ADD
	CONSTRAINT [DF_Licencia_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Persona].[Licencia]
	WITH CHECK
	ADD CONSTRAINT [FK_Licencia_PersonaFisica]
	FOREIGN KEY ([TU_CodPersona]) REFERENCES [Persona].[PersonaFisica] ([TU_CodPersona])
ALTER TABLE [Persona].[Licencia]
	CHECK CONSTRAINT [FK_Licencia_PersonaFisica]

GO
ALTER TABLE [Persona].[Licencia]
	WITH CHECK
	ADD CONSTRAINT [FK_Licencia_TipoLicencia]
	FOREIGN KEY ([TN_CodTipoLicencia]) REFERENCES [Catalogo].[TipoLicencia] ([TN_CodTipoLicencia])
ALTER TABLE [Persona].[Licencia]
	CHECK CONSTRAINT [FK_Licencia_TipoLicencia]

GO
CREATE NONCLUSTERED INDEX [IX_Persona_Licencia_Migracion]
	ON [Persona].[Licencia] ([TU_CodPersona], [TN_CodTipoLicencia], [TF_Caducidad])
	ON [FG_Persona]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena las licencias de conducir de la persona.', 'SCHEMA', N'Persona', 'TABLE', N'Licencia', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la persona.', 'SCHEMA', N'Persona', 'TABLE', N'Licencia', 'COLUMN', N'TU_CodPersona'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de licencia.', 'SCHEMA', N'Persona', 'TABLE', N'Licencia', 'COLUMN', N'TN_CodTipoLicencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de caducidad de la licencia.', 'SCHEMA', N'Persona', 'TABLE', N'Licencia', 'COLUMN', N'TF_Caducidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de expedición de la licencia.', 'SCHEMA', N'Persona', 'TABLE', N'Licencia', 'COLUMN', N'TF_Expedicion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha del trámite.', 'SCHEMA', N'Persona', 'TABLE', N'Licencia', 'COLUMN', N'TF_Tramite'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización para SIGMA.', 'SCHEMA', N'Persona', 'TABLE', N'Licencia', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Persona].[Licencia] SET (LOCK_ESCALATION = TABLE)
GO

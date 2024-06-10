SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Persona].[PersonaJuridica] (
		[TU_CodPersona]              [uniqueidentifier] NOT NULL,
		[TC_Nombre]                  [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NombreComercial]         [varchar](200) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodTipoEntidad]          [smallint] NOT NULL,
		[TF_Actualizacion]           [datetime2](7) NOT NULL,
		[TC_NombreRepresentante]     [varchar](60) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CargoRepresentante]      [varchar](15) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_PersonaJuridica_1]
		PRIMARY KEY
		CLUSTERED
		([TU_CodPersona])
	ON [FG_Persona]
) ON [FG_Persona]
GO
ALTER TABLE [Persona].[PersonaJuridica]
	ADD
	CONSTRAINT [CK_PersonaJuridica]
	CHECK
	([Persona].[FN_ValidarPersonaFisicaJuridica]([TU_CodPersona],'J')=(1))
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valida que la persona jurídica ya exista en la tabla Persona.Persona.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaJuridica', 'CONSTRAINT', N'CK_PersonaJuridica'
GO
ALTER TABLE [Persona].[PersonaJuridica]
CHECK CONSTRAINT [CK_PersonaJuridica]
GO
ALTER TABLE [Persona].[PersonaJuridica]
	ADD
	CONSTRAINT [DF_PersonaJuridica_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Persona].[PersonaJuridica]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonaJuridica_Persona]
	FOREIGN KEY ([TU_CodPersona]) REFERENCES [Persona].[Persona] ([TU_CodPersona])
ALTER TABLE [Persona].[PersonaJuridica]
	CHECK CONSTRAINT [FK_PersonaJuridica_Persona]

GO
ALTER TABLE [Persona].[PersonaJuridica]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonaJuridica_TipoEntidadJuridica]
	FOREIGN KEY ([TN_CodTipoEntidad]) REFERENCES [Catalogo].[TipoEntidadJuridica] ([TN_CodTipoEntidad])
ALTER TABLE [Persona].[PersonaJuridica]
	CHECK CONSTRAINT [FK_PersonaJuridica_TipoEntidadJuridica]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los datos de las personas jurídicas.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaJuridica', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único de la persona.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaJuridica', 'COLUMN', N'TU_CodPersona'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la persona jurídica.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaJuridica', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre comercial de la persona jurídica.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaJuridica', 'COLUMN', N'TC_NombreComercial'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de entidad jurídica.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaJuridica', 'COLUMN', N'TN_CodTipoEntidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización del registro para SIGMA.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaJuridica', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que conserva el nombre del representante de la entidad juridica equivalente a NOMRESP de Gestión', 'SCHEMA', N'Persona', 'TABLE', N'PersonaJuridica', 'COLUMN', N'TC_NombreRepresentante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que conserva el cargo del representante de la entidad juridica equivalente a CARRESP de Gestión', 'SCHEMA', N'Persona', 'TABLE', N'PersonaJuridica', 'COLUMN', N'TC_CargoRepresentante'
GO
ALTER TABLE [Persona].[PersonaJuridica] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Persona].[Profesional] (
		[TU_CodPersona]        [uniqueidentifier] NOT NULL,
		[TF_Actualizacion]     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Profesional]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodPersona])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Persona].[Profesional]
	ADD
	CONSTRAINT [DF_Profesional_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Persona].[Profesional]
	WITH CHECK
	ADD CONSTRAINT [FK_Profesional_PersonaFisica]
	FOREIGN KEY ([TU_CodPersona]) REFERENCES [Persona].[PersonaFisica] ([TU_CodPersona])
ALTER TABLE [Persona].[Profesional]
	CHECK CONSTRAINT [FK_Profesional_PersonaFisica]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena las personas que son profesionales.', 'SCHEMA', N'Persona', 'TABLE', N'Profesional', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la persona que es profesional.', 'SCHEMA', N'Persona', 'TABLE', N'Profesional', 'COLUMN', N'TU_CodPersona'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización para SIGMA.', 'SCHEMA', N'Persona', 'TABLE', N'Profesional', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Persona].[Profesional] SET (LOCK_ESCALATION = TABLE)
GO

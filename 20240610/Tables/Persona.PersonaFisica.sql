SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Persona].[PersonaFisica] (
		[TU_CodPersona]          [uniqueidentifier] NOT NULL,
		[TC_Nombre]              [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_PrimerApellido]      [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_SegundoApellido]     [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaNacimiento]     [datetime2](7) NULL,
		[TC_LugarNacimiento]     [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaDefuncion]      [datetime2](7) NULL,
		[TC_LugarDefuncion]      [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_NombreMadre]         [varchar](80) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_NombrePadre]         [varchar](80) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodEtnia]            [smallint] NULL,
		[TF_Actualizacion]       [datetime2](7) NOT NULL,
		[TC_Carne]               [varchar](25) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_EsIgnorado]          [bit] NOT NULL,
		[TI_CantidadHijos]       [int] NULL,
		[TC_CodSexo]             [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodEstadoCivil]      [smallint] NULL,
		[TN_Salario]             [decimal](18, 2) NULL,
		CONSTRAINT [PK_PersonaFisica_1]
		PRIMARY KEY
		CLUSTERED
		([TU_CodPersona])
	ON [FG_Persona]
) ON [FG_Persona]
GO
ALTER TABLE [Persona].[PersonaFisica]
	ADD
	CONSTRAINT [CK_PersonaFisica]
	CHECK
	([Persona].[FN_ValidarPersonaFisicaJuridica]([TU_CodPersona],'F')=(1))
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valida que la persona física ya exista en la tabla Persona.Persona.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'CONSTRAINT', N'CK_PersonaFisica'
GO
ALTER TABLE [Persona].[PersonaFisica]
CHECK CONSTRAINT [CK_PersonaFisica]
GO
ALTER TABLE [Persona].[PersonaFisica]
	ADD
	CONSTRAINT [DF_PersonaFisica_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Persona].[PersonaFisica]
	ADD
	CONSTRAINT [DF__PersonaFi__TB_Es__664CBD7A]
	DEFAULT ((0)) FOR [TB_EsIgnorado]
GO
ALTER TABLE [Persona].[PersonaFisica]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonaFisica_Persona]
	FOREIGN KEY ([TU_CodPersona]) REFERENCES [Persona].[Persona] ([TU_CodPersona])
ALTER TABLE [Persona].[PersonaFisica]
	CHECK CONSTRAINT [FK_PersonaFisica_Persona]

GO
ALTER TABLE [Persona].[PersonaFisica]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonaFisica_Sexo]
	FOREIGN KEY ([TC_CodSexo]) REFERENCES [Catalogo].[Sexo] ([TC_CodSexo])
ALTER TABLE [Persona].[PersonaFisica]
	CHECK CONSTRAINT [FK_PersonaFisica_Sexo]

GO
ALTER TABLE [Persona].[PersonaFisica]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonaFisica_EstadoCivil]
	FOREIGN KEY ([TN_CodEstadoCivil]) REFERENCES [Catalogo].[EstadoCivil] ([TN_CodEstadoCivil])
ALTER TABLE [Persona].[PersonaFisica]
	CHECK CONSTRAINT [FK_PersonaFisica_EstadoCivil]

GO
ALTER TABLE [Persona].[PersonaFisica]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonaFisica_Etnia]
	FOREIGN KEY ([TN_CodEtnia]) REFERENCES [Catalogo].[Etnia] ([TN_CodEtnia])
ALTER TABLE [Persona].[PersonaFisica]
	CHECK CONSTRAINT [FK_PersonaFisica_Etnia]

GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Codigo]
	ON [Persona].[PersonaFisica] ([TU_CodPersona])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-NombreCompleto]
	ON [Persona].[PersonaFisica] ([TC_Nombre], [TC_PrimerApellido], [TC_SegundoApellido])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena información de las personas físicas.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único de la persona.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TU_CodPersona'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la persona.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primer apellido de la persona.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TC_PrimerApellido'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Segundo apellido de la persona.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TC_SegundoApellido'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de nacimiento.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TF_FechaNacimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lugar de nacimiento.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TC_LugarNacimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de defunción de la persona.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TF_FechaDefuncion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lugar de defunción.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TC_LugarDefuncion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre completo de la madre.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TC_NombreMadre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre completo del padre.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TC_NombrePadre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de etnia.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TN_CodEtnia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización del registro para SIGMA.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Carné del colegio de abogados.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TC_Carne'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la persona se registra como ignorada.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TB_EsIgnorado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cantidad de hijos de la persona incluida', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TI_CantidadHijos'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del sexo.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TC_CodSexo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de estado civil.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TN_CodEstadoCivil'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Salario Aproximado.', 'SCHEMA', N'Persona', 'TABLE', N'PersonaFisica', 'COLUMN', N'TN_Salario'
GO
ALTER TABLE [Persona].[PersonaFisica] SET (LOCK_ESCALATION = TABLE)
GO

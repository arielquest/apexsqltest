SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Persona].[Persona] (
		[TU_CodPersona]                [uniqueidentifier] NOT NULL,
		[TC_CodTipoPersona]            [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoIdentificacion]     [smallint] NULL,
		[TC_Identificacion]            [varchar](21) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]             [datetime2](7) NOT NULL,
		[TC_Origen]                    [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[IDINT]                        [int] NULL,
		CONSTRAINT [PK_Persona]
		PRIMARY KEY
		CLUSTERED
		([TU_CodPersona])
	ON [FG_Persona]
) ON [FG_Persona]
GO
ALTER TABLE [Persona].[Persona]
	ADD
	CONSTRAINT [CK_Persona]
	CHECK
	([Persona].[FN_ValidarPersona]([TU_CodPersona],[TC_CodTipoPersona])=(1) AND ([TC_CodTipoPersona]='J' OR [TC_CodTipoPersona]='F'))
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valida que el código de tipo de persona sea correcto y que la persona no exista en la tabla Persona.PersonaFisica o Persona.PersonaJuridica según corresponda.', 'SCHEMA', N'Persona', 'TABLE', N'Persona', 'CONSTRAINT', N'CK_Persona'
GO
ALTER TABLE [Persona].[Persona]
CHECK CONSTRAINT [CK_Persona]
GO
ALTER TABLE [Persona].[Persona]
	ADD
	CONSTRAINT [CK_Persona_Origen]
	CHECK
	([TC_Origen]='M' OR [TC_Origen]='T' OR [TC_Origen]='E' OR [TC_Origen]='P' OR [TC_Origen]='D')
GO
ALTER TABLE [Persona].[Persona]
CHECK CONSTRAINT [CK_Persona_Origen]
GO
ALTER TABLE [Persona].[Persona]
	ADD
	CONSTRAINT [DF_Persona_TC_CodTipoPersona]
	DEFAULT ('F') FOR [TC_CodTipoPersona]
GO
ALTER TABLE [Persona].[Persona]
	ADD
	CONSTRAINT [DF_Persona_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Persona].[Persona]
	ADD
	CONSTRAINT [DF__Persona__TC_Orig__44C1AC7D]
	DEFAULT ('M') FOR [TC_Origen]
GO
ALTER TABLE [Persona].[Persona]
	WITH CHECK
	ADD CONSTRAINT [FK_Persona_TipoIdentificacion]
	FOREIGN KEY ([TN_CodTipoIdentificacion]) REFERENCES [Catalogo].[TipoIdentificacion] ([TN_CodTipoIdentificacion])
ALTER TABLE [Persona].[Persona]
	CHECK CONSTRAINT [FK_Persona_TipoIdentificacion]

GO
CREATE NONCLUSTERED INDEX [IDX_PERSONA_MIGRACION_IDINT]
	ON [Persona].[Persona] ([IDINT])
	ON [FG_Persona]
GO
CREATE NONCLUSTERED INDEX [INDEX_CodTipoIdentificacion_Origen]
	ON [Persona].[Persona] ([TC_Identificacion])
	INCLUDE ([TN_CodTipoIdentificacion], [TC_Origen])
	ON [FG_Persona]
GO
CREATE NONCLUSTERED INDEX [IX_Persona_Identificacion]
	ON [Persona].[Persona] ([TC_Identificacion])
	ON [FG_Persona]
GO
CREATE NONCLUSTERED INDEX [IX_Persona_Persona_Migracion]
	ON [Persona].[Persona] ([TC_CodTipoPersona], [TN_CodTipoIdentificacion], [TC_Identificacion], [TC_Origen], [IDINT])
	ON [FG_Persona]
GO
CREATE NONCLUSTERED INDEX [IX_Persona_Persona_Migracion_ConsultaValidacion]
	ON [Persona].[Persona] ([TC_CodTipoPersona], [TC_Identificacion], [IDINT])
	INCLUDE ([TN_CodTipoIdentificacion])
	ON [FG_Persona]
GO
CREATE NONCLUSTERED INDEX [IX_Persona_Persona_Migracion2]
	ON [Persona].[Persona] ([TC_CodTipoPersona], [TC_Origen], [IDINT])
	ON [FG_Persona]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información común de las personas, tanto física como jurídica.', 'SCHEMA', N'Persona', 'TABLE', N'Persona', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código ínico de la persona.', 'SCHEMA', N'Persona', 'TABLE', N'Persona', 'COLUMN', N'TU_CodPersona'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de persona (F=Física o J=Jurídica).', 'SCHEMA', N'Persona', 'TABLE', N'Persona', 'COLUMN', N'TC_CodTipoPersona'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de identificación.', 'SCHEMA', N'Persona', 'TABLE', N'Persona', 'COLUMN', N'TN_CodTipoIdentificacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificación de la persona.', 'SCHEMA', N'Persona', 'TABLE', N'Persona', 'COLUMN', N'TC_Identificacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualizacion para SIGMA.', 'SCHEMA', N'Persona', 'TABLE', N'Persona', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Señala el origen de dónde se tomaron los datos de la persona. Valor ‘M’: Migrado, valor ‘T’: Tribunal Supremo de Elecciones, valor ‘E’: Dirección General de Migración y Extranjería, valor ‘P’: Registro Nacional de la Propiedad, valor ‘D’: Digitado.', 'SCHEMA', N'Persona', 'TABLE', N'Persona', 'COLUMN', N'TC_Origen'
GO
ALTER TABLE [Persona].[Persona] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Facilitador].[Facilitador] (
		[TN_CodFacilitador]     [int] NOT NULL,
		[TN_CodEscolaridad]     [smallint] NOT NULL,
		[TN_CodProfesion]       [smallint] NOT NULL,
		[TC_Observaciones]      [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Email]              [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodContexto]        [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_Activo]             [bit] NOT NULL,
		[TU_CodPersona]         [uniqueidentifier] NOT NULL,
		[TF_Actualizacion]      [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Facilitador]
		PRIMARY KEY
		CLUSTERED
		([TN_CodFacilitador])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Facilitador].[Facilitador]
	ADD
	CONSTRAINT [DF_Facilitador_TN_CodFacilitador]
	DEFAULT (NEXT VALUE FOR [Facilitador].[SecuenciaFacilitadorJudicial]) FOR [TN_CodFacilitador]
GO
ALTER TABLE [Facilitador].[Facilitador]
	WITH CHECK
	ADD CONSTRAINT [FK_Facilitador_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Facilitador].[Facilitador]
	CHECK CONSTRAINT [FK_Facilitador_Contexto]

GO
ALTER TABLE [Facilitador].[Facilitador]
	WITH CHECK
	ADD CONSTRAINT [FK_Facilitador_Escolaridad]
	FOREIGN KEY ([TN_CodEscolaridad]) REFERENCES [Catalogo].[Escolaridad] ([TN_CodEscolaridad])
ALTER TABLE [Facilitador].[Facilitador]
	CHECK CONSTRAINT [FK_Facilitador_Escolaridad]

GO
ALTER TABLE [Facilitador].[Facilitador]
	WITH CHECK
	ADD CONSTRAINT [FK_Facilitador_Profesion]
	FOREIGN KEY ([TN_CodProfesion]) REFERENCES [Catalogo].[Profesion] ([TN_CodProfesion])
ALTER TABLE [Facilitador].[Facilitador]
	CHECK CONSTRAINT [FK_Facilitador_Profesion]

GO
ALTER TABLE [Facilitador].[Facilitador]
	WITH CHECK
	ADD CONSTRAINT [FK_Persona_Facilitador]
	FOREIGN KEY ([TU_CodPersona]) REFERENCES [Persona].[Persona] ([TU_CodPersona])
ALTER TABLE [Facilitador].[Facilitador]
	CHECK CONSTRAINT [FK_Persona_Facilitador]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para registrar los facilitadores judiciales del sistema', 'SCHEMA', N'Facilitador', 'TABLE', N'Facilitador', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la escolaridad del facilitador judicial', 'SCHEMA', N'Facilitador', 'TABLE', N'Facilitador', 'COLUMN', N'TN_CodEscolaridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la profesión del facilitador judicial', 'SCHEMA', N'Facilitador', 'TABLE', N'Facilitador', 'COLUMN', N'TN_CodProfesion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones del facilitador judicial', 'SCHEMA', N'Facilitador', 'TABLE', N'Facilitador', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Correo electrónico del facilitador judicial', 'SCHEMA', N'Facilitador', 'TABLE', N'Facilitador', 'COLUMN', N'TC_Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contexto asociado al facilitador judicial', 'SCHEMA', N'Facilitador', 'TABLE', N'Facilitador', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el facilitador judicial se encuentra activo o inactivo actualmente', 'SCHEMA', N'Facilitador', 'TABLE', N'Facilitador', 'COLUMN', N'TB_Activo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el registro de la persona a la cual se encuentra asociada el facilitador', 'SCHEMA', N'Facilitador', 'TABLE', N'Facilitador', 'COLUMN', N'TU_CodPersona'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica cuando se hizo la actualizacion de algun registro', 'SCHEMA', N'Facilitador', 'TABLE', N'Facilitador', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Facilitador].[Facilitador] SET (LOCK_ESCALATION = TABLE)
GO

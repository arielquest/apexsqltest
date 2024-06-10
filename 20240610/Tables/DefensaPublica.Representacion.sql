SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [DefensaPublica].[Representacion] (
		[TU_CodRepresentacion]       [uniqueidentifier] NOT NULL,
		[TU_CodPersona]              [uniqueidentifier] NOT NULL,
		[TC_NRD]                     [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Creacion]                [datetime2](7) NOT NULL,
		[TC_LugarTrabajo]            [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Descripcion]             [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodSituacionLaboral]     [smallint] NULL,
		[TC_Alias]                   [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodPais]                 [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodEstadoCivil]          [smallint] NULL,
		[TC_CodSexo]                 [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodProfesion]            [smallint] NULL,
		[TN_CodEscolaridad]          [smallint] NULL,
		[TF_Actualizacion]           [datetime2](7) NOT NULL,
		[TU_CodInterviniente]        [uniqueidentifier] NULL,
		[TF_Particion]               [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Representacion_1]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodRepresentacion])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[Representacion]
	ADD
	CONSTRAINT [DF__Represent__TF_Ac__544C7222]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [DefensaPublica].[Representacion]
	ADD
	CONSTRAINT [DF__Represent__TF_Pa__623213D3]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[Representacion]
	WITH CHECK
	ADD CONSTRAINT [FK_DefensaPublicaRepresentacion_ExpedienteIntervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [DefensaPublica].[Representacion]
	CHECK CONSTRAINT [FK_DefensaPublicaRepresentacion_ExpedienteIntervencion]

GO
ALTER TABLE [DefensaPublica].[Representacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Representacion_Carpeta]
	FOREIGN KEY ([TC_NRD]) REFERENCES [DefensaPublica].[Carpeta] ([TC_NRD])
ALTER TABLE [DefensaPublica].[Representacion]
	CHECK CONSTRAINT [FK_Representacion_Carpeta]

GO
ALTER TABLE [DefensaPublica].[Representacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Representacion_Persona]
	FOREIGN KEY ([TU_CodPersona]) REFERENCES [Persona].[Persona] ([TU_CodPersona])
ALTER TABLE [DefensaPublica].[Representacion]
	CHECK CONSTRAINT [FK_Representacion_Persona]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_Representacion_TF_Particion]
	ON [DefensaPublica].[Representacion] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico de la representacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TU_CodRepresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'identificador unico de la persona', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TU_CodPersona'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de referencia de la defensa', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TC_NRD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creacion de la representcion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TF_Creacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lugar de trabajo', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TC_LugarTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Obervaciones de la representacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la situacion laboral actual', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TN_CodSituacionLaboral'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Alias de la personas representada.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TC_Alias'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del pais de nacimiento', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TC_CodPais'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Estado civil', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TN_CodEstadoCivil'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del genero sexual', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TC_CodSexo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la profesion actual', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TN_CodProfesion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la escolaridad', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TN_CodEscolaridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la ultima actualziacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del interviniente al cual se relaciona la representación.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Representacion', 'COLUMN', N'TU_CodInterviniente'
GO
ALTER TABLE [DefensaPublica].[Representacion] SET (LOCK_ESCALATION = TABLE)
GO

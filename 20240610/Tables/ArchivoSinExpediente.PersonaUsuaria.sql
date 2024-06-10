SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [ArchivoSinExpediente].[PersonaUsuaria] (
		[TU_CodArchivo]                [uniqueidentifier] NOT NULL,
		[TN_CodTipoIdentificacion]     [smallint] NOT NULL,
		[TC_Identificacion]            [varchar](21) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Nombre]                    [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_PrimerApellido]            [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_SegundoApellido]           [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_TipoFirma]                 [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_DescripcionFirma]          [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Firma]                     [datetime2](7) NULL,
		[TF_Particion]                 [datetime2](7) NOT NULL,
		[DOCSINNUE]                    [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_ArchivoSinExpedientePersonaUsuaria]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodArchivo], [TN_CodTipoIdentificacion], [TC_Identificacion])
	ON [PRIMARY]
) ON [ArchivoPS] ([TF_Particion])
GO
ALTER TABLE [ArchivoSinExpediente].[PersonaUsuaria]
	ADD
	CONSTRAINT [CK_PersonaUsuaria_TipoFirma]
	CHECK
	([TC_TipoFirma]='D' OR [TC_TipoFirma]='H' OR [TC_TipoFirma]='U' OR [TC_TipoFirma]='N')
GO
ALTER TABLE [ArchivoSinExpediente].[PersonaUsuaria]
CHECK CONSTRAINT [CK_PersonaUsuaria_TipoFirma]
GO
ALTER TABLE [ArchivoSinExpediente].[PersonaUsuaria]
	ADD
	CONSTRAINT [DF__PersonaUs__TF_Pa__4E2B1B26]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [ArchivoSinExpediente].[PersonaUsuaria]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoSinExpedientePersonaUsuaria_ArchivoSinExpediente]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [ArchivoSinExpediente].[ArchivoSinExpediente] ([TU_CodArchivo])
ALTER TABLE [ArchivoSinExpediente].[PersonaUsuaria]
	CHECK CONSTRAINT [FK_ArchivoSinExpedientePersonaUsuaria_ArchivoSinExpediente]

GO
ALTER TABLE [ArchivoSinExpediente].[PersonaUsuaria]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoSinExpedientePersonaUsuaria_TipoIdentificacion]
	FOREIGN KEY ([TN_CodTipoIdentificacion]) REFERENCES [Catalogo].[TipoIdentificacion] ([TN_CodTipoIdentificacion])
ALTER TABLE [ArchivoSinExpediente].[PersonaUsuaria]
	CHECK CONSTRAINT [FK_ArchivoSinExpedientePersonaUsuaria_TipoIdentificacion]

GO
CREATE CLUSTERED INDEX [IX_ArchivoSinExpediente_PersonaUsuaria_TF_Particion]
	ON [ArchivoSinExpediente].[PersonaUsuaria] ([TF_Particion])
	ON [ArchivoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de las personas usuarias que presentan un documento sin expediente.', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'PersonaUsuaria', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del archivo.', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'PersonaUsuaria', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de identificación de la persona usuaria.', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'PersonaUsuaria', 'COLUMN', N'TN_CodTipoIdentificacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de identificación de la persona usuaria.', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'PersonaUsuaria', 'COLUMN', N'TC_Identificacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la persona usuaria', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'PersonaUsuaria', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primer apellido de la persona usuaria', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'PersonaUsuaria', 'COLUMN', N'TC_PrimerApellido'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Segundo apellido de la persona usuaria', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'PersonaUsuaria', 'COLUMN', N'TC_SegundoApellido'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de firma que utiliza la persona usuaria. Valor ‘D’: Firma digital, valor ‘H’: Firma holográfica, valor ‘U’: Huella dactilar, valor ‘N’: No firma.', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'PersonaUsuaria', 'COLUMN', N'TC_TipoFirma'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Texto que debe aparecer al pie de la firma de la persona usuaria en el documento.', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'PersonaUsuaria', 'COLUMN', N'TC_DescripcionFirma'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora en que la persona usuaria ha firmado el documento.', 'SCHEMA', N'ArchivoSinExpediente', 'TABLE', N'PersonaUsuaria', 'COLUMN', N'TF_Firma'
GO
ALTER TABLE [ArchivoSinExpediente].[PersonaUsuaria] SET (LOCK_ESCALATION = TABLE)
GO

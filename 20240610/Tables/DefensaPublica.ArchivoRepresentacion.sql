SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [DefensaPublica].[ArchivoRepresentacion] (
		[TU_CodArchivo]            [uniqueidentifier] NOT NULL,
		[TU_CodRepresentacion]     [uniqueidentifier] NOT NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ArchivoRepresentacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodArchivo], [TU_CodRepresentacion])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[ArchivoRepresentacion]
	ADD
	CONSTRAINT [DF__ArchivoRepresentacionParticion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[ArchivoRepresentacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoRepresentacion_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [DefensaPublica].[ArchivoRepresentacion]
	CHECK CONSTRAINT [FK_ArchivoRepresentacion_Archivo]

GO
ALTER TABLE [DefensaPublica].[ArchivoRepresentacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ArchivoRepresentacion_Representacion]
	FOREIGN KEY ([TU_CodRepresentacion]) REFERENCES [DefensaPublica].[Representacion] ([TU_CodRepresentacion])
ALTER TABLE [DefensaPublica].[ArchivoRepresentacion]
	CHECK CONSTRAINT [FK_ArchivoRepresentacion_Representacion]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_ArchivoRepresentacion_TF_Particion]
	ON [DefensaPublica].[ArchivoRepresentacion] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de los archivos asociados a la representación.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ArchivoRepresentacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del archivo.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ArchivoRepresentacion', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de representación al que pertenece el archivo.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'ArchivoRepresentacion', 'COLUMN', N'TU_CodRepresentacion'
GO
ALTER TABLE [DefensaPublica].[ArchivoRepresentacion] SET (LOCK_ESCALATION = TABLE)
GO

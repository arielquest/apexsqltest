SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ResultadoRecursosArchivos] (
		[TU_CodResultadoRecurso]     [uniqueidentifier] NOT NULL,
		[TU_CodArchivo]              [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]        [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]               [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Expediente_ResultadoRecursosArchivos]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodResultadoRecurso], [TU_CodArchivo], [TC_NumeroExpediente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[ResultadoRecursosArchivos]
	ADD
	CONSTRAINT [DF__Resultado__TF_Pa__5A90F20B]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[ResultadoRecursosArchivos]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ResultadoRecursoArchivos_TU_CodArchivo_TN_Numero_Expediente]
	FOREIGN KEY ([TU_CodArchivo], [TC_NumeroExpediente]) REFERENCES [Expediente].[ArchivoExpediente] ([TU_CodArchivo], [TC_NumeroExpediente])
ALTER TABLE [Expediente].[ResultadoRecursosArchivos]
	CHECK CONSTRAINT [FK_Expediente_ResultadoRecursoArchivos_TU_CodArchivo_TN_Numero_Expediente]

GO
ALTER TABLE [Expediente].[ResultadoRecursosArchivos]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ResultadoRecursoArchivos_TU_CodResultadoRecurso]
	FOREIGN KEY ([TU_CodResultadoRecurso]) REFERENCES [Expediente].[ResultadoRecurso] ([TU_CodResultadoRecurso])
ALTER TABLE [Expediente].[ResultadoRecursosArchivos]
	CHECK CONSTRAINT [FK_Expediente_ResultadoRecursoArchivos_TU_CodResultadoRecurso]

GO
CREATE CLUSTERED INDEX [IX_Expediente_ResultadoRecursosArchivos_TF_Particion]
	ON [Expediente].[ResultadoRecursosArchivos] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Entidad para conservar los documentos asociados a un resultado de un recurso', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecursosArchivos', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del resultado del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecursosArchivos', 'COLUMN', N'TU_CodResultadoRecurso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del archivo del expediente asociado al resultado del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecursosArchivos', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero del expediente asociado al archivo asociado al resultado del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecursosArchivos', 'COLUMN', N'TC_NumeroExpediente'
GO
ALTER TABLE [Expediente].[ResultadoRecursosArchivos] SET (LOCK_ESCALATION = TABLE)
GO

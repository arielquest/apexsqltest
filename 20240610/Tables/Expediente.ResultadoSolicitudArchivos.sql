SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ResultadoSolicitudArchivos] (
		[TU_CodResultadoSolicitud]     [uniqueidentifier] NOT NULL,
		[TU_CodArchivo]                [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]          [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]                 [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Expediente_ResultadoSolicitudArchivos]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodResultadoSolicitud], [TU_CodArchivo], [TC_NumeroExpediente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[ResultadoSolicitudArchivos]
	ADD
	CONSTRAINT [DF__Resultado__TF_Pa__066F7449]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[ResultadoSolicitudArchivos]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ResultadoSolicitudArchivos_TU_CodArchivo_TN_Numero_Expediente]
	FOREIGN KEY ([TU_CodArchivo], [TC_NumeroExpediente]) REFERENCES [Expediente].[ArchivoExpediente] ([TU_CodArchivo], [TC_NumeroExpediente])
ALTER TABLE [Expediente].[ResultadoSolicitudArchivos]
	CHECK CONSTRAINT [FK_Expediente_ResultadoSolicitudArchivos_TU_CodArchivo_TN_Numero_Expediente]

GO
ALTER TABLE [Expediente].[ResultadoSolicitudArchivos]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ResultadoSolicitudArchivos_TU_CodResultadoSolicitud]
	FOREIGN KEY ([TU_CodResultadoSolicitud]) REFERENCES [Expediente].[ResultadoSolicitud] ([TU_CodResultadoSolicitud])
ALTER TABLE [Expediente].[ResultadoSolicitudArchivos]
	CHECK CONSTRAINT [FK_Expediente_ResultadoSolicitudArchivos_TU_CodResultadoSolicitud]

GO
CREATE CLUSTERED INDEX [IX_Expediente_ResultadoSolicitudArchivos_TF_Particion]
	ON [Expediente].[ResultadoSolicitudArchivos] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Entidad para conservar los documentos asociados a un resultado de una solicitud', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoSolicitudArchivos', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del resultado del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoSolicitudArchivos', 'COLUMN', N'TU_CodResultadoSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del archivo del expediente asociado al resultado del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoSolicitudArchivos', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero del expediente asociado al archivo asociado al resultado del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoSolicitudArchivos', 'COLUMN', N'TC_NumeroExpediente'
GO
ALTER TABLE [Expediente].[ResultadoSolicitudArchivos] SET (LOCK_ESCALATION = TABLE)
GO

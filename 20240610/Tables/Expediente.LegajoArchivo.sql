SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[LegajoArchivo] (
		[TU_CodArchivo]           [uniqueidentifier] NOT NULL,
		[TU_CodLegajo]            [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]     [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]            [date] NOT NULL,
		CONSTRAINT [PK_ExpedienteArchivoLegajo]
		PRIMARY KEY
		CLUSTERED
		([TU_CodArchivo], [TU_CodLegajo], [TC_NumeroExpediente])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Expediente].[LegajoArchivo]
	ADD
	CONSTRAINT [DF__LegajoArc__TF_Pa__4F1F3F5F]
	DEFAULT (getdate()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[LegajoArchivo]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_LegajoArchivo_Archivo_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Expediente].[LegajoArchivo]
	CHECK CONSTRAINT [FK_Expediente_LegajoArchivo_Archivo_Archivo]

GO
ALTER TABLE [Expediente].[LegajoArchivo]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_LegajoArchivo_Expediente_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[LegajoArchivo]
	CHECK CONSTRAINT [FK_Expediente_LegajoArchivo_Expediente_Expediente]

GO
ALTER TABLE [Expediente].[LegajoArchivo]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_LegajoArchivo_Expediente_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[LegajoArchivo]
	CHECK CONSTRAINT [FK_Expediente_LegajoArchivo_Expediente_Legajo]

GO
CREATE NONCLUSTERED INDEX [IX_LegajoArchivo_ExpedienteDetalle]
	ON [Expediente].[LegajoArchivo] ([TU_CodLegajo])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de los archivos asociados al legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoArchivo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del archivo.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoArchivo', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoArchivo', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoArchivo', 'COLUMN', N'TC_NumeroExpediente'
GO
ALTER TABLE [Expediente].[LegajoArchivo] SET (LOCK_ESCALATION = TABLE)
GO

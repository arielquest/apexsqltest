SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[DocumentoFirmante] (
		[TU_CodArchivo]                     [uniqueidentifier] NOT NULL,
		[TU_FirmadoPor]                     [uniqueidentifier] NOT NULL,
		[TN_Orden]                          [tinyint] NOT NULL,
		[TF_FechaAplicado]                  [datetime2](7) NOT NULL,
		[TU_CodAsignacionFirmado]           [uniqueidentifier] NULL,
		[TB_Salva]                          [bit] NULL,
		[TB_Nota]                           [bit] NULL,
		[TC_JustificacionSalvaVotoNota]     [varchar](max) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                      [datetime2](7) NOT NULL,
		CONSTRAINT [PK_DocumentoFirmante]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodArchivo], [TU_FirmadoPor])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[DocumentoFirmante]
	ADD
	CONSTRAINT [DF__Documento__TF_Pa__599CCDD2]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[DocumentoFirmante]
	WITH CHECK
	ADD CONSTRAINT [FK_DocumentoFirmante_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Historico].[DocumentoFirmante]
	CHECK CONSTRAINT [FK_DocumentoFirmante_Archivo]

GO
ALTER TABLE [Historico].[DocumentoFirmante]
	WITH CHECK
	ADD CONSTRAINT [FK_DocumentoFirmante_AsignacionFirmado]
	FOREIGN KEY ([TU_CodAsignacionFirmado]) REFERENCES [Archivo].[AsignacionFirmado] ([TU_CodAsignacionFirmado])
ALTER TABLE [Historico].[DocumentoFirmante]
	CHECK CONSTRAINT [FK_DocumentoFirmante_AsignacionFirmado]

GO
ALTER TABLE [Historico].[DocumentoFirmante]
	WITH CHECK
	ADD CONSTRAINT [FK_DocumentoFirmante_PuestoTrabajoFuncionario]
	FOREIGN KEY ([TU_FirmadoPor]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Historico].[DocumentoFirmante]
	CHECK CONSTRAINT [FK_DocumentoFirmante_PuestoTrabajoFuncionario]

GO
CREATE CLUSTERED INDEX [IX_Historico_DocumentoFirmante_TF_Particion]
	ON [Historico].[DocumentoFirmante] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla historica de documentos firmados por funcionarios', 'SCHEMA', N'Historico', 'TABLE', N'DocumentoFirmante', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo llave del archivo que se firmó', 'SCHEMA', N'Historico', 'TABLE', N'DocumentoFirmante', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que firmo el documento', 'SCHEMA', N'Historico', 'TABLE', N'DocumentoFirmante', 'COLUMN', N'TU_FirmadoPor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Orden en que firmó el documento', 'SCHEMA', N'Historico', 'TABLE', N'DocumentoFirmante', 'COLUMN', N'TN_Orden'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de aplicado el firmado del documento', 'SCHEMA', N'Historico', 'TABLE', N'DocumentoFirmante', 'COLUMN', N'TF_FechaAplicado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'LLave de asignación relacionada solo si tiene asignación', 'SCHEMA', N'Historico', 'TABLE', N'DocumentoFirmante', 'COLUMN', N'TU_CodAsignacionFirmado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'indica si salva el voto.', 'SCHEMA', N'Historico', 'TABLE', N'DocumentoFirmante', 'COLUMN', N'TB_Salva'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si agrega nota.', 'SCHEMA', N'Historico', 'TABLE', N'DocumentoFirmante', 'COLUMN', N'TB_Nota'
GO
EXEC sp_addextendedproperty N'MS_Description', N'El funcionario texto de nota o voto salvado.', 'SCHEMA', N'Historico', 'TABLE', N'DocumentoFirmante', 'COLUMN', N'TC_JustificacionSalvaVotoNota'
GO
ALTER TABLE [Historico].[DocumentoFirmante] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Archivo].[AsignacionFirmante] (
		[TU_CodAsignacionFirmado]           [uniqueidentifier] NOT NULL,
		[TC_CodPuestoTrabajo]               [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_Orden]                          [tinyint] NOT NULL,
		[TF_FechaAplicado]                  [datetime2](7) NULL,
		[TU_FirmadoPor]                     [uniqueidentifier] NULL,
		[TF_FechaRevisado]                  [datetime2](7) NULL,
		[TB_Salva]                          [bit] NULL,
		[TB_Nota]                           [bit] NULL,
		[TC_JustificacionSalvaVotoNota]     [varchar](max) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                      [datetime2](7) NOT NULL,
		[TB_EsFirmaDigital]                 [bit] NOT NULL,
		[TB_BloqueaArchivo]                 [bit] NOT NULL,
		[TC_CodBarras]                      [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Firmante]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodAsignacionFirmado], [TC_CodPuestoTrabajo])
	ON [PRIMARY]
) ON [ArchivoPS] ([TF_Particion])
GO
ALTER TABLE [Archivo].[AsignacionFirmante]
	ADD
	CONSTRAINT [DF__Asignacio__TF_Pa__0A40052D]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Archivo].[AsignacionFirmante]
	ADD
	CONSTRAINT [DF__Asignacio__TB_Es__45A18D74]
	DEFAULT ((0)) FOR [TB_EsFirmaDigital]
GO
ALTER TABLE [Archivo].[AsignacionFirmante]
	ADD
	CONSTRAINT [DF__Asignacio__TB_Bl__4695B1AD]
	DEFAULT ((0)) FOR [TB_BloqueaArchivo]
GO
ALTER TABLE [Archivo].[AsignacionFirmante]
	WITH CHECK
	ADD CONSTRAINT [FK_AsignacionFirmante_AsignacionFirmado]
	FOREIGN KEY ([TU_CodAsignacionFirmado]) REFERENCES [Archivo].[AsignacionFirmado] ([TU_CodAsignacionFirmado])
ALTER TABLE [Archivo].[AsignacionFirmante]
	CHECK CONSTRAINT [FK_AsignacionFirmante_AsignacionFirmado]

GO
ALTER TABLE [Archivo].[AsignacionFirmante]
	WITH CHECK
	ADD CONSTRAINT [FK_AsignacionFirmante_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Archivo].[AsignacionFirmante]
	CHECK CONSTRAINT [FK_AsignacionFirmante_PuestoTrabajo]

GO
ALTER TABLE [Archivo].[AsignacionFirmante]
	WITH CHECK
	ADD CONSTRAINT [FK_AsignacionFirmante_PuestoTrabajoFuncionario]
	FOREIGN KEY ([TU_FirmadoPor]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Archivo].[AsignacionFirmante]
	CHECK CONSTRAINT [FK_AsignacionFirmante_PuestoTrabajoFuncionario]

GO
CREATE CLUSTERED INDEX [IX_Archivo_AsignacionFirmante_TF_Particion]
	ON [Archivo].[AsignacionFirmante] ([TF_Particion])
	ON [ArchivoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [Idx_TC_CodPuestoTrabajo_TF_FechaAplicado]
	ON [Archivo].[AsignacionFirmante] ([TC_CodPuestoTrabajo], [TF_FechaAplicado])
	ON [ArchivoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Archivo_AsignacionFirmante_CodigoBarras]
	ON [Archivo].[AsignacionFirmante] ([TC_CodBarras])
	INCLUDE ([TU_CodAsignacionFirmado], [TF_FechaAplicado])
	ON [ArchivoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Archivo_AsignacionFirmante_Migracion]
	ON [Archivo].[AsignacionFirmante] ([TU_CodAsignacionFirmado], [TC_CodPuestoTrabajo])
	ON [ArchivoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Archivo_AsignacionFirmante_PuestoTrabajo]
	ON [Archivo].[AsignacionFirmante] ([TC_CodPuestoTrabajo], [TU_CodAsignacionFirmado], [TN_Orden], [TF_FechaAplicado])
	ON [ArchivoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla detalle para almacenar los firmantes asignados a un documento', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmante', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'LLave asociada al documento que se encuentra asignado para firmar', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmante', 'COLUMN', N'TU_CodAsignacionFirmado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo llave asociado al puesto de trabajo que se le asigna el documento para firmar', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmante', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo numerico para determinar el orden de firmado por documento, inicia en 1, el primero es el que preside el firmado', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmante', 'COLUMN', N'TN_Orden'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se aplica la firma del funcionario en el documento', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmante', 'COLUMN', N'TF_FechaAplicado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Funcionario asociado a la firma del documento ', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmante', 'COLUMN', N'TU_FirmadoPor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que el funcionario asociado revisa el documento antes de ser firmado', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmante', 'COLUMN', N'TF_FechaRevisado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el es un voto salvado en el voto de la sentencia ', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmante', 'COLUMN', N'TB_Salva'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si se agrega una nota a la sentencia ', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmante', 'COLUMN', N'TB_Nota'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Texto que incluye el texto del voto salvado o la nota', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmante', 'COLUMN', N'TC_JustificacionSalvaVotoNota'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el firmante aplico la firma digital cuando ejecuto el proceso de firmar el documento.', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmante', 'COLUMN', N'TB_EsFirmaDigital'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Se asigna 1 cuando se esta aplicando la firma digital, cuando termina el proceso le asigna 0, esto para evitar que un mismo documento se le aplique firma digital simultaneamente.  ', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmante', 'COLUMN', N'TB_BloqueaArchivo'
GO
EXEC sp_addextendedproperty N'Description', N'Codigo de Barras asociado a la persona firmante', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmante', 'COLUMN', N'TC_CodBarras'
GO
ALTER TABLE [Archivo].[AsignacionFirmante] SET (LOCK_ESCALATION = TABLE)
GO

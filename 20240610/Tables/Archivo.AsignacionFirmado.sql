SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Archivo].[AsignacionFirmado] (
		[TU_CodAsignacionFirmado]     [uniqueidentifier] NOT NULL,
		[TU_CodArchivo]               [uniqueidentifier] NOT NULL,
		[TU_AsignadoPor]              [uniqueidentifier] NOT NULL,
		[TF_FechaAsigna]              [datetime2](7) NOT NULL,
		[TB_Urgente]                  [bit] NOT NULL,
		[TC_Estado]                   [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Observacion]              [varchar](300) COLLATE Modern_Spanish_CI_AS NULL,
		[TU_DevueltoPor]              [uniqueidentifier] NULL,
		[TU_DevueltoA]                [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaDevolucion]          [datetime2](7) NULL,
		[TU_CodArchivoAsignado]       [uniqueidentifier] NOT NULL,
		[TU_CodArchivoFirmado]        [uniqueidentifier] NULL,
		[TU_CorregidoPor]             [uniqueidentifier] NULL,
		[TF_Particion]                [datetime2](7) NOT NULL,
		[IDFIRMADO]                   [varchar](32) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_AsignacionFirmado]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodAsignacionFirmado])
	ON [PRIMARY]
) ON [ArchivoPS] ([TF_Particion])
GO
ALTER TABLE [Archivo].[AsignacionFirmado]
	ADD
	CONSTRAINT [CK_EstadoAsignacion]
	CHECK
	([TC_Estado]='P' OR [TC_Estado]='C' OR [TC_Estado]='F' OR [TC_Estado]='R')
GO
ALTER TABLE [Archivo].[AsignacionFirmado]
CHECK CONSTRAINT [CK_EstadoAsignacion]
GO
ALTER TABLE [Archivo].[AsignacionFirmado]
	ADD
	CONSTRAINT [DF__Asignacio__TF_Pa__34363EF9]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Archivo].[AsignacionFirmado]
	WITH CHECK
	ADD CONSTRAINT [FK_AsignacionFirmado_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Archivo].[AsignacionFirmado]
	CHECK CONSTRAINT [FK_AsignacionFirmado_Archivo]

GO
ALTER TABLE [Archivo].[AsignacionFirmado]
	WITH CHECK
	ADD CONSTRAINT [FK_AsignacionFirmado_PuestoTrabajoFuncionario]
	FOREIGN KEY ([TU_AsignadoPor]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Archivo].[AsignacionFirmado]
	CHECK CONSTRAINT [FK_AsignacionFirmado_PuestoTrabajoFuncionario]

GO
ALTER TABLE [Archivo].[AsignacionFirmado]
	WITH CHECK
	ADD CONSTRAINT [FK_AsignacionFirmado_PuestoTrabajoFuncionario1]
	FOREIGN KEY ([TU_DevueltoPor]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Archivo].[AsignacionFirmado]
	CHECK CONSTRAINT [FK_AsignacionFirmado_PuestoTrabajoFuncionario1]

GO
CREATE CLUSTERED INDEX [IX_Archivo_AsignacionFirmado_TF_Particion]
	ON [Archivo].[AsignacionFirmado] ([TF_Particion])
	ON [ArchivoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_Archivo_AsignacionFirmado_TU_AsignadoPor_INCLUDE]
	ON [Archivo].[AsignacionFirmado] ([TU_AsignadoPor])
	INCLUDE ([TU_CodAsignacionFirmado], [TU_CodArchivo], [TF_FechaAsigna], [TB_Urgente], [TC_Estado], [TC_Observacion], [TU_DevueltoPor], [TU_DevueltoA], [TF_FechaDevolucion], [TU_CodArchivoFirmado], [TU_CorregidoPor])
	ON [ArchivoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [Idx_TU_CodArchivoAsignado]
	ON [Archivo].[AsignacionFirmado] ([TU_CodArchivoAsignado])
	ON [ArchivoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Archivo_AsignacionFirmado_Migracion]
	ON [Archivo].[AsignacionFirmado] ([TU_CodArchivo], [TU_AsignadoPor], [TF_FechaAsigna], [TU_CodArchivoAsignado])
	ON [ArchivoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla maestra para guardar los documentos que se asignan para firmar por los funcionarios.', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico para cada documento que se asigna para firmar.', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', 'COLUMN', N'TU_CodAsignacionFirmado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico asociado a un documento del sistema SIAGPJ', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario de red del funcionario que realizo la asignación del documento', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', 'COLUMN', N'TU_AsignadoPor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se asigno el documento', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', 'COLUMN', N'TF_FechaAsigna'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Establece si el documento se debe firmar con una prioridad de urgencia', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', 'COLUMN', N'TB_Urgente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Establece los estados de la asignación del documento[P=Para Firma, F=Firmado, R=Para Corregir C=Corregido]', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo para que el firmante digite observación o razón por la cual devuelve la asignación para corregir', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', 'COLUMN', N'TC_Observacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de usuario que genera la devolución', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', 'COLUMN', N'TU_DevueltoPor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo para identificación de devolución de asignación', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', 'COLUMN', N'TU_DevueltoA'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de devolución de la asignación', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', 'COLUMN', N'TF_FechaDevolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de archivo asignado a firmar', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', 'COLUMN', N'TU_CodArchivoAsignado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de archivo post firma', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', 'COLUMN', N'TU_CodArchivoFirmado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de usuario que aplica corrección', 'SCHEMA', N'Archivo', 'TABLE', N'AsignacionFirmado', 'COLUMN', N'TU_CorregidoPor'
GO
ALTER TABLE [Archivo].[AsignacionFirmado] SET (LOCK_ESCALATION = TABLE)
GO

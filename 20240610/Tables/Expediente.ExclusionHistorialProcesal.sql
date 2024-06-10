SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ExclusionHistorialProcesal] (
		[TU_CodIndice]                       [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]                [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodLegajo]                       [uniqueidentifier] NULL,
		[TU_CodArchivo]                      [uniqueidentifier] NULL,
		[TC_Descrpcion]                      [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_TipoArchivo]                     [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_Consecutivo]                     [int] NOT NULL,
		[TC_Observaciones]                   [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaExclusion]                  [datetime2](7) NOT NULL,
		[TU_CodPuestoTrabajoFuncionario]     [uniqueidentifier] NOT NULL,
		[TU_CodEscrito]                      [uniqueidentifier] NULL,
		[TN_CodAudiencia]                    [bigint] NULL,
		[TF_Particion]                       [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ExclusionHistorialProcesal]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodIndice])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	ADD
	CONSTRAINT [CK_ExclusionHistorialProcesal_TipoArchivo]
	CHECK
	([TC_TipoArchivo]='A' OR [TC_TipoArchivo]='D' OR [TC_TipoArchivo]='E')
GO
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
CHECK CONSTRAINT [CK_ExclusionHistorialProcesal_TipoArchivo]
GO
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	ADD
	CONSTRAINT [DF_ExclusionHistorialProcesal_TF_FechaExclusion]
	DEFAULT (getdate()) FOR [TF_FechaExclusion]
GO
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	ADD
	CONSTRAINT [DF__Exclusion__TF_Pa__72687B9C]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	WITH CHECK
	ADD CONSTRAINT [FK_ExclusionHistorialProcesal_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	CHECK CONSTRAINT [FK_ExclusionHistorialProcesal_Archivo]

GO
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	WITH CHECK
	ADD CONSTRAINT [FK_ExclusionHistorialProcesal_Audiencia]
	FOREIGN KEY ([TN_CodAudiencia]) REFERENCES [Expediente].[Audiencia] ([TN_CodAudiencia])
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	CHECK CONSTRAINT [FK_ExclusionHistorialProcesal_Audiencia]

GO
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	WITH CHECK
	ADD CONSTRAINT [FK_ExclusionHistorialProcesal_EscritoExpediente]
	FOREIGN KEY ([TU_CodEscrito]) REFERENCES [Expediente].[EscritoExpediente] ([TU_CodEscrito])
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	CHECK CONSTRAINT [FK_ExclusionHistorialProcesal_EscritoExpediente]

GO
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	WITH CHECK
	ADD CONSTRAINT [FK_ExclusionHistorialProcesal_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	CHECK CONSTRAINT [FK_ExclusionHistorialProcesal_Expediente]

GO
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	WITH CHECK
	ADD CONSTRAINT [FK_ExclusionHistorialProcesal_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	CHECK CONSTRAINT [FK_ExclusionHistorialProcesal_Legajo]

GO
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	WITH CHECK
	ADD CONSTRAINT [FK_ExclusionHistorialProcesal_PuestoTrabajoFuncionario]
	FOREIGN KEY ([TU_CodPuestoTrabajoFuncionario]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Expediente].[ExclusionHistorialProcesal]
	CHECK CONSTRAINT [FK_ExclusionHistorialProcesal_PuestoTrabajoFuncionario]

GO
CREATE CLUSTERED INDEX [IX_Expediente_ExclusionHistorialProcesal_TF_Particion]
	ON [Expediente].[ExclusionHistorialProcesal] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único para la exclusión del documento', 'SCHEMA', N'Expediente', 'TABLE', N'ExclusionHistorialProcesal', 'COLUMN', N'TU_CodIndice'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente', 'SCHEMA', N'Expediente', 'TABLE', N'ExclusionHistorialProcesal', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de legajo', 'SCHEMA', N'Expediente', 'TABLE', N'ExclusionHistorialProcesal', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de archivo que se excluirá', 'SCHEMA', N'Expediente', 'TABLE', N'ExclusionHistorialProcesal', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del documento a la hora de excluirse', 'SCHEMA', N'Expediente', 'TABLE', N'ExclusionHistorialProcesal', 'COLUMN', N'TC_Descrpcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de archivo: "A" Audiencia, "D" Documento, "E" Escrito', 'SCHEMA', N'Expediente', 'TABLE', N'ExclusionHistorialProcesal', 'COLUMN', N'TC_TipoArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Consecutivo del archivo al momento de excluirse', 'SCHEMA', N'Expediente', 'TABLE', N'ExclusionHistorialProcesal', 'COLUMN', N'TN_Consecutivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones para la exclusión', 'SCHEMA', N'Expediente', 'TABLE', N'ExclusionHistorialProcesal', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se hizo la exclusión', 'SCHEMA', N'Expediente', 'TABLE', N'ExclusionHistorialProcesal', 'COLUMN', N'TF_FechaExclusion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Funcionario que realizó la exclusión', 'SCHEMA', N'Expediente', 'TABLE', N'ExclusionHistorialProcesal', 'COLUMN', N'TU_CodPuestoTrabajoFuncionario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del escrito', 'SCHEMA', N'Expediente', 'TABLE', N'ExclusionHistorialProcesal', 'COLUMN', N'TU_CodEscrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la audiencia', 'SCHEMA', N'Expediente', 'TABLE', N'ExclusionHistorialProcesal', 'COLUMN', N'TN_CodAudiencia'
GO
ALTER TABLE [Expediente].[ExclusionHistorialProcesal] SET (LOCK_ESCALATION = TABLE)
GO

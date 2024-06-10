SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[Resolucion] (
		[TU_CodResolucion]              [uniqueidentifier] NOT NULL,
		[TC_CodContexto]                [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_RedactorResponsable]        [uniqueidentifier] NULL,
		[TN_CodTipoResolucion]          [smallint] NOT NULL,
		[TN_CodResultadoResolucion]     [smallint] NOT NULL,
		[TF_FechaCreacion]              [datetime2](7) NOT NULL,
		[TF_FechaResolucion]            [datetime2](7) NULL,
		[TC_PorTanto]                   [varchar](max) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Resumen]                    [varchar](max) COLLATE Modern_Spanish_CI_AS NULL,
		[TU_CodArchivo]                 [uniqueidentifier] NULL,
		[TF_Actualizacion]              [datetime2](7) NOT NULL,
		[TN_CodCategoriaResolucion]     [smallint] NULL,
		[TC_EstadoEnvioSAS]             [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_DatoSensible]               [bit] NOT NULL,
		[TC_DescripcionSensible]        [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaEnvioSAS]              [datetime2](7) NULL,
		[TB_Relevante]                  [bit] NOT NULL,
		[TC_UsuarioRedSAS]              [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_ObservacionSAS]             [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_NumeroExpediente]           [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]                  [datetime2](7) NOT NULL,
		[USUREDAC]                      [varchar](25) COLLATE Modern_Spanish_CI_AS NULL,
		[IDACO]                         [int] NULL,
		CONSTRAINT [PK_Resolucion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodResolucion])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[Resolucion]
	ADD
	CONSTRAINT [CK_ResolucionEstadoEnvio]
	CHECK
	([TC_EstadoEnvioSAS]='N' OR [TC_EstadoEnvioSAS]='P' OR [TC_EstadoEnvioSAS]='A' OR [TC_EstadoEnvioSAS]='D' OR [TC_EstadoEnvioSAS]='E' OR [TC_EstadoEnvioSAS]='V')
GO
ALTER TABLE [Expediente].[Resolucion]
CHECK CONSTRAINT [CK_ResolucionEstadoEnvio]
GO
ALTER TABLE [Expediente].[Resolucion]
	ADD
	CONSTRAINT [DF_Resolucion_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[Resolucion]
	ADD
	CONSTRAINT [DF__Resolucio__TC_Es__041D1783]
	DEFAULT ('N') FOR [TC_EstadoEnvioSAS]
GO
ALTER TABLE [Expediente].[Resolucion]
	ADD
	CONSTRAINT [DF__Resolucio__TB_Da__05113BBC]
	DEFAULT ((0)) FOR [TB_DatoSensible]
GO
ALTER TABLE [Expediente].[Resolucion]
	ADD
	CONSTRAINT [DF__Resolucio__TB_Re__06055FF5]
	DEFAULT ((0)) FOR [TB_Relevante]
GO
ALTER TABLE [Expediente].[Resolucion]
	ADD
	CONSTRAINT [DF__Resolucio__TF_Pa__40D12008]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[Resolucion]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteResolucion_Contextos]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[Resolucion]
	CHECK CONSTRAINT [FK_ExpedienteResolucion_Contextos]

GO
ALTER TABLE [Expediente].[Resolucion]
	WITH CHECK
	ADD CONSTRAINT [FK_Resolucion_CategoriaResolucion]
	FOREIGN KEY ([TN_CodCategoriaResolucion]) REFERENCES [Catalogo].[CategoriaResolucion] ([TN_CodCategoriaResolucion])
ALTER TABLE [Expediente].[Resolucion]
	CHECK CONSTRAINT [FK_Resolucion_CategoriaResolucion]

GO
ALTER TABLE [Expediente].[Resolucion]
	WITH CHECK
	ADD CONSTRAINT [FK_Resolucion_PuestoTrabajoFuncionario]
	FOREIGN KEY ([TU_RedactorResponsable]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Expediente].[Resolucion]
	CHECK CONSTRAINT [FK_Resolucion_PuestoTrabajoFuncionario]

GO
ALTER TABLE [Expediente].[Resolucion]
	WITH CHECK
	ADD CONSTRAINT [FK_Resolucion_ResultadoResolucion]
	FOREIGN KEY ([TN_CodResultadoResolucion]) REFERENCES [Catalogo].[ResultadoResolucion] ([TN_CodResultadoResolucion])
ALTER TABLE [Expediente].[Resolucion]
	CHECK CONSTRAINT [FK_Resolucion_ResultadoResolucion]

GO
ALTER TABLE [Expediente].[Resolucion]
	WITH CHECK
	ADD CONSTRAINT [FK_Resolucion_TipoResolucion]
	FOREIGN KEY ([TN_CodTipoResolucion]) REFERENCES [Catalogo].[TipoResolucion] ([TN_CodTipoResolucion])
ALTER TABLE [Expediente].[Resolucion]
	CHECK CONSTRAINT [FK_Resolucion_TipoResolucion]

GO
ALTER TABLE [Expediente].[Resolucion]
	WITH CHECK
	ADD CONSTRAINT [FK_ResolucionArchivoExpediente]
	FOREIGN KEY ([TU_CodArchivo], [TC_NumeroExpediente]) REFERENCES [Expediente].[ArchivoExpediente] ([TU_CodArchivo], [TC_NumeroExpediente])
ALTER TABLE [Expediente].[Resolucion]
	CHECK CONSTRAINT [FK_ResolucionArchivoExpediente]

GO
CREATE CLUSTERED INDEX [IX_Expediente_Resolucion_TF_Particion]
	ON [Expediente].[Resolucion] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_Expediente_Resolucion_Archivo_NumExped]
	ON [Expediente].[Resolucion] ([TU_CodArchivo], [TC_NumeroExpediente])
	WITH ( FILLFACTOR = 100)
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_Resolucion_Migracion]
	ON [Expediente].[Resolucion] ([TC_CodContexto], [TN_CodTipoResolucion], [TF_FechaCreacion], [TF_FechaResolucion], [TU_CodArchivo], [TC_NumeroExpediente])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_Resolucion_TC_NumeroExpediente]
	ON [Expediente].[Resolucion] ([TC_NumeroExpediente])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los datos de las resoluciones.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de resolución.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TU_CodResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Funcionario responsable redactar resolución.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TU_RedactorResponsable'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de resolución.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TN_CodTipoResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del resultado de resolución.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TN_CodResultadoResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación del registro resolución.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TF_FechaCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora del número de resolución.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TF_FechaResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Texto del por tanto de resolución.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TC_PorTanto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datos resumen de resolución.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TC_Resumen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del archivo asociado a la resolución.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del tipo de categoria', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TN_CodCategoriaResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el estado de envio de la sentencia al SAS, WITH CHECK ADD CONSTRAINT N=No Enviar,P=Pendiente enviar, A=Para enviar,D=Enviandose,E=Error al enviar,V=Enviada', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TC_EstadoEnvioSAS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador de que la sentencia tiene dato sensibles', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TB_DatoSensible'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descrpcion del dato que es sensible', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TC_DescripcionSensible'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de envio de la sentencia al SAS', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TF_FechaEnvioSAS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador que la sentencia es relevante para el publico.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TB_Relevante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que envio la sentencia a jurisprudencia.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TC_UsuarioRedSAS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones sobre el envio de la sentencia.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TC_ObservacionSAS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de expediente único a lo largo de la vida del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Funcionario responsable redactar resolución (Proveniente de SCGDJ).', 'SCHEMA', N'Expediente', 'TABLE', N'Resolucion', 'COLUMN', N'USUREDAC'
GO
ALTER TABLE [Expediente].[Resolucion] SET (LOCK_ESCALATION = TABLE)
GO

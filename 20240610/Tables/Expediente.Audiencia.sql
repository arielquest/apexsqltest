SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[Audiencia] (
		[TN_CodAudiencia]          [bigint] NOT NULL,
		[TC_NumeroExpediente]      [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Estado]                [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]           [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NombreArchivo]         [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodTipoAudiencia]      [smallint] NOT NULL,
		[TC_CodContextoCrea]       [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRedCrea]        [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Duracion]              [varchar](11) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaCrea]             [datetime2](2) NOT NULL,
		[TN_EstadoPublicacion]     [smallint] NOT NULL,
		[TF_Actualizacion]         [datetime2](3) NULL,
		[TN_Consecutivo]           [int] NULL,
		[TN_CantidadArchivos]      [tinyint] NOT NULL,
		[IDMULTI]                  [varchar](22) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		[SISTEMA]                  [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[IDACO_ORIGINAL]           [int] NULL,
		CONSTRAINT [PK_Audiencia]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodAudiencia])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[Audiencia]
	ADD
	CONSTRAINT [CK_AudienciaExpediente_Estado]
	CHECK
	([TC_Estado]='N' OR [TC_Estado]='S')
GO
ALTER TABLE [Expediente].[Audiencia]
CHECK CONSTRAINT [CK_AudienciaExpediente_Estado]
GO
ALTER TABLE [Expediente].[Audiencia]
	ADD
	CONSTRAINT [CK_AudienciaExpediente_EstadoPublicacion]
	CHECK
	([TN_EstadoPublicacion]=(1) OR [TN_EstadoPublicacion]=(2) OR [TN_EstadoPublicacion]=(3) OR [TN_EstadoPublicacion]=(4))
GO
ALTER TABLE [Expediente].[Audiencia]
CHECK CONSTRAINT [CK_AudienciaExpediente_EstadoPublicacion]
GO
ALTER TABLE [Expediente].[Audiencia]
	ADD
	CONSTRAINT [CK_Sistema]
	CHECK
	([SISTEMA]='S' OR [SISTEMA]='X')
GO
ALTER TABLE [Expediente].[Audiencia]
CHECK CONSTRAINT [CK_Sistema]
GO
ALTER TABLE [Expediente].[Audiencia]
	ADD
	CONSTRAINT [DF_Expediente_Audiencia_TU_CodAudiencia]
	DEFAULT (NEXT VALUE FOR [Expediente].[SecuenciaAudiencia]) FOR [TN_CodAudiencia]
GO
ALTER TABLE [Expediente].[Audiencia]
	ADD
	CONSTRAINT [DF_Audiencia_TN_EstadoPublicacion]
	DEFAULT ((1)) FOR [TN_EstadoPublicacion]
GO
ALTER TABLE [Expediente].[Audiencia]
	ADD
	CONSTRAINT [DF_Audiencia_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[Audiencia]
	ADD
	CONSTRAINT [DF__Audiencia__TN_Ca__54E305AD]
	DEFAULT ((1)) FOR [TN_CantidadArchivos]
GO
ALTER TABLE [Expediente].[Audiencia]
	ADD
	CONSTRAINT [DF__Audiencia__TF_Pa__55D729E6]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[Audiencia]
	ADD
	CONSTRAINT [DF__Audiencia__SISTE__13A01D8C]
	DEFAULT ('S') FOR [SISTEMA]
GO
ALTER TABLE [Expediente].[Audiencia]
	WITH CHECK
	ADD CONSTRAINT [FK_Audiencia_Contexto]
	FOREIGN KEY ([TC_CodContextoCrea]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[Audiencia]
	CHECK CONSTRAINT [FK_Audiencia_Contexto]

GO
ALTER TABLE [Expediente].[Audiencia]
	WITH CHECK
	ADD CONSTRAINT [FK_Audiencia_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[Audiencia]
	CHECK CONSTRAINT [FK_Audiencia_Expediente]

GO
ALTER TABLE [Expediente].[Audiencia]
	WITH CHECK
	ADD CONSTRAINT [FK_Audiencia_TipoAudiencia]
	FOREIGN KEY ([TN_CodTipoAudiencia]) REFERENCES [Catalogo].[TipoAudiencia] ([TN_CodTipoAudiencia])
ALTER TABLE [Expediente].[Audiencia]
	CHECK CONSTRAINT [FK_Audiencia_TipoAudiencia]

GO
CREATE CLUSTERED INDEX [IX_Expediente_Audiencia_TF_Particion]
	ON [Expediente].[Audiencia] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_Audiencia_Migracion]
	ON [Expediente].[Audiencia] ([TC_NumeroExpediente], [TC_NombreArchivo], [TC_Duracion], [TF_FechaCrea])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la audiencia', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TN_CodAudiencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de la audiencia. N: Nueva, S: Sincronizada', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la audiencia', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de archivo de audiencia', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TC_NombreArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de la audiencia', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TN_CodTipoAudiencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto que crea la audiencia', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TC_CodContextoCrea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario de red que crea la audiencia', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TC_UsuarioRedCrea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Duración de la audiencia en formato hh:mm:ss.ff', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TC_Duracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación de la audiencia', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TF_FechaCrea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de publicación', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TN_EstadoPublicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización (SIGMA)', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Consecutivo asignado para el Historial Procesal', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TN_Consecutivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica la cantidad de archivos en los que se divide la audiencia, si no se indica, por defecto se pone 1.', 'SCHEMA', N'Expediente', 'TABLE', N'Audiencia', 'COLUMN', N'TN_CantidadArchivos'
GO
ALTER TABLE [Expediente].[Audiencia] SET (LOCK_ESCALATION = TABLE)
GO

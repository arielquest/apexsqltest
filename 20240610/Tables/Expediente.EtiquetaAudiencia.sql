SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[EtiquetaAudiencia] (
		[TU_CodEtiqueta]            [uniqueidentifier] NOT NULL,
		[TN_TiempoMilisegundos]     [bigint] NOT NULL,
		[TC_Etiqueta]               [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_TipoEtiqueta]           [bit] NOT NULL,
		[TN_CodAudiencia]           [bigint] NOT NULL,
		[TC_TiempoArchivo]          [varchar](11) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NombreArchivo]          [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]              [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Etiqueta]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodEtiqueta])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[EtiquetaAudiencia]
	ADD
	CONSTRAINT [DF__EtiquetaA__TC_Ti__56CB4E1F]
	DEFAULT ('00:00:00:00') FOR [TC_TiempoArchivo]
GO
ALTER TABLE [Expediente].[EtiquetaAudiencia]
	ADD
	CONSTRAINT [DF__EtiquetaA__TC_No__57BF7258]
	DEFAULT ('') FOR [TC_NombreArchivo]
GO
ALTER TABLE [Expediente].[EtiquetaAudiencia]
	ADD
	CONSTRAINT [DF__EtiquetaA__TF_Pa__58B39691]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[EtiquetaAudiencia]
	WITH CHECK
	ADD CONSTRAINT [FK_EtiquetaAudiencia_Audiencia]
	FOREIGN KEY ([TN_CodAudiencia]) REFERENCES [Expediente].[Audiencia] ([TN_CodAudiencia])
ALTER TABLE [Expediente].[EtiquetaAudiencia]
	CHECK CONSTRAINT [FK_EtiquetaAudiencia_Audiencia]

GO
CREATE CLUSTERED INDEX [IX_Expediente_EtiquetaAudiencia_TF_Particion]
	ON [Expediente].[EtiquetaAudiencia] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_EtiquetaAudiencia_Migracion]
	ON [Expediente].[EtiquetaAudiencia] ([TN_CodAudiencia], [TC_NombreArchivo], [TC_TiempoArchivo])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de etiqueta.', 'SCHEMA', N'Expediente', 'TABLE', N'EtiquetaAudiencia', 'COLUMN', N'TU_CodEtiqueta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tiempo en el cual se mostrará la etiqueta.', 'SCHEMA', N'Expediente', 'TABLE', N'EtiquetaAudiencia', 'COLUMN', N'TN_TiempoMilisegundos'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Texto de la etiqueta.', 'SCHEMA', N'Expediente', 'TABLE', N'EtiquetaAudiencia', 'COLUMN', N'TC_Etiqueta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la etiqueta es pública (1) o privada (0)', 'SCHEMA', N'Expediente', 'TABLE', N'EtiquetaAudiencia', 'COLUMN', N'TB_TipoEtiqueta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la audiencia', 'SCHEMA', N'Expediente', 'TABLE', N'EtiquetaAudiencia', 'COLUMN', N'TN_CodAudiencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tiempo de grabación de la etiqueta en el archivo de audio de video en el que se encuentra. Utiliza el formato hh:mm:ss:msms.', 'SCHEMA', N'Expediente', 'TABLE', N'EtiquetaAudiencia', 'COLUMN', N'TC_TiempoArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del archivo de audio o video en el que se encuentra la etiqueta.', 'SCHEMA', N'Expediente', 'TABLE', N'EtiquetaAudiencia', 'COLUMN', N'TC_NombreArchivo'
GO
ALTER TABLE [Expediente].[EtiquetaAudiencia] SET (LOCK_ESCALATION = TABLE)
GO

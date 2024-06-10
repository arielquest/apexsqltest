SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ExpedienteConsolidadoArchivo] (
		[TU_CodArchivo]                           [uniqueidentifier] NOT NULL,
		[TU_CodSolicitudDocumentoConsolidado]     [uniqueidentifier] NOT NULL,
		[TU_CodArchivoEnPrimzDoc]                 [varchar](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_ExpedienteConsolidadoArchivo]
		PRIMARY KEY
		CLUSTERED
		([TU_CodArchivo], [TU_CodSolicitudDocumentoConsolidado], [TU_CodArchivoEnPrimzDoc])
	ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del archivo', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidadoArchivo', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la solicitud de generación del expediente consolidado', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidadoArchivo', 'COLUMN', N'TU_CodSolicitudDocumentoConsolidado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si ya fue publicado el archivo en el expediente consolidado', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidadoArchivo', 'COLUMN', N'TU_CodArchivoEnPrimzDoc'
GO
ALTER TABLE [Expediente].[ExpedienteConsolidadoArchivo] SET (LOCK_ESCALATION = TABLE)
GO

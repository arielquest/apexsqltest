SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ExpedienteConsolidado] (
		[TU_CodSolicitudDocumentoConsolidado]     [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]                     [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]                          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodLegajo]                            [uniqueidentifier] NULL,
		[TF_FechaSolicitud]                       [datetime2](2) NOT NULL,
		[TN_Sistema]                              [varchar](7) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]                           [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Estado]                               [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaGenerado]                        [datetime2](2) NULL,
		[TF_FechaVencimiento]                     [datetime2](2) NULL,
		[TC_CodDocumentoConsolidado]              [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_SessionPrimzDoc]                      [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_ExpedienteConsolidado]
		PRIMARY KEY
		CLUSTERED
		([TU_CodSolicitudDocumentoConsolidado])
	ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla donde se almacenan todas las solicitudes para la generación de documentos consolidados de un expediente o legajo', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidado', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la solicitud del documento consolidado', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidado', 'COLUMN', N'TU_CodSolicitudDocumentoConsolidado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de expediente único al que está relacionada una solicitud', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidado', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contexto donde se encuentra el expediente o legajo', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidado', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de legajo de la solicitud', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidado', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en la que se solicita la generación del documento consolidado', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidado', 'COLUMN', N'TF_FechaSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sistema que genera la solicitud Gestion en Línea o SIAGPJ', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidado', 'COLUMN', N'TN_Sistema'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que genera la solicitud de generación del documento consolidado, nombre de usuario de red', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidado', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de la solicitud:  Pendiente = P, Tramitandose = T, Finalizada = F', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidado', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en la que se genera el documento consolidado', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidado', 'COLUMN', N'TF_FechaGenerado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de vencimiento del documento consolidado', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidado', 'COLUMN', N'TF_FechaVencimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del documento consolidado devuelto por el servicio de Prizmdoc', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidado', 'COLUMN', N'TC_CodDocumentoConsolidado'
GO
ALTER TABLE [Expediente].[ExpedienteConsolidado] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ExpedienteConsolidadoProcesoPrizmdoc] (
		[TF_FechaInicioUnificacion]               [datetime2](7) NOT NULL,
		[TU_CodSolicitudDocumentoConsolidado]     [uniqueidentifier] NOT NULL,
		[TC_CodProcesoUnificadoPrimzDoc]          [varchar](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_ExpedienteConsolidadoProcesoPrizmdoc]
		PRIMARY KEY
		CLUSTERED
		([TU_CodSolicitudDocumentoConsolidado])
	ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla donde se almacenan  los id de unificación devueltos por primzdoc para cada solicitud', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidadoProcesoPrizmdoc', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora en la que se solicita a PrizmDoc la generación del documento consolidado', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidadoProcesoPrizmdoc', 'COLUMN', N'TF_FechaInicioUnificacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la solicitud del documento consolidado', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidadoProcesoPrizmdoc', 'COLUMN', N'TU_CodSolicitudDocumentoConsolidado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del proceso de unificación en PrizmDoc', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteConsolidadoProcesoPrizmdoc', 'COLUMN', N'TC_CodProcesoUnificadoPrimzDoc'
GO
ALTER TABLE [Expediente].[ExpedienteConsolidadoProcesoPrizmdoc] SET (LOCK_ESCALATION = TABLE)
GO

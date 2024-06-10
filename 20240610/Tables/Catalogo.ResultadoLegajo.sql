SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[ResultadoLegajo] (
		[TN_CodResultadoLegajo]      [smallint] NOT NULL,
		[TC_Descripcion]             [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaInicioVigencia]     [datetime2](7) NOT NULL,
		[TF_FechaFinVigencia]        [datetime2](7) NULL,
		[CODRESUL]                   [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_ResultadoLegajo]
		PRIMARY KEY
		CLUSTERED
		([TN_CodResultadoLegajo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[ResultadoLegajo]
	ADD
	CONSTRAINT [DF_ResultadoLegajo_TN_CodResultadoLegajo]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaResultadoLegado]) FOR [TN_CodResultadoLegajo]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del Resultado de legajo', 'SCHEMA', N'Catalogo', 'TABLE', N'ResultadoLegajo', 'COLUMN', N'TN_CodResultadoLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Resultado de legajo a registrar', 'SCHEMA', N'Catalogo', 'TABLE', N'ResultadoLegajo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del resultado de legajo', 'SCHEMA', N'Catalogo', 'TABLE', N'ResultadoLegajo', 'COLUMN', N'TF_FechaInicioVigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del resultado de legajo', 'SCHEMA', N'Catalogo', 'TABLE', N'ResultadoLegajo', 'COLUMN', N'TF_FechaFinVigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'ResultadoLegajo', 'COLUMN', N'CODRESUL'
GO
ALTER TABLE [Catalogo].[ResultadoLegajo] SET (LOCK_ESCALATION = TABLE)
GO

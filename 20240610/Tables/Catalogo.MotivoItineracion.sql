SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MotivoItineracion] (
		[TN_CodMotivoItineracion]     [smallint] NOT NULL,
		[TC_Descripcion]              [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]          [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]             [datetime2](7) NULL,
		[CODMOT]                      [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_MotivoItineracion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodMotivoItineracion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MotivoItineracion]
	ADD
	CONSTRAINT [DF_MotivoItineracion_TN_CodMotivoItineracion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaMotivoItineracion]) FOR [TN_CodMotivoItineracion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de los diferentes motivos de itineración existentes', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoItineracion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de itineracion.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoItineracion', 'COLUMN', N'TN_CodMotivoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del motivo de itineracion.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoItineracion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro de motivo de itineracion.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoItineracion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro del motivo de itineracion.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoItineracion', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoItineracion', 'COLUMN', N'CODMOT'
GO
ALTER TABLE [Catalogo].[MotivoItineracion] SET (LOCK_ESCALATION = TABLE)
GO

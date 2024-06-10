SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoItineracion] (
		[TN_CodEstadoItineracion]     [smallint] NOT NULL,
		[TC_Descripcion]              [varchar](21) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]          [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]             [datetime2](7) NULL,
		[CODESTITI]                   [varchar](1) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_EstadoItineracion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstadoItineracion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoItineracion]
	ADD
	CONSTRAINT [DF_EstadoItineracion_TN_CodEstadoItineracion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEstadoItineracion]) FOR [TN_CodEstadoItineracion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de estados de itineración.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoItineracion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado de itineración.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoItineracion', 'COLUMN', N'TN_CodEstadoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del estado de itineración.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoItineracion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoItineracion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoItineracion', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoItineracion', 'COLUMN', N'CODESTITI'
GO
ALTER TABLE [Catalogo].[EstadoItineracion] SET (LOCK_ESCALATION = TABLE)
GO

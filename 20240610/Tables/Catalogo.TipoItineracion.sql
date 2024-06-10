SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoItineracion] (
		[TN_CodTipoItineracion]     [smallint] NOT NULL,
		[TC_Descripcion]            [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]           [datetime2](7) NULL,
		CONSTRAINT [PK_TipoItineracion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoItineracion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoItineracion]
	ADD
	CONSTRAINT [DF_TipoItineracion_TN_CodTipoItineracion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoItineracion]) FOR [TN_CodTipoItineracion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del Tipo de itineracion', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoItineracion', 'COLUMN', N'TN_CodTipoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de itineracion a registrar', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoItineracion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del tipo de itineracion', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoItineracion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del tipo de itineracion', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoItineracion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoItineracion] SET (LOCK_ESCALATION = TABLE)
GO

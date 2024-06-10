SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Catalogo].[TipoItineracionResultadoLegajo] (
		[TN_CodTipoItineracion]     [smallint] NOT NULL,
		[TN_CodResultadoLegajo]     [smallint] NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NULL,
		[TB_PorDefecto]             [bit] NOT NULL,
		CONSTRAINT [PK_TipoItineracionResultadoLegajo]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoItineracion], [TN_CodResultadoLegajo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoItineracionResultadoLegajo]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoItineracionResultadoLegajo_ResultadoLegajo]
	FOREIGN KEY ([TN_CodResultadoLegajo]) REFERENCES [Catalogo].[ResultadoLegajo] ([TN_CodResultadoLegajo])
ALTER TABLE [Catalogo].[TipoItineracionResultadoLegajo]
	CHECK CONSTRAINT [FK_TipoItineracionResultadoLegajo_ResultadoLegajo]

GO
ALTER TABLE [Catalogo].[TipoItineracionResultadoLegajo]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoItineracionResultadoLegajo_TipoItineracion]
	FOREIGN KEY ([TN_CodTipoItineracion]) REFERENCES [Catalogo].[TipoItineracion] ([TN_CodTipoItineracion])
ALTER TABLE [Catalogo].[TipoItineracionResultadoLegajo]
	CHECK CONSTRAINT [FK_TipoItineracionResultadoLegajo_TipoItineracion]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Referencia al código de un tipo de itineracion', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoItineracionResultadoLegajo', 'COLUMN', N'TN_CodTipoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Referencia al código de un resultado de legajo', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoItineracionResultadoLegajo', 'COLUMN', N'TN_CodResultadoLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro de asociación', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoItineracionResultadoLegajo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el registro esta definido como por defecto', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoItineracionResultadoLegajo', 'COLUMN', N'TB_PorDefecto'
GO
ALTER TABLE [Catalogo].[TipoItineracionResultadoLegajo] SET (LOCK_ESCALATION = TABLE)
GO

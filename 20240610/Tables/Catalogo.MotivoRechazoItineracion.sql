SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MotivoRechazoItineracion] (
		[TN_CodMotivoRechazoItineracion]     [smallint] NOT NULL,
		[TC_Descripcion]                     [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]                 [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]                    [datetime2](7) NULL,
		CONSTRAINT [PK_MotivoRechazoItineracion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodMotivoRechazoItineracion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MotivoRechazoItineracion]
	ADD
	CONSTRAINT [DF_MotivoRechazoItineracion_TN_CodMotivoRechazoItineracion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaMotivoRechazoItineracion]) FOR [TN_CodMotivoRechazoItineracion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de los diferentes motivos de rechazo de itineración existentes', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoRechazoItineracion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo rechazo de itineración.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoRechazoItineracion', 'COLUMN', N'TN_CodMotivoRechazoItineracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del motivo rechazo de itineración.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoRechazoItineracion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro de motivo rechazo de itineración.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoRechazoItineracion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro del motivo rechazo de itineración.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoRechazoItineracion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[MotivoRechazoItineracion] SET (LOCK_ESCALATION = TABLE)
GO

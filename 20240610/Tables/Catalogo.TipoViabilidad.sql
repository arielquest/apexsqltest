SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoViabilidad] (
		[TN_CodTipoViabilidad]     [smallint] NOT NULL,
		[TC_Descripcion]           [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]          [datetime2](7) NULL,
		[TCT_TIPO_EXPEDIENTE]      [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_TipoViabilidad]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoViabilidad])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoViabilidad]
	ADD
	CONSTRAINT [DF_TipoViabilidad_TN_CodTipoViabilidad]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoViabilidad]) FOR [TN_CodTipoViabilidad]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de viabilidad de un expediente.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoViabilidad', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de viabilidad de un expediente.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoViabilidad', 'COLUMN', N'TN_CodTipoViabilidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de viabilidad.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoViabilidad', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoViabilidad', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoViabilidad', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoViabilidad] SET (LOCK_ESCALATION = TABLE)
GO

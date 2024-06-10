SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoPrevencion] (
		[TN_CodTipoPrevencion]     [smallint] NOT NULL,
		[TC_Descripcion]           [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]          [datetime2](3) NULL,
		CONSTRAINT [PK_CatalogoPrevencion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoPrevencion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoPrevencion]
	ADD
	CONSTRAINT [DF_TipoPrevencion_TN_CodTipoPrevencion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoPrevencion]) FOR [TN_CodTipoPrevencion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipo: "TipoPrevencion"', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPrevencion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPrevencion', 'COLUMN', N'TN_CodTipoPrevencion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPrevencion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPrevencion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPrevencion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoPrevencion] SET (LOCK_ESCALATION = TABLE)
GO

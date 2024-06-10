SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[CategoriaDelito] (
		[TN_CodCategoriaDelito]     [int] NOT NULL,
		[TC_Descripcion]            [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]           [datetime2](7) NULL,
		[CODDEL]                    [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_CategoriaDelito]
		PRIMARY KEY
		CLUSTERED
		([TN_CodCategoriaDelito])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[CategoriaDelito]
	ADD
	CONSTRAINT [DF_CategoriaDelito_TN_CodCategoriaDelito]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaCategoriaDelito]) FOR [TN_CodCategoriaDelito]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de categorías de delito.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelito', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de categoría de delito.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelito', 'COLUMN', N'TN_CodCategoriaDelito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de categoría de delito.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelito', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelito', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelito', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[CategoriaDelito] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Catalogo] (
		[TN_CodCatalogo]         [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_Controlador]         [bit] NOT NULL,
		[TC_DescripcionUrl]      [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CatalogoSiagpj]      [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_CCatalogo]
		PRIMARY KEY
		CLUSTERED
		([TN_CodCatalogo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Catalogo]
	ADD
	CONSTRAINT [DF_Catalogo_TN_CodCatalogo]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaCatalogo]) FOR [TN_CodCatalogo]
GO
ALTER TABLE [Catalogo].[Catalogo]
	ADD
	CONSTRAINT [DF__Catalogo__TB_Con__1019A56B]
	DEFAULT ((0)) FOR [TB_Controlador]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene los catálogos para asociarlos a los sistemas, en las equivalencias', 'SCHEMA', N'Catalogo', 'TABLE', N'Catalogo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de catálogo', 'SCHEMA', N'Catalogo', 'TABLE', N'Catalogo', 'COLUMN', N'TN_CodCatalogo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del catálogo', 'SCHEMA', N'Catalogo', 'TABLE', N'Catalogo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Controlador/Método de consulta', 'SCHEMA', N'Catalogo', 'TABLE', N'Catalogo', 'COLUMN', N'TB_Controlador'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la direccion URL', 'SCHEMA', N'Catalogo', 'TABLE', N'Catalogo', 'COLUMN', N'TC_DescripcionUrl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la tabla catálogo del SIAGPJ asociado', 'SCHEMA', N'Catalogo', 'TABLE', N'Catalogo', 'COLUMN', N'TC_CatalogoSiagpj'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha inicio de vigencia del catálogo', 'SCHEMA', N'Catalogo', 'TABLE', N'Catalogo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha fin de vigencia del catálogo', 'SCHEMA', N'Catalogo', 'TABLE', N'Catalogo', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Catalogo] SET (LOCK_ESCALATION = TABLE)
GO

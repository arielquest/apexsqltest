SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[CategoriaResolucion] (
		[TN_CodCategoriaResolucion]     [smallint] NOT NULL,
		[TC_Descripcion]                [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]            [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]               [datetime2](7) NULL,
		[CODRES]                        [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_CategoriaResolicion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodCategoriaResolucion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[CategoriaResolucion]
	ADD
	CONSTRAINT [DF__Categoria__TN_Co__26F21DCB]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaCategoriaResolucion]) FOR [TN_CodCategoriaResolucion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de categoria', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaResolucion', 'COLUMN', N'TN_CodCategoriaResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de categoria para enviar al SCIJ', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaResolucion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaResolucion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaResolucion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[CategoriaResolucion] SET (LOCK_ESCALATION = TABLE)
GO

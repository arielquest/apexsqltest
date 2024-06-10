SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[CategoriaDelitoTipoOficina] (
		[TN_CodTipoOficina]         [smallint] NOT NULL,
		[TN_CodCategoriaDelito]     [int] NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NULL,
		[TC_CodMateria]             [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_CategoriaDelitoTipoOficina]
		PRIMARY KEY
		CLUSTERED
		([TN_CodCategoriaDelito], [TN_CodTipoOficina], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[CategoriaDelitoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_CategoriaDelitoTipoOficina_CategoriaDelito]
	FOREIGN KEY ([TN_CodCategoriaDelito]) REFERENCES [Catalogo].[CategoriaDelito] ([TN_CodCategoriaDelito])
ALTER TABLE [Catalogo].[CategoriaDelitoTipoOficina]
	CHECK CONSTRAINT [FK_CategoriaDelitoTipoOficina_CategoriaDelito]

GO
ALTER TABLE [Catalogo].[CategoriaDelitoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_CategoriaDelitoTipoOficina_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[CategoriaDelitoTipoOficina]
	CHECK CONSTRAINT [FK_CategoriaDelitoTipoOficina_TipoOficinaMateria]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia los tipos de oficina y materias con su categoría de delito.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelitoTipoOficina', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelitoTipoOficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de categoría delito.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelitoTipoOficina', 'COLUMN', N'TN_CodCategoriaDelito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelitoTipoOficina', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelitoTipoOficina', 'COLUMN', N'TC_CodMateria'
GO
ALTER TABLE [Catalogo].[CategoriaDelitoTipoOficina] SET (LOCK_ESCALATION = TABLE)
GO

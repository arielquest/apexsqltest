SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[CategoriaDelitoMateria] (
		[TN_CodCategoriaDelito]     [int] NOT NULL,
		[TC_CodMateria]             [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		CONSTRAINT [PK_CategoriaDelitoMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodCategoriaDelito], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[CategoriaDelitoMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_CategoriaDelitoMateria_CategoriaDelito]
	FOREIGN KEY ([TN_CodCategoriaDelito]) REFERENCES [Catalogo].[CategoriaDelito] ([TN_CodCategoriaDelito])
ALTER TABLE [Catalogo].[CategoriaDelitoMateria]
	CHECK CONSTRAINT [FK_CategoriaDelitoMateria_CategoriaDelito]

GO
ALTER TABLE [Catalogo].[CategoriaDelitoMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_CategoriaDelitoMateria_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[CategoriaDelitoMateria]
	CHECK CONSTRAINT [FK_CategoriaDelitoMateria_Materia]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia las materias con una categoría de delito.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelitoMateria', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de categoría delito.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelitoMateria', 'COLUMN', N'TN_CodCategoriaDelito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelitoMateria', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'CategoriaDelitoMateria', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[CategoriaDelitoMateria] SET (LOCK_ESCALATION = TABLE)
GO

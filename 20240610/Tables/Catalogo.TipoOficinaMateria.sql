SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoOficinaMateria] (
		[TN_CodTipoOficina]      [smallint] NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_TipoOficinaMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoOficina], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoOficinaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaMateria_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[TipoOficinaMateria]
	CHECK CONSTRAINT [FK_TipoOficinaMateria_Materia]

GO
ALTER TABLE [Catalogo].[TipoOficinaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaMateria_TipoOficina]
	FOREIGN KEY ([TN_CodTipoOficina]) REFERENCES [Catalogo].[TipoOficina] ([TN_CodTipoOficina])
ALTER TABLE [Catalogo].[TipoOficinaMateria]
	CHECK CONSTRAINT [FK_TipoOficinaMateria_TipoOficina]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaMateria', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la materia', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaMateria', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia de la relación', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaMateria', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoOficinaMateria] SET (LOCK_ESCALATION = TABLE)
GO

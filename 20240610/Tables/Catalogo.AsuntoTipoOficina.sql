SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[AsuntoTipoOficina] (
		[TN_CodTipoOficina]      [smallint] NOT NULL,
		[TN_CodAsunto]           [int] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_AsuntoTipoOficina]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoOficina], [TN_CodAsunto], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[AsuntoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_AsuntoTipoOficina_Asunto]
	FOREIGN KEY ([TN_CodAsunto]) REFERENCES [Catalogo].[Asunto] ([TN_CodAsunto])
ALTER TABLE [Catalogo].[AsuntoTipoOficina]
	CHECK CONSTRAINT [FK_AsuntoTipoOficina_Asunto]

GO
ALTER TABLE [Catalogo].[AsuntoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_AsuntoTipoOficina_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[AsuntoTipoOficina]
	CHECK CONSTRAINT [FK_AsuntoTipoOficina_TipoOficinaMateria]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene los asuntos para un tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'AsuntoTipoOficina', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'AsuntoTipoOficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de asunto', 'SCHEMA', N'Catalogo', 'TABLE', N'AsuntoTipoOficina', 'COLUMN', N'TN_CodAsunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de asociación', 'SCHEMA', N'Catalogo', 'TABLE', N'AsuntoTipoOficina', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de materia', 'SCHEMA', N'Catalogo', 'TABLE', N'AsuntoTipoOficina', 'COLUMN', N'TC_CodMateria'
GO
ALTER TABLE [Catalogo].[AsuntoTipoOficina] SET (LOCK_ESCALATION = TABLE)
GO

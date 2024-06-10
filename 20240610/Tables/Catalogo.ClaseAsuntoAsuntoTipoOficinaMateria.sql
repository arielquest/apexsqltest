SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[ClaseAsuntoAsuntoTipoOficinaMateria] (
		[TN_CodClaseAsunto]      [int] NOT NULL,
		[TN_CodAsunto]           [int] NOT NULL,
		[TN_CodTipoOficina]      [smallint] NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ClaseAsuntoAsuntoTipoOficinaMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodClaseAsunto], [TN_CodAsunto], [TN_CodTipoOficina], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[ClaseAsuntoAsuntoTipoOficinaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_ClaseAsuntoAsuntoTipoOficinaMateria_Asunto]
	FOREIGN KEY ([TN_CodAsunto]) REFERENCES [Catalogo].[Asunto] ([TN_CodAsunto])
ALTER TABLE [Catalogo].[ClaseAsuntoAsuntoTipoOficinaMateria]
	CHECK CONSTRAINT [FK_ClaseAsuntoAsuntoTipoOficinaMateria_Asunto]

GO
ALTER TABLE [Catalogo].[ClaseAsuntoAsuntoTipoOficinaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_ClaseAsuntoAsuntoTipoOficinaMateria_ClaseAsunto]
	FOREIGN KEY ([TN_CodClaseAsunto]) REFERENCES [Catalogo].[ClaseAsunto] ([TN_CodClaseAsunto])
ALTER TABLE [Catalogo].[ClaseAsuntoAsuntoTipoOficinaMateria]
	CHECK CONSTRAINT [FK_ClaseAsuntoAsuntoTipoOficinaMateria_ClaseAsunto]

GO
ALTER TABLE [Catalogo].[ClaseAsuntoAsuntoTipoOficinaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_ClaseAsuntoAsuntoTipoOficinaMateria_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[ClaseAsuntoAsuntoTipoOficinaMateria]
	CHECK CONSTRAINT [FK_ClaseAsuntoAsuntoTipoOficinaMateria_TipoOficinaMateria]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene los codigos de  clase asunto-asunto-tipo oficina-materia', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoAsuntoTipoOficinaMateria', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la clase de asunto', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoAsuntoTipoOficinaMateria', 'COLUMN', N'TN_CodClaseAsunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del asunto', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoAsuntoTipoOficinaMateria', 'COLUMN', N'TN_CodAsunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoAsuntoTipoOficinaMateria', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la materia', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoAsuntoTipoOficinaMateria', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de iniciio de la asociacion', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsuntoAsuntoTipoOficinaMateria', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[ClaseAsuntoAsuntoTipoOficinaMateria] SET (LOCK_ESCALATION = TABLE)
GO

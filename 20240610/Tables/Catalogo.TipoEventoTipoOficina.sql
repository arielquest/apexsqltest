SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoEventoTipoOficina] (
		[TN_CodTipoEvento]       [smallint] NOT NULL,
		[TN_CodTipoOficina]      [smallint] NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_TipoEventoTipoOficinaMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoEvento], [TN_CodTipoOficina], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoEventoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoEventoTipoOficinaMateria_TipoEvento]
	FOREIGN KEY ([TN_CodTipoEvento]) REFERENCES [Catalogo].[TipoEvento] ([TN_CodTipoEvento])
ALTER TABLE [Catalogo].[TipoEventoTipoOficina]
	CHECK CONSTRAINT [FK_TipoEventoTipoOficinaMateria_TipoEvento]

GO
ALTER TABLE [Catalogo].[TipoEventoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoEventoTipoOficinaMateria_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[TipoEventoTipoOficina]
	CHECK CONSTRAINT [FK_TipoEventoTipoOficinaMateria_TipoOficinaMateria]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia los tipos de evento según el tipo de oficina y materia', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEventoTipoOficina', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEventoTipoOficina', 'COLUMN', N'TN_CodTipoEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEventoTipoOficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEventoTipoOficina', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEventoTipoOficina', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoEventoTipoOficina] SET (LOCK_ESCALATION = TABLE)
GO

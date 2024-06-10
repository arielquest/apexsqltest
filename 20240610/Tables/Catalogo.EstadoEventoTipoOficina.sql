SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoEventoTipoOficina] (
		[TN_CodEstadoEvento]     [smallint] NOT NULL,
		[TN_CodTipoOficina]      [smallint] NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_EstadoEventoTipoOficinaMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstadoEvento], [TN_CodTipoOficina], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoEventoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_EstadoEventoTipoOficinaMateria_EstadoEvento]
	FOREIGN KEY ([TN_CodEstadoEvento]) REFERENCES [Catalogo].[EstadoEvento] ([TN_CodEstadoEvento])
ALTER TABLE [Catalogo].[EstadoEventoTipoOficina]
	CHECK CONSTRAINT [FK_EstadoEventoTipoOficinaMateria_EstadoEvento]

GO
ALTER TABLE [Catalogo].[EstadoEventoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_EstadoEventoTipoOficinaMateria_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[EstadoEventoTipoOficina]
	CHECK CONSTRAINT [FK_EstadoEventoTipoOficinaMateria_TipoOficinaMateria]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia los estados de evento según el tipo de oficina y materia', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoEventoTipoOficina', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado de evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoEventoTipoOficina', 'COLUMN', N'TN_CodEstadoEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoEventoTipoOficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoEventoTipoOficina', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoEventoTipoOficina', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[EstadoEventoTipoOficina] SET (LOCK_ESCALATION = TABLE)
GO

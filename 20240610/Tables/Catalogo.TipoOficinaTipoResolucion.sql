SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoOficinaTipoResolucion] (
		[TN_CodTipoOficina]        [smallint] NOT NULL,
		[TN_CodTipoResolucion]     [smallint] NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](7) NULL,
		[TC_CodMateria]            [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_TipoOficinaTipoResolucion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoOficina], [TN_CodTipoResolucion], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoOficinaTipoResolucion]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaTipoResolucion_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[TipoOficinaTipoResolucion]
	CHECK CONSTRAINT [FK_TipoOficinaTipoResolucion_TipoOficinaMateria]

GO
ALTER TABLE [Catalogo].[TipoOficinaTipoResolucion]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaTipoResolucion_TipoResolucion]
	FOREIGN KEY ([TN_CodTipoResolucion]) REFERENCES [Catalogo].[TipoResolucion] ([TN_CodTipoResolucion])
ALTER TABLE [Catalogo].[TipoOficinaTipoResolucion]
	CHECK CONSTRAINT [FK_TipoOficinaTipoResolucion_TipoResolucion]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia tipo de oficina con resultado de resolución.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaTipoResolucion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaTipoResolucion', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de resolucion asociado al tipo de oficina y materia', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaTipoResolucion', 'COLUMN', N'TN_CodTipoResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaTipoResolucion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Materia asociado al tipo de resolución', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaTipoResolucion', 'COLUMN', N'TC_CodMateria'
GO
ALTER TABLE [Catalogo].[TipoOficinaTipoResolucion] SET (LOCK_ESCALATION = TABLE)
GO

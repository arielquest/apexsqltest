SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Catalogo].[TipoOficinaTipoViabilidad] (
		[TN_CodTipoOficina]        [smallint] NOT NULL,
		[TN_CodTipoViabilidad]     [smallint] NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](7) NULL,
		CONSTRAINT [PK_TipoOficinaTipoViabilidad]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoOficina], [TN_CodTipoViabilidad])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoOficinaTipoViabilidad]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaTipoViabilidad_TipoOficina]
	FOREIGN KEY ([TN_CodTipoOficina]) REFERENCES [Catalogo].[TipoOficina] ([TN_CodTipoOficina])
ALTER TABLE [Catalogo].[TipoOficinaTipoViabilidad]
	CHECK CONSTRAINT [FK_TipoOficinaTipoViabilidad_TipoOficina]

GO
ALTER TABLE [Catalogo].[TipoOficinaTipoViabilidad]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaTipoViabilidad_TipoViabilidad]
	FOREIGN KEY ([TN_CodTipoViabilidad]) REFERENCES [Catalogo].[TipoViabilidad] ([TN_CodTipoViabilidad])
ALTER TABLE [Catalogo].[TipoOficinaTipoViabilidad]
	CHECK CONSTRAINT [FK_TipoOficinaTipoViabilidad_TipoViabilidad]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia los tipos de oficina con sus tipos de viabilidad.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaTipoViabilidad', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaTipoViabilidad', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de viabilidad.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaTipoViabilidad', 'COLUMN', N'TN_CodTipoViabilidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaTipoViabilidad', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoOficinaTipoViabilidad] SET (LOCK_ESCALATION = TABLE)
GO

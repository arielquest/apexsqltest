SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoEscritoTipoOficina] (
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoEscrito]      [smallint] NOT NULL,
		[TN_CodTipoOficina]      [smallint] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](2) NULL,
		[TB_Urgente]             [bit] NOT NULL,
		CONSTRAINT [PK_TipoOficinaMateriaTipoEscrito_1]
		PRIMARY KEY
		CLUSTERED
		([TC_CodMateria], [TN_CodTipoEscrito], [TN_CodTipoOficina])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoEscritoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaMateriaTipoEscrito_TipoEscrito(Catalogo)]
	FOREIGN KEY ([TN_CodTipoEscrito]) REFERENCES [Catalogo].[TipoEscrito] ([TN_CodTipoEscrito])
ALTER TABLE [Catalogo].[TipoEscritoTipoOficina]
	CHECK CONSTRAINT [FK_TipoOficinaMateriaTipoEscrito_TipoEscrito(Catalogo)]

GO
ALTER TABLE [Catalogo].[TipoEscritoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaMateriaTipoEscrito_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[TipoEscritoTipoOficina]
	CHECK CONSTRAINT [FK_TipoOficinaMateriaTipoEscrito_TipoOficinaMateria]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador único de materia', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEscritoTipoOficina', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador único de tipo de escrito', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEscritoTipoOficina', 'COLUMN', N'TN_CodTipoEscrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador únido de tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEscritoTipoOficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEscritoTipoOficina', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el tipo de escrito para la materia en el tipo de oficina se debe de tramitar con urgencia.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEscritoTipoOficina', 'COLUMN', N'TB_Urgente'
GO
ALTER TABLE [Catalogo].[TipoEscritoTipoOficina] SET (LOCK_ESCALATION = TABLE)
GO

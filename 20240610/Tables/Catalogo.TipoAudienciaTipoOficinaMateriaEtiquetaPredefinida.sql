SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida] (
		[TN_CodTipoAudiencia]           [smallint] NOT NULL,
		[TN_CodTipoOficina]             [smallint] NOT NULL,
		[TC_CodMateria]                 [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodEtiquetaPredefinida]     [smallint] NOT NULL,
		[TF_Fin_Vigencia]               [datetime2](2) NULL,
		CONSTRAINT [PK_TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoAudiencia], [TN_CodTipoOficina], [TC_CodMateria], [TC_CodEtiquetaPredefinida])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida_EtiquetaPredefinida1]
	FOREIGN KEY ([TC_CodEtiquetaPredefinida]) REFERENCES [Catalogo].[EtiquetaPredefinida] ([TN_CodEtiquetaPredefinida])
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida]
	CHECK CONSTRAINT [FK_TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida_EtiquetaPredefinida1]

GO
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida_Materia1]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida]
	CHECK CONSTRAINT [FK_TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida_Materia1]

GO
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida_TipoAudiencia1]
	FOREIGN KEY ([TN_CodTipoAudiencia]) REFERENCES [Catalogo].[TipoAudiencia] ([TN_CodTipoAudiencia])
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida]
	CHECK CONSTRAINT [FK_TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida_TipoAudiencia1]

GO
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida_TipoOficina1]
	FOREIGN KEY ([TN_CodTipoOficina]) REFERENCES [Catalogo].[TipoOficina] ([TN_CodTipoOficina])
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida]
	CHECK CONSTRAINT [FK_TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida_TipoOficina1]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador del tipo de audiencia.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida', 'COLUMN', N'TN_CodTipoAudiencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador del tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador de la materia', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador de la etiqueta predefinida.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida', 'COLUMN', N'TC_CodEtiquetaPredefinida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida] SET (LOCK_ESCALATION = TABLE)
GO

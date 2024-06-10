SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EtiquetaPredefinidaTipoAudienciaTipoOficina] (
		[TN_CodEtiquetaPredefinida]     [smallint] NOT NULL,
		[TN_CodTipoAudiencia]           [smallint] NOT NULL,
		[TN_CodTipoOficina]             [smallint] NOT NULL,
		[TC_CodMateria]                 [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]            [datetime2](3) NULL,
		CONSTRAINT [PK_EtiquetaPredefinidaTipoAudienciaTipoOficina]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEtiquetaPredefinida], [TN_CodTipoAudiencia], [TN_CodTipoOficina], [TC_CodMateria])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[EtiquetaPredefinidaTipoAudienciaTipoOficina]
	ADD
	CONSTRAINT [DF_EtiquetaPredefinidaTipoAudienciaTipoOficina_TN_CodEtiquetaPredefinida]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEtiquetaPredefinidaTipoAudienciaTipoOficina]) FOR [TN_CodEtiquetaPredefinida]
GO
ALTER TABLE [Catalogo].[EtiquetaPredefinidaTipoAudienciaTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_EtiquetaPredefinidaTipoAudienciaTipoOficina_TN_CodTipoAudiencia_TN_CodTipoOficina_TC_CodMateria]
	FOREIGN KEY ([TC_CodMateria], [TN_CodTipoAudiencia], [TN_CodTipoOficina]) REFERENCES [Catalogo].[TipoAudienciaTipoOficina] ([TC_CodMateria], [TN_CodTipoAudiencia], [TN_CodTipoOficina])
ALTER TABLE [Catalogo].[EtiquetaPredefinidaTipoAudienciaTipoOficina]
	CHECK CONSTRAINT [FK_EtiquetaPredefinidaTipoAudienciaTipoOficina_TN_CodTipoAudiencia_TN_CodTipoOficina_TC_CodMateria]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del Tipo de etiqueta predefinida', 'SCHEMA', N'Catalogo', 'TABLE', N'EtiquetaPredefinidaTipoAudienciaTipoOficina', 'COLUMN', N'TN_CodEtiquetaPredefinida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del Tipo de tipo de audiencia', 'SCHEMA', N'Catalogo', 'TABLE', N'EtiquetaPredefinidaTipoAudienciaTipoOficina', 'COLUMN', N'TN_CodTipoAudiencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del Tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'EtiquetaPredefinidaTipoAudienciaTipoOficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del Tipo de Materia', 'SCHEMA', N'Catalogo', 'TABLE', N'EtiquetaPredefinidaTipoAudienciaTipoOficina', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia de la etiqueta prefefinidad asociada al tipo de audiencia y materia y oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'EtiquetaPredefinidaTipoAudienciaTipoOficina', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[EtiquetaPredefinidaTipoAudienciaTipoOficina] SET (LOCK_ESCALATION = TABLE)
GO

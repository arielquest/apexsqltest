SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoAudienciaTipoOficina] (
		[TC_CodMateria]           [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoAudiencia]     [smallint] NOT NULL,
		[TN_CodTipoOficina]       [smallint] NOT NULL,
		[TF_Inicio_Vigencia]      [datetime2](2) NULL,
		CONSTRAINT [PK_TipoOficinaMateriaTipoAudiencia]
		PRIMARY KEY
		CLUSTERED
		([TC_CodMateria], [TN_CodTipoAudiencia], [TN_CodTipoOficina])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaMateriaTipoAudiencia_TipoAudiencia(Catalogo)]
	FOREIGN KEY ([TN_CodTipoAudiencia]) REFERENCES [Catalogo].[TipoAudiencia] ([TN_CodTipoAudiencia])
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficina]
	CHECK CONSTRAINT [FK_TipoOficinaMateriaTipoAudiencia_TipoAudiencia(Catalogo)]

GO
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaMateriaTipoAudiencia_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficina]
	CHECK CONSTRAINT [FK_TipoOficinaMateriaTipoAudiencia_TipoOficinaMateria]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la materia', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudienciaTipoOficina', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del tipo de audiencia.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudienciaTipoOficina', 'COLUMN', N'TN_CodTipoAudiencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudienciaTipoOficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoAudienciaTipoOficina', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoAudienciaTipoOficina] SET (LOCK_ESCALATION = TABLE)
GO

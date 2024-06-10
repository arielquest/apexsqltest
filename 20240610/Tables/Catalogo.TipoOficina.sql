SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoOficina] (
		[TN_CodTipoOficina]      [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](3) NULL,
		[CODTIDEJ]               [varchar](400) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [TipoDespacho_PK]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoOficina])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoOficina]
	ADD
	CONSTRAINT [DF_TipoOficina_TN_CodTipoOficina]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoOficina]) FOR [TN_CodTipoOficina]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficina', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficina', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficina', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficina', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoOficina] SET (LOCK_ESCALATION = TABLE)
GO

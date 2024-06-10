SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoEscrito] (
		[TN_CodTipoEscrito]      [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](2) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](2) NULL,
		[CODTIPDOC]              [varchar](12) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_TipoEscrito(Catalogo)_1]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoEscrito])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoEscrito]
	ADD
	CONSTRAINT [DF_TipoEscrito_TN_CodTipoEscrito]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoEscrito]) FOR [TN_CodTipoEscrito]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo donde se registran los tipos de escritos', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEscrito', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de escrito', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEscrito', 'COLUMN', N'TN_CodTipoEscrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de escrito', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEscrito', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEscrito', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEscrito', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEscrito', 'COLUMN', N'CODTIPDOC'
GO
ALTER TABLE [Catalogo].[TipoEscrito] SET (LOCK_ESCALATION = TABLE)
GO

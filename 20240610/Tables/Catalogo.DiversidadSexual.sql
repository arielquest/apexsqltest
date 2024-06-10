SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[DiversidadSexual] (
		[TN_CodDiversidadSexual]     [smallint] NOT NULL,
		[TC_Descripcion]             [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]         [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]            [datetime2](7) NULL,
		[CODDIVER]                   [varchar](12) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_DiversidadSexual]
		PRIMARY KEY
		CLUSTERED
		([TN_CodDiversidadSexual])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[DiversidadSexual]
	ADD
	CONSTRAINT [DF_DiversidadSexual_TN_CodDiversidadSexual]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaDiversidadSexual]) FOR [TN_CodDiversidadSexual]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de diversidad sexual.', 'SCHEMA', N'Catalogo', 'TABLE', N'DiversidadSexual', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de diversidad sexual.', 'SCHEMA', N'Catalogo', 'TABLE', N'DiversidadSexual', 'COLUMN', N'TN_CodDiversidadSexual'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de diversidad sexual.', 'SCHEMA', N'Catalogo', 'TABLE', N'DiversidadSexual', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'DiversidadSexual', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'DiversidadSexual', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[DiversidadSexual] SET (LOCK_ESCALATION = TABLE)
GO

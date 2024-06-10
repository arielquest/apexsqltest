SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Idioma] (
		[TN_CodIdioma]           [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODIDIOMA]              [varchar](12) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Idioma]
		PRIMARY KEY
		CLUSTERED
		([TN_CodIdioma])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Idioma]
	ADD
	CONSTRAINT [DF_Idioma_TN_CodIdioma]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaIdioma]) FOR [TN_CodIdioma]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de idiomas.', 'SCHEMA', N'Catalogo', 'TABLE', N'Idioma', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del idioma.', 'SCHEMA', N'Catalogo', 'TABLE', N'Idioma', 'COLUMN', N'TN_CodIdioma'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del idioma.', 'SCHEMA', N'Catalogo', 'TABLE', N'Idioma', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Idioma', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Idioma', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Idioma] SET (LOCK_ESCALATION = TABLE)
GO

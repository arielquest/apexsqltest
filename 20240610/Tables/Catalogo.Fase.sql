SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Fase] (
		[TN_CodFase]             [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](3) NULL,
		[CODFAS]                 [varchar](6) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [Fase_PK]
		PRIMARY KEY
		CLUSTERED
		([TN_CodFase])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Fase]
	ADD
	CONSTRAINT [DF_Fase_TN_CodFase]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaFase]) FOR [TN_CodFase]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de fases del expediente.', 'SCHEMA', N'Catalogo', 'TABLE', N'Fase', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la fase.', 'SCHEMA', N'Catalogo', 'TABLE', N'Fase', 'COLUMN', N'TN_CodFase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la fase.', 'SCHEMA', N'Catalogo', 'TABLE', N'Fase', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Fase', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Fase', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Fase', 'COLUMN', N'CODFAS'
GO
ALTER TABLE [Catalogo].[Fase] SET (LOCK_ESCALATION = TABLE)
GO

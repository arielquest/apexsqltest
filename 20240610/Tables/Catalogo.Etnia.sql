SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Etnia] (
		[TN_CodEtnia]            [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODETN]                 [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Etnia]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEtnia])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Etnia]
	ADD
	CONSTRAINT [DF_Etnia_TN_CodEtnia]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEtnia]) FOR [TN_CodEtnia]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de las diferentes etnias existentes.', 'SCHEMA', N'Catalogo', 'TABLE', N'Etnia', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la etnia.', 'SCHEMA', N'Catalogo', 'TABLE', N'Etnia', 'COLUMN', N'TN_CodEtnia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la etnia.', 'SCHEMA', N'Catalogo', 'TABLE', N'Etnia', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Etnia', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Etnia', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Etnia', 'COLUMN', N'CODETN'
GO
ALTER TABLE [Catalogo].[Etnia] SET (LOCK_ESCALATION = TABLE)
GO

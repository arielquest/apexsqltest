SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Escolaridad] (
		[TN_CodEscolaridad]      [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODESCO]                [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Escolaridad]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEscolaridad])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Escolaridad]
	ADD
	CONSTRAINT [DF_Escolaridad_TN_CodEscolaridad]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEscolaridad]) FOR [TN_CodEscolaridad]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de escolaridad.', 'SCHEMA', N'Catalogo', 'TABLE', N'Escolaridad', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de escolaridad.', 'SCHEMA', N'Catalogo', 'TABLE', N'Escolaridad', 'COLUMN', N'TN_CodEscolaridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la escolaridad.', 'SCHEMA', N'Catalogo', 'TABLE', N'Escolaridad', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Escolaridad', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Escolaridad', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Escolaridad', 'COLUMN', N'CODESCO'
GO
ALTER TABLE [Catalogo].[Escolaridad] SET (LOCK_ESCALATION = TABLE)
GO

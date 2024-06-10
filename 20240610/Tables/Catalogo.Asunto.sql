SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Asunto] (
		[TN_CodAsunto]           [int] NOT NULL,
		[TC_Descripcion]         [varchar](200) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODASU]                 [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Asunto]
		PRIMARY KEY
		CLUSTERED
		([TN_CodAsunto])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Asunto]
	ADD
	CONSTRAINT [DF_Asunto_TN_CodAsunto]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaAsunto]) FOR [TN_CodAsunto]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de asunto.', 'SCHEMA', N'Catalogo', 'TABLE', N'Asunto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del asunto.', 'SCHEMA', N'Catalogo', 'TABLE', N'Asunto', 'COLUMN', N'TN_CodAsunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del asunto.', 'SCHEMA', N'Catalogo', 'TABLE', N'Asunto', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Asunto', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Asunto', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Asunto', 'COLUMN', N'CODASU'
GO
ALTER TABLE [Catalogo].[Asunto] SET (LOCK_ESCALATION = TABLE)
GO

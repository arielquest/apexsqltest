SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Vulnerabilidad] (
		[TN_CodVulnerabilidad]     [smallint] NOT NULL,
		[TC_Descripcion]           [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]          [datetime2](7) NULL,
		CONSTRAINT [PK_Vulnerabilidad]
		PRIMARY KEY
		CLUSTERED
		([TN_CodVulnerabilidad])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Vulnerabilidad]
	ADD
	CONSTRAINT [DF_Vulnerabilidad_TN_CodVulnerabilidad]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaVulnerabilidad]) FOR [TN_CodVulnerabilidad]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de vulnerabilidades del interviniente.', 'SCHEMA', N'Catalogo', 'TABLE', N'Vulnerabilidad', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de vulnerabilidad.', 'SCHEMA', N'Catalogo', 'TABLE', N'Vulnerabilidad', 'COLUMN', N'TN_CodVulnerabilidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la vulnerabilidad.', 'SCHEMA', N'Catalogo', 'TABLE', N'Vulnerabilidad', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Vulnerabilidad', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Vulnerabilidad', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Vulnerabilidad] SET (LOCK_ESCALATION = TABLE)
GO

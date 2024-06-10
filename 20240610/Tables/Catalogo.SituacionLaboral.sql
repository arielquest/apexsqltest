SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[SituacionLaboral] (
		[TN_CodSituacionLaboral]     [smallint] NOT NULL,
		[TC_Descripcion]             [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]         [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]            [datetime2](7) NULL,
		[CODLAB]                     [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_SituacionLaboral]
		PRIMARY KEY
		CLUSTERED
		([TN_CodSituacionLaboral])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[SituacionLaboral]
	ADD
	CONSTRAINT [DF_SituacionLaboral_TN_CodSituacionLaboral]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaSituacionLaboral]) FOR [TN_CodSituacionLaboral]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de situación laboral.', 'SCHEMA', N'Catalogo', 'TABLE', N'SituacionLaboral', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de situación laboral.', 'SCHEMA', N'Catalogo', 'TABLE', N'SituacionLaboral', 'COLUMN', N'TN_CodSituacionLaboral'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de situacion laboral.', 'SCHEMA', N'Catalogo', 'TABLE', N'SituacionLaboral', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'SituacionLaboral', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'SituacionLaboral', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'SituacionLaboral', 'COLUMN', N'CODLAB'
GO
ALTER TABLE [Catalogo].[SituacionLaboral] SET (LOCK_ESCALATION = TABLE)
GO

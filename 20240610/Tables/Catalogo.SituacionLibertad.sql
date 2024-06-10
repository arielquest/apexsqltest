SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[SituacionLibertad] (
		[TN_CodSituacionLibertad]     [smallint] NOT NULL,
		[TC_Descripcion]              [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]          [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]             [datetime2](7) NULL,
		[CODLAB]                      [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_SituacionLibertad]
		PRIMARY KEY
		CLUSTERED
		([TN_CodSituacionLibertad])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[SituacionLibertad]
	ADD
	CONSTRAINT [DF_SituacionLibertad_TN_CodSituacionLibertad]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaSituacionLibertad]) FOR [TN_CodSituacionLibertad]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que almacena la situación de libertad.', 'SCHEMA', N'Catalogo', 'TABLE', N'SituacionLibertad', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de situacion de libertad.', 'SCHEMA', N'Catalogo', 'TABLE', N'SituacionLibertad', 'COLUMN', N'TN_CodSituacionLibertad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de situacion de libertad.', 'SCHEMA', N'Catalogo', 'TABLE', N'SituacionLibertad', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'SituacionLibertad', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'SituacionLibertad', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[SituacionLibertad] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Pais] (
		[TC_CodPais]                  [varchar](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]              [varchar](70) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodArea]                  [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_RequiereRegionalidad]     [bit] NOT NULL,
		[TF_Inicio_Vigencia]          [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]             [datetime2](7) NULL,
		CONSTRAINT [PK_Pais]
		PRIMARY KEY
		CLUSTERED
		([TC_CodPais])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Pais]
	ADD
	CONSTRAINT [DF_Pais_TB_Requiere]
	DEFAULT ((0)) FOR [TB_RequiereRegionalidad]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de países.', 'SCHEMA', N'Catalogo', 'TABLE', N'Pais', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código internacional con el cual se reconoce al país.', 'SCHEMA', N'Catalogo', 'TABLE', N'Pais', 'COLUMN', N'TC_CodPais'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del país.', 'SCHEMA', N'Catalogo', 'TABLE', N'Pais', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de area del país.', 'SCHEMA', N'Catalogo', 'TABLE', N'Pais', 'COLUMN', N'TC_CodArea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el país requiere regionalidad de provincia, cantón, distrito y barrio.', 'SCHEMA', N'Catalogo', 'TABLE', N'Pais', 'COLUMN', N'TB_RequiereRegionalidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Pais', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Pais', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Pais] SET (LOCK_ESCALATION = TABLE)
GO

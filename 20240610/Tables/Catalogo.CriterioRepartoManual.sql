SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[CriterioRepartoManual] (
		[TN_CodCriterioRepartoManual]     [int] NOT NULL,
		[TC_Descripcion]                  [varchar](120) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]              [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]                 [datetime2](3) NULL,
		CONSTRAINT [PK_CriterioRepartoManual]
		PRIMARY KEY
		CLUSTERED
		([TN_CodCriterioRepartoManual])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[CriterioRepartoManual]
	ADD
	CONSTRAINT [DF_CriterioRepartoManual_TN_CodCriterioManual]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaCriterioRepartoManual]) FOR [TN_CodCriterioRepartoManual]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del criterio de reparto manual', 'SCHEMA', N'Catalogo', 'TABLE', N'CriterioRepartoManual', 'COLUMN', N'TN_CodCriterioRepartoManual'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del criterio de reparto manual', 'SCHEMA', N'Catalogo', 'TABLE', N'CriterioRepartoManual', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'CriterioRepartoManual', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'CriterioRepartoManual', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[CriterioRepartoManual] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[PeriodoAntirretroviral] (
		[TN_CodPeriodoAntirretro]     [smallint] NOT NULL,
		[TC_Descripcion]              [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]          [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]             [datetime2](7) NULL,
		[CODPERIODOANTI]              [varchar](12) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_PeriodoAntirretrovirales]
		PRIMARY KEY
		CLUSTERED
		([TN_CodPeriodoAntirretro])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[PeriodoAntirretroviral]
	ADD
	CONSTRAINT [DF_PeriodoAntirretroviral_TC_CodPeriodoAntirretro]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaAntirretroviral]) FOR [TN_CodPeriodoAntirretro]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que corresponde a los períodos de tiempo en que se le suministran antirretrovirales a las personas víctimas sexuales.', 'SCHEMA', N'Catalogo', 'TABLE', N'PeriodoAntirretroviral', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del periodo de suministro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PeriodoAntirretroviral', 'COLUMN', N'TN_CodPeriodoAntirretro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del periodo de suministro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PeriodoAntirretroviral', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PeriodoAntirretroviral', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PeriodoAntirretroviral', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[PeriodoAntirretroviral] SET (LOCK_ESCALATION = TABLE)
GO

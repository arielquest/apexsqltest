SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MotivoDictamen] (
		[TN_CodMotivoDictamen]     [smallint] NOT NULL,
		[TC_Descripcion]           [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]          [datetime2](7) NULL,
		[TDM_MOTIVO]               [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_MotivoDictamen]
		PRIMARY KEY
		CLUSTERED
		([TN_CodMotivoDictamen])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MotivoDictamen]
	ADD
	CONSTRAINT [DF_MotivoDictamen_TN_CodMotivoDictamen]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaMotivoDictamen]) FOR [TN_CodMotivoDictamen]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de motivos de dictamen.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDictamen', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de dictamen.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDictamen', 'COLUMN', N'TN_CodMotivoDictamen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del motivo de dictamen.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDictamen', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDictamen', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDictamen', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[MotivoDictamen] SET (LOCK_ESCALATION = TABLE)
GO

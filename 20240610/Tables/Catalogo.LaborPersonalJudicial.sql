SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[LaborPersonalJudicial] (
		[TN_CodLaborPersonalJudicial]     [smallint] NOT NULL,
		[TC_Descripcion]                  [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_InicioVigencia]               [datetime2](7) NOT NULL,
		[TF_FinVigencia]                  [datetime2](7) NULL,
		CONSTRAINT [PK_LaborPersonalJudicial]
		PRIMARY KEY
		CLUSTERED
		([TN_CodLaborPersonalJudicial])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[LaborPersonalJudicial]
	ADD
	CONSTRAINT [DF_LaborPersonalJudicial_TN_CodLaborPersonalJudicial]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaLaborPersonalJudicial]) FOR [TN_CodLaborPersonalJudicial]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para registrar las labores del personal judicial', 'SCHEMA', N'Catalogo', 'TABLE', N'LaborPersonalJudicial', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la labor del personal judicial', 'SCHEMA', N'Catalogo', 'TABLE', N'LaborPersonalJudicial', 'COLUMN', N'TN_CodLaborPersonalJudicial'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción para la labor del personal judicial', 'SCHEMA', N'Catalogo', 'TABLE', N'LaborPersonalJudicial', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro', 'SCHEMA', N'Catalogo', 'TABLE', N'LaborPersonalJudicial', 'COLUMN', N'TF_InicioVigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro', 'SCHEMA', N'Catalogo', 'TABLE', N'LaborPersonalJudicial', 'COLUMN', N'TF_FinVigencia'
GO
ALTER TABLE [Catalogo].[LaborPersonalJudicial] SET (LOCK_ESCALATION = TABLE)
GO

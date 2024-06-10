SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[SuspensionPrescripcion] (
		[TN_CodSuspensionPrescripcion]     [smallint] NOT NULL,
		[TC_Descripcion]                   [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]               [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]                  [datetime2](7) NULL,
		CONSTRAINT [PK_SuspencionPrescripcion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodSuspensionPrescripcion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[SuspensionPrescripcion]
	ADD
	CONSTRAINT [DF_SuspensionPrescripcion_TN_CodSuspensionPrescripcion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaSuspensionPrescripcion]) FOR [TN_CodSuspensionPrescripcion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de acto suspensivo de la prescripción de un delito.', 'SCHEMA', N'Catalogo', 'TABLE', N'SuspensionPrescripcion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la suspensión de prescripción.', 'SCHEMA', N'Catalogo', 'TABLE', N'SuspensionPrescripcion', 'COLUMN', N'TN_CodSuspensionPrescripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la suspensión de prescripción.', 'SCHEMA', N'Catalogo', 'TABLE', N'SuspensionPrescripcion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'SuspensionPrescripcion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'SuspensionPrescripcion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[SuspensionPrescripcion] SET (LOCK_ESCALATION = TABLE)
GO

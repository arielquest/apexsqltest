SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[InterrupcionPrescripcion] (
		[TN_CodInterrupcion]         [smallint] NOT NULL,
		[TC_Descripcion]             [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]         [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]            [datetime2](7) NULL,
		[TACP_ACTO_PRESCRIPCION]     [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_InterrupcionPrescripcion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodInterrupcion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[InterrupcionPrescripcion]
	ADD
	CONSTRAINT [DF_InterrupcionPrescripcion_TN_CodInterrupcion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaInterrupcionPrescripcion]) FOR [TN_CodInterrupcion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de actos de interrupción de prescipción.', 'SCHEMA', N'Catalogo', 'TABLE', N'InterrupcionPrescripcion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del acto de interrupción de prescripción.', 'SCHEMA', N'Catalogo', 'TABLE', N'InterrupcionPrescripcion', 'COLUMN', N'TN_CodInterrupcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del acto de interrupción de prescripción.', 'SCHEMA', N'Catalogo', 'TABLE', N'InterrupcionPrescripcion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'InterrupcionPrescripcion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'InterrupcionPrescripcion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[InterrupcionPrescripcion] SET (LOCK_ESCALATION = TABLE)
GO

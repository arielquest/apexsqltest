SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[ResultadoResolucion] (
		[TN_CodResultadoResolucion]     [smallint] NOT NULL,
		[TC_Descripcion]                [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]            [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]               [datetime2](7) NULL,
		[CODRESUL]                      [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_T_ResultadoResolucion]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodResultadoResolucion])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[ResultadoResolucion]
	ADD
	CONSTRAINT [DF_ResultadoResolucion_TN_CodResultadoResolucion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaResultadoResolucion]) FOR [TN_CodResultadoResolucion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de resultados de resolución.', 'SCHEMA', N'Catalogo', 'TABLE', N'ResultadoResolucion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de resultado de resolución.', 'SCHEMA', N'Catalogo', 'TABLE', N'ResultadoResolucion', 'COLUMN', N'TN_CodResultadoResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del resultado de resolución.', 'SCHEMA', N'Catalogo', 'TABLE', N'ResultadoResolucion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'ResultadoResolucion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'ResultadoResolucion', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'ResultadoResolucion', 'COLUMN', N'CODRESUL'
GO
ALTER TABLE [Catalogo].[ResultadoResolucion] SET (LOCK_ESCALATION = TABLE)
GO

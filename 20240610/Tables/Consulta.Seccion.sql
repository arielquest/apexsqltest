SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Consulta].[Seccion] (
		[TN_CodSeccion]          [smallint] NOT NULL,
		[TC_Nombre]              [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_Seccion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodSeccion])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Consulta].[Seccion]
	ADD
	CONSTRAINT [FechaInicioMenorIgualFechaFin]
	CHECK
	(CONVERT([date],[TF_Inicio_Vigencia])<=CONVERT([date],[TF_Fin_Vigencia]))
GO
ALTER TABLE [Consulta].[Seccion]
CHECK CONSTRAINT [FechaInicioMenorIgualFechaFin]
GO
ALTER TABLE [Consulta].[Seccion]
	ADD
	CONSTRAINT [DF_Seccion_TC_CodSeccion]
	DEFAULT (NEXT VALUE FOR [Consulta].[SecuenciaSeccion]) FOR [TN_CodSeccion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Secciones de consulta.', 'SCHEMA', N'Consulta', 'TABLE', N'Seccion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la sección.', 'SCHEMA', N'Consulta', 'TABLE', N'Seccion', 'COLUMN', N'TN_CodSeccion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la sección.', 'SCHEMA', N'Consulta', 'TABLE', N'Seccion', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Consulta', 'TABLE', N'Seccion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Consulta', 'TABLE', N'Seccion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Consulta].[Seccion] SET (LOCK_ESCALATION = TABLE)
GO

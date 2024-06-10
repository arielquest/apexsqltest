SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Comunicacion].[PreguntasFrecuentes] (
		[TN_CodPregunta]         [smallint] NOT NULL,
		[TC_Pregunta]            [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Respuesta]           [varchar](500) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Sistema]             [varchar](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[TF_Particion]           [datetime2](7) NOT NULL,
		CONSTRAINT [PK_PreguntasFrecuentes]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodPregunta])
	ON [PRIMARY]
) ON [ComunicacionPS] ([TF_Particion])
GO
ALTER TABLE [Comunicacion].[PreguntasFrecuentes]
	ADD
	CONSTRAINT [DF_PreguntasFrecuentes_TN_CodPregunta]
	DEFAULT (NEXT VALUE FOR [Comunicacion].[SecuenciaPreguntaFrecuente]) FOR [TN_CodPregunta]
GO
ALTER TABLE [Comunicacion].[PreguntasFrecuentes]
	ADD
	CONSTRAINT [DF__Preguntas__TF_Pa__2D89416A]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
CREATE CLUSTERED INDEX [IX_Comunicacion_PreguntasFrecuentes_TF_Particion]
	ON [Comunicacion].[PreguntasFrecuentes] ([TF_Particion])
	ON [ComunicacionPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la pregunta frecuente', 'SCHEMA', N'Comunicacion', 'TABLE', N'PreguntasFrecuentes', 'COLUMN', N'TN_CodPregunta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Pregunta Frecuente que se desea registrar', 'SCHEMA', N'Comunicacion', 'TABLE', N'PreguntasFrecuentes', 'COLUMN', N'TC_Pregunta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Respuesta a la pregunta frecuente', 'SCHEMA', N'Comunicacion', 'TABLE', N'PreguntasFrecuentes', 'COLUMN', N'TC_Respuesta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Enumerador del sistema donde debe visualizarse la pregunta frecuente', 'SCHEMA', N'Comunicacion', 'TABLE', N'PreguntasFrecuentes', 'COLUMN', N'TC_Sistema'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro', 'SCHEMA', N'Comunicacion', 'TABLE', N'PreguntasFrecuentes', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro', 'SCHEMA', N'Comunicacion', 'TABLE', N'PreguntasFrecuentes', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Comunicacion].[PreguntasFrecuentes] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoActividadProgramada] (
		[TN_CodEstadoActividad]     [smallint] NOT NULL,
		[TC_Descripcion]            [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]           [datetime2](7) NULL,
		[TEAP_ESTADO_ACTIVIDAD]     [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_EstadoActividadProgramada]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstadoActividad])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoActividadProgramada]
	ADD
	CONSTRAINT [DF_EstadoActividadProgramada_TN_CodEstadoActividad]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEstadoActividadProgramada]) FOR [TN_CodEstadoActividad]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de estados de una actividad programada.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoActividadProgramada', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado de la actividad programada.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoActividadProgramada', 'COLUMN', N'TN_CodEstadoActividad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del estado de la actividad programada.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoActividadProgramada', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoActividadProgramada', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoActividadProgramada', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[EstadoActividadProgramada] SET (LOCK_ESCALATION = TABLE)
GO

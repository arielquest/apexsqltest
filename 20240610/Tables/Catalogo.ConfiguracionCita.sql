SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[ConfiguracionCita] (
		[TU_CodConfiguracion]       [uniqueidentifier] NOT NULL,
		[TF_HoraInicio]             [time](7) NOT NULL,
		[TF_HoraFin]                [time](7) NOT NULL,
		[TF_HoraInicioAlmuerzo]     [time](7) NOT NULL,
		[TC_CodContexto]            [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_TiempoAtencion]         [smallint] NOT NULL,
		[TF_FechaInicio]            [datetime2](7) NOT NULL,
		[TF_FechaFinal]             [datetime2](7) NULL,
		[TB_HabilitaFinSemana]      [bit] NOT NULL,
		[TF_Particion]              [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ConfiguracionCita]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodConfiguracion])
	ON [FG_SIAGPJ]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[ConfiguracionCita]
	ADD
	CONSTRAINT [DF_tb_habilitaFinSemana]
	DEFAULT ((0)) FOR [TB_HabilitaFinSemana]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Llave de la tabla', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionCita', 'COLUMN', N'TU_CodConfiguracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Hora de inicio de la atención de citas', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionCita', 'COLUMN', N'TF_HoraInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Hora fin de la atención de citas', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionCita', 'COLUMN', N'TF_HoraFin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Hora de inicio del almuerzo', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionCita', 'COLUMN', N'TF_HoraInicioAlmuerzo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionCita', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica la duración de las citas en minutos (15, 20, 25, 30 y 60)', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionCita', 'COLUMN', N'TN_TiempoAtencion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica la fecha de inicio de las citas', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionCita', 'COLUMN', N'TF_FechaInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica la fecha de final de las citas', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionCita', 'COLUMN', N'TF_FechaFinal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si se habilitan las citas para los fines de semana', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionCita', 'COLUMN', N'TB_HabilitaFinSemana'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica la fecha de registro para particionar', 'SCHEMA', N'Catalogo', 'TABLE', N'ConfiguracionCita', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Catalogo].[ConfiguracionCita] SET (LOCK_ESCALATION = TABLE)
GO

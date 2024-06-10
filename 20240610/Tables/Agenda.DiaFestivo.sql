SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Agenda].[DiaFestivo] (
		[TF_FechaFestivo]     [datetime2](7) NOT NULL,
		[TC_Descripcion]      [varchar](250) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_DiaFestivo]
		PRIMARY KEY
		CLUSTERED
		([TF_FechaFestivo])
	ON [FG_Agenda]
) ON [FG_Agenda]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla donde se indica los días festivos de los distintos circuitos', 'SCHEMA', N'Agenda', 'TABLE', N'DiaFestivo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se celebra el día festivo.', 'SCHEMA', N'Agenda', 'TABLE', N'DiaFestivo', 'COLUMN', N'TF_FechaFestivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del día festivo.', 'SCHEMA', N'Agenda', 'TABLE', N'DiaFestivo', 'COLUMN', N'TC_Descripcion'
GO
ALTER TABLE [Agenda].[DiaFestivo] SET (LOCK_ESCALATION = TABLE)
GO

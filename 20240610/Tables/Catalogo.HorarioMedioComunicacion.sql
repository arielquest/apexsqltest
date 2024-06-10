SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[HorarioMedioComunicacion] (
		[TN_CodHorario]          [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_HoraInicio]          [time](7) NOT NULL,
		[TF_HoraFin]             [time](7) NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[idhorario]              [varchar](2) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_HorarioMedioComunicacion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodHorario])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[HorarioMedioComunicacion]
	ADD
	CONSTRAINT [DF_HorarioMedioComunicacion_TN_CodHorario]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaHorarioMedioComunicacion]) FOR [TN_CodHorario]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador para el horario del medio de comunicación', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioMedioComunicacion', 'COLUMN', N'TN_CodHorario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del horario para los medios de comunicación', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioMedioComunicacion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Hora de inicio del horario', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioMedioComunicacion', 'COLUMN', N'TF_HoraInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Hora de finalizacion del horario', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioMedioComunicacion', 'COLUMN', N'TF_HoraFin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Inicio de vigencia del horario', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioMedioComunicacion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fin de vigencia para el horario ', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioMedioComunicacion', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'HorarioMedioComunicacion', 'COLUMN', N'idhorario'
GO
ALTER TABLE [Catalogo].[HorarioMedioComunicacion] SET (LOCK_ESCALATION = TABLE)
GO

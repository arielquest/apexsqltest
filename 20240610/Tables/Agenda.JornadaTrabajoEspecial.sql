SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Agenda].[JornadaTrabajoEspecial] (
		[TN_CodJornadaTrabajo]     [smallint] NOT NULL,
		[TC_CodPuestoTrabajo]      [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_DiaSemana]             [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_HoraInicio]            [time](7) NOT NULL,
		[TF_HoraFin]               [time](7) NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]          [datetime2](7) NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_JornadaTrabajoEspecial_1]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodJornadaTrabajo])
	ON [PRIMARY]
) ON [AgendaPS] ([TF_Particion])
GO
ALTER TABLE [Agenda].[JornadaTrabajoEspecial]
	ADD
	CONSTRAINT [CK_JornadaTrabajoEspecial_DiaSemana]
	CHECK
	([TC_DiaSemana]='D' OR [TC_DiaSemana]='S' OR [TC_DiaSemana]='V' OR [TC_DiaSemana]='J' OR [TC_DiaSemana]='M' OR [TC_DiaSemana]='K' OR [TC_DiaSemana]='L')
GO
ALTER TABLE [Agenda].[JornadaTrabajoEspecial]
CHECK CONSTRAINT [CK_JornadaTrabajoEspecial_DiaSemana]
GO
ALTER TABLE [Agenda].[JornadaTrabajoEspecial]
	ADD
	CONSTRAINT [DF_JornadaTrabajoEspecial_TN_CodJornadaTrabajo]
	DEFAULT (NEXT VALUE FOR [Agenda].[SecuenciaJornadaTrabajoEspecial]) FOR [TN_CodJornadaTrabajo]
GO
ALTER TABLE [Agenda].[JornadaTrabajoEspecial]
	ADD
	CONSTRAINT [DF__JornadaTr__TF_Pa__56C06127]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Agenda].[JornadaTrabajoEspecial]
	WITH CHECK
	ADD CONSTRAINT [FK_JornadaTrabajoEspecial_PuestoDeTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Agenda].[JornadaTrabajoEspecial]
	CHECK CONSTRAINT [FK_JornadaTrabajoEspecial_PuestoDeTrabajo]

GO
CREATE CLUSTERED INDEX [IX_Agenda_JornadaTrabajoEspecial_TF_Particion]
	ON [Agenda].[JornadaTrabajoEspecial] ([TF_Particion])
	ON [AgendaPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que almacena las jornadas de trabajo especiales en las que no se puede agendar a funcionarios. Si para un puesto de trabajo no se encuentran registros se asume que la jornada es normal de 7:30am a 4:30pm.', 'SCHEMA', N'Agenda', 'TABLE', N'JornadaTrabajoEspecial', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código para la jornada de trabajo. Se debe llevar un historial de las jornadas para un puesto de trabajo', 'SCHEMA', N'Agenda', 'TABLE', N'JornadaTrabajoEspecial', 'COLUMN', N'TN_CodJornadaTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo definido para un número  de oficina, cuatro letras y consecutivo.', 'SCHEMA', N'Agenda', 'TABLE', N'JornadaTrabajoEspecial', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo para indicar el día de la semana (L = Lunes, K = Martes, M = Miercoles, J = Jueves, V = Viernes, S = Sabado, D = Domingo).', 'SCHEMA', N'Agenda', 'TABLE', N'JornadaTrabajoEspecial', 'COLUMN', N'TC_DiaSemana'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Hora de incio de labores para ese día', 'SCHEMA', N'Agenda', 'TABLE', N'JornadaTrabajoEspecial', 'COLUMN', N'TF_HoraInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Hora de finalización de labores para ese día', 'SCHEMA', N'Agenda', 'TABLE', N'JornadaTrabajoEspecial', 'COLUMN', N'TF_HoraFin'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Inicio de vigencia para el dia de la jornada de trabajo', 'SCHEMA', N'Agenda', 'TABLE', N'JornadaTrabajoEspecial', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fin de vigencia para el dia de la jornada de trabajo', 'SCHEMA', N'Agenda', 'TABLE', N'JornadaTrabajoEspecial', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Agenda].[JornadaTrabajoEspecial] SET (LOCK_ESCALATION = TABLE)
GO

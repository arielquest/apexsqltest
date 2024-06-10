SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Agenda].[PuestoTrabajoPermisoAgenda] (
		[TC_CodPuestoTrabajoPermiso]     [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodPuestoTrabajoAgenda]      [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]             [datetime2](7) NOT NULL,
		[TF_Particion]                   [datetime2](7) NOT NULL,
		CONSTRAINT [PK_PuestoTrabajoPermisoAgenda_1]
		PRIMARY KEY
		NONCLUSTERED
		([TC_CodPuestoTrabajoPermiso], [TC_CodPuestoTrabajoAgenda])
	ON [PRIMARY]
) ON [AgendaPS] ([TF_Particion])
GO
ALTER TABLE [Agenda].[PuestoTrabajoPermisoAgenda]
	ADD
	CONSTRAINT [DF__PuestoTra__TF_Pa__5F55A728]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Agenda].[PuestoTrabajoPermisoAgenda]
	WITH CHECK
	ADD CONSTRAINT [FK_AgendaPermisoPuestoTrabajo_PuestoDeTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajoAgenda]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Agenda].[PuestoTrabajoPermisoAgenda]
	CHECK CONSTRAINT [FK_AgendaPermisoPuestoTrabajo_PuestoDeTrabajo]

GO
ALTER TABLE [Agenda].[PuestoTrabajoPermisoAgenda]
	WITH CHECK
	ADD CONSTRAINT [FK_AgendaPermisoPuestoTrabajo_PuestoDeTrabajo1]
	FOREIGN KEY ([TC_CodPuestoTrabajoPermiso]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Agenda].[PuestoTrabajoPermisoAgenda]
	CHECK CONSTRAINT [FK_AgendaPermisoPuestoTrabajo_PuestoDeTrabajo1]

GO
CREATE CLUSTERED INDEX [IX_Agenda_PuestoTrabajoPermisoAgenda_TF_Particion]
	ON [Agenda].[PuestoTrabajoPermisoAgenda] ([TF_Particion])
	ON [AgendaPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que almacena la información sobre cuales agendas tiene acceso un puesto de trabajo', 'SCHEMA', N'Agenda', 'TABLE', N'PuestoTrabajoPermisoAgenda', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo del funcionario al cual se le está dando permiso para consultar una agenda', 'SCHEMA', N'Agenda', 'TABLE', N'PuestoTrabajoPermisoAgenda', 'COLUMN', N'TC_CodPuestoTrabajoPermiso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo de la agenda que se desea consultar o editar', 'SCHEMA', N'Agenda', 'TABLE', N'PuestoTrabajoPermisoAgenda', 'COLUMN', N'TC_CodPuestoTrabajoAgenda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que inicia la vigencia de la relación', 'SCHEMA', N'Agenda', 'TABLE', N'PuestoTrabajoPermisoAgenda', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Agenda].[PuestoTrabajoPermisoAgenda] SET (LOCK_ESCALATION = TABLE)
GO

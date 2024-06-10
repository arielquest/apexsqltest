SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[SolicitudDesacumulacion] (
		[TU_CodSolicitud]           [uniqueidentifier] NOT NULL,
		[TC_Estado]                 [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodFase]                [smallint] NOT NULL,
		[TC_NumeroExpediente]       [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]             [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaSolicitud]         [datetime2](7) NOT NULL,
		[TF_Actualizacion]          [datetime2](7) NOT NULL,
		[TC_CodPuestoTrabajo]       [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_AsignadoPor]            [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Observaciones]          [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodContexto]            [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_TipoDesacumulacion]     [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]              [datetime2](7) NOT NULL,
		CONSTRAINT [PK_SolicitudDesacumulacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitud])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	ADD
	CONSTRAINT [CK_SolicitudDesacumulacion_TipoDesacumulacion]
	CHECK
	([TC_TipoDesacumulacion]='E' OR [TC_TipoDesacumulacion]='D')
GO
ALTER TABLE [Historico].[SolicitudDesacumulacion]
CHECK CONSTRAINT [CK_SolicitudDesacumulacion_TipoDesacumulacion]
GO
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	ADD
	CONSTRAINT [DF__Solicitud__TF_Ac__32816A03]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	ADD
	CONSTRAINT [DF__Solicitud__TC_Ti__07AE7C9C]
	DEFAULT ('D') FOR [TC_TipoDesacumulacion]
GO
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	ADD
	CONSTRAINT [DF__Solicitud__TF_Pa__650E807E]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudDesacumulacion_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	CHECK CONSTRAINT [FK_SolicitudDesacumulacion_Contexto]

GO
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudDesacumulacion_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	CHECK CONSTRAINT [FK_SolicitudDesacumulacion_Expediente]

GO
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudDesacumulacion_Fase]
	FOREIGN KEY ([TN_CodFase]) REFERENCES [Catalogo].[Fase] ([TN_CodFase])
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	CHECK CONSTRAINT [FK_SolicitudDesacumulacion_Fase]

GO
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudDesacumulacion_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	CHECK CONSTRAINT [FK_SolicitudDesacumulacion_PuestoTrabajo]

GO
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudDesacumulacion_PuestoTrabajoPor]
	FOREIGN KEY ([TC_AsignadoPor]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Historico].[SolicitudDesacumulacion]
	CHECK CONSTRAINT [FK_SolicitudDesacumulacion_PuestoTrabajoPor]

GO
CREATE CLUSTERED INDEX [IX_Historico_SolicitudDesacumulacion_TF_Particion]
	ON [Historico].[SolicitudDesacumulacion] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de solicitud de desacumulación', 'SCHEMA', N'Historico', 'TABLE', N'SolicitudDesacumulacion', 'COLUMN', N'TU_CodSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de la solicitud de desacumulación', 'SCHEMA', N'Historico', 'TABLE', N'SolicitudDesacumulacion', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de fase que se asignara al realizar la desacumulación. ', 'SCHEMA', N'Historico', 'TABLE', N'SolicitudDesacumulacion', 'COLUMN', N'TN_CodFase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente que se desacumulará', 'SCHEMA', N'Historico', 'TABLE', N'SolicitudDesacumulacion', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de usuario de la solicitud', 'SCHEMA', N'Historico', 'TABLE', N'SolicitudDesacumulacion', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de solicitud de desacumulación', 'SCHEMA', N'Historico', 'TABLE', N'SolicitudDesacumulacion', 'COLUMN', N'TF_FechaSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA', 'SCHEMA', N'Historico', 'TABLE', N'SolicitudDesacumulacion', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de puesto de trabajo que revisará la solicitud', 'SCHEMA', N'Historico', 'TABLE', N'SolicitudDesacumulacion', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de puesto de trabajo que creó la solicitud', 'SCHEMA', N'Historico', 'TABLE', N'SolicitudDesacumulacion', 'COLUMN', N'TC_AsignadoPor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones realizadas sobre la solicitud de desacumulación.', 'SCHEMA', N'Historico', 'TABLE', N'SolicitudDesacumulacion', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto donde esta el expediente a desacumular', 'SCHEMA', N'Historico', 'TABLE', N'SolicitudDesacumulacion', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de desacumulación (Error Material/administrativo o Decisión judicial)', 'SCHEMA', N'Historico', 'TABLE', N'SolicitudDesacumulacion', 'COLUMN', N'TC_TipoDesacumulacion'
GO
ALTER TABLE [Historico].[SolicitudDesacumulacion] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ExpedienteSolicitudAcceso] (
		[TU_CodSolicitudAccesoExpediente]        [uniqueidentifier] NOT NULL,
		[TU_CodLegajo]                           [uniqueidentifier] NOT NULL,
		[TC_Descripcion]                         [varchar](225) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContextoSolicitud]                [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodPuestoFuncionarioSolicitud]       [uniqueidentifier] NOT NULL,
		[TF_Solicitud]                           [datetime2](7) NOT NULL,
		[TC_EstadoSolicitudAccesoExpediente]     [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContextoRevision]                 [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TU_CodPuestoFuncionarioRevision]        [uniqueidentifier] NULL,
		[TF_Revision]                            [datetime2](7) NULL,
		[TC_MotivoRechazo]                       [varchar](225) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                           [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ExpedienteSolicitudAcceso]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitudAccesoExpediente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[ExpedienteSolicitudAcceso]
	ADD
	CONSTRAINT [DF__Expedient__TF_Pa__2E7D65A3]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[ExpedienteSolicitudAcceso]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudAccesoExpediente_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[ExpedienteSolicitudAcceso]
	CHECK CONSTRAINT [FK_SolicitudAccesoExpediente_Legajo]

GO
CREATE CLUSTERED INDEX [IX_Expediente_ExpedienteSolicitudAcceso_TF_Particion]
	ON [Expediente].[ExpedienteSolicitudAcceso] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_ExpedienteSolicitudAcceso_TU_CodLegajo]
	ON [Expediente].[ExpedienteSolicitudAcceso] ([TU_CodLegajo])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Permite almacenar las solicitudes de acceso que realiza un despacho a un expediente al cual no tiene acceeso.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteSolicitudAcceso', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de las solicitudes de acceso a expedientes.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteSolicitudAcceso', 'COLUMN', N'TU_CodSolicitudAccesoExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo donde se realiza la solicitud de acceso al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteSolicitudAcceso', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la solicitud de acceso al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteSolicitudAcceso', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto que realiza la solicitud de acceso al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteSolicitudAcceso', 'COLUMN', N'TC_CodContextoSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto-funcionario que realiza la solicitud de acceso al expedientes.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteSolicitudAcceso', 'COLUMN', N'TU_CodPuestoFuncionarioSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora en que se realiza la solicitud de acceso al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteSolicitudAcceso', 'COLUMN', N'TF_Solicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de la la solicitud de acceso al expediente. P: Pendiente de aprobar, A: Aprobada, R: Rechazada.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteSolicitudAcceso', 'COLUMN', N'TC_EstadoSolicitudAccesoExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto que revisa la solicitud de acceso al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteSolicitudAcceso', 'COLUMN', N'TC_CodContextoRevision'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto-funcionario que revisa la solicitud de acceso al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteSolicitudAcceso', 'COLUMN', N'TU_CodPuestoFuncionarioRevision'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora en que se revisa la solicitud de acceso al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteSolicitudAcceso', 'COLUMN', N'TF_Revision'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del motivo por el cual se rechaza la solicitud de acceso al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteSolicitudAcceso', 'COLUMN', N'TC_MotivoRechazo'
GO
ALTER TABLE [Expediente].[ExpedienteSolicitudAcceso] SET (LOCK_ESCALATION = TABLE)
GO

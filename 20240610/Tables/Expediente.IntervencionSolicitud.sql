SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[IntervencionSolicitud] (
		[TU_CodSolicitudExpediente]     [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]           [uniqueidentifier] NOT NULL,
		[TF_Particion]                  [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Expediente_IntervencionesSolicitud]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitudExpediente], [TU_CodInterviniente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[IntervencionSolicitud]
	ADD
	CONSTRAINT [DF__Intervenc__TF_Pa__28C48C4D]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervencionSolicitud]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_IntervencionesSolicitud_TU_CodInterviniente]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[IntervencionSolicitud]
	CHECK CONSTRAINT [FK_Expediente_IntervencionesSolicitud_TU_CodInterviniente]

GO
ALTER TABLE [Expediente].[IntervencionSolicitud]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_IntervencionesSolicitud_TU_CodSolicitudExpediente]
	FOREIGN KEY ([TU_CodSolicitudExpediente]) REFERENCES [Expediente].[SolicitudExpediente] ([TU_CodSolicitudExpediente])
ALTER TABLE [Expediente].[IntervencionSolicitud]
	CHECK CONSTRAINT [FK_Expediente_IntervencionesSolicitud_TU_CodSolicitudExpediente]

GO
CREATE CLUSTERED INDEX [IX_Expediente_IntervencionSolicitud_TF_Particion]
	ON [Expediente].[IntervencionSolicitud] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Entidad para conservar las intervenciones asociadas a la solicitud asociada al expediente', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionSolicitud', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la solicitud asociada al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionSolicitud', 'COLUMN', N'TU_CodSolicitudExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo que hace referencia a la intervención asociada a la solicitud asociada al expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionSolicitud', 'COLUMN', N'TU_CodInterviniente'
GO
ALTER TABLE [Expediente].[IntervencionSolicitud] SET (LOCK_ESCALATION = TABLE)
GO

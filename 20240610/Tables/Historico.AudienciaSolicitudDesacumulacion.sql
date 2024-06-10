SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[AudienciaSolicitudDesacumulacion] (
		[TU_CodSolicitud]      [uniqueidentifier] NOT NULL,
		[TN_CodAudiencia]      [bigint] NOT NULL,
		[TC_ModoSeleccion]     [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]         [datetime2](7) NOT NULL,
		CONSTRAINT [PK_AudienciaSolicitudDesacumulacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitud], [TN_CodAudiencia])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[AudienciaSolicitudDesacumulacion]
	ADD
	CONSTRAINT [DF_Historico.AudienciaSolicitudDesacumulacion_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[AudienciaSolicitudDesacumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_AudienciaSolicitudDesacumulacion_Audiencia]
	FOREIGN KEY ([TN_CodAudiencia]) REFERENCES [Expediente].[Audiencia] ([TN_CodAudiencia])
ALTER TABLE [Historico].[AudienciaSolicitudDesacumulacion]
	CHECK CONSTRAINT [FK_AudienciaSolicitudDesacumulacion_Audiencia]

GO
ALTER TABLE [Historico].[AudienciaSolicitudDesacumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_AudienciaSolicitudDesacumulacion_SolicitudDesacumulacion]
	FOREIGN KEY ([TU_CodSolicitud]) REFERENCES [Historico].[SolicitudDesacumulacion] ([TU_CodSolicitud])
ALTER TABLE [Historico].[AudienciaSolicitudDesacumulacion]
	CHECK CONSTRAINT [FK_AudienciaSolicitudDesacumulacion_SolicitudDesacumulacion]

GO
CREATE CLUSTERED INDEX [XID_Historico_AudienciaSolicitudDesacumulacion_TF_Particion]
	ON [Historico].[AudienciaSolicitudDesacumulacion] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de solicitud de la solicitud de desacumulación', 'SCHEMA', N'Historico', 'TABLE', N'AudienciaSolicitudDesacumulacion', 'COLUMN', N'TU_CodSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de Audiencia oral asociada a la solicitud de desacumulación', 'SCHEMA', N'Historico', 'TABLE', N'AudienciaSolicitudDesacumulacion', 'COLUMN', N'TN_CodAudiencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Modo de selección seleccionado por el usuario (Mover o Copiar)', 'SCHEMA', N'Historico', 'TABLE', N'AudienciaSolicitudDesacumulacion', 'COLUMN', N'TC_ModoSeleccion'
GO
EXEC sp_addextendedproperty N'MS_Description', N' Campo utilizado para el particionamiento de la tabla, tiene un valor por defecto.', 'SCHEMA', N'Historico', 'TABLE', N'AudienciaSolicitudDesacumulacion', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Historico].[AudienciaSolicitudDesacumulacion] SET (LOCK_ESCALATION = TABLE)
GO

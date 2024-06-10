SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [DefensaPublica].[RechazoSolicitudDefensorInterviniente] (
		[TU_CodSolicitudDefensor]                [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]                    [uniqueidentifier] NOT NULL,
		[TN_CodTipoRechazoSolicitudDefensor]     [smallint] NOT NULL,
		[TC_Observaciones]                       [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaCreacion]                       [datetime2](3) NOT NULL,
		[TF_Particion]                           [datetime2](7) NOT NULL,
		CONSTRAINT [PK_DefensaPublica_RechazoSolicitudDefensorInterviniente]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitudDefensor], [TU_CodInterviniente], [TN_CodTipoRechazoSolicitudDefensor])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[RechazoSolicitudDefensorInterviniente]
	ADD
	CONSTRAINT [DF_RechazoSolicitudDefensorInterviniente_TC_Observaciones]
	DEFAULT ('Sin Observaciones') FOR [TC_Observaciones]
GO
ALTER TABLE [DefensaPublica].[RechazoSolicitudDefensorInterviniente]
	ADD
	CONSTRAINT [DF__RechazoSo__TF_Pa__07639882]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[RechazoSolicitudDefensorInterviniente]
	WITH CHECK
	ADD CONSTRAINT [FK_RechazoSolicitudDefensorInterviniente_TN_CodTipoRechazoSolicitudDefensor]
	FOREIGN KEY ([TN_CodTipoRechazoSolicitudDefensor]) REFERENCES [Catalogo].[TipoRechazoSolicitudDefensor] ([TN_CodTipoRechazoSolicitudDefensor])
ALTER TABLE [DefensaPublica].[RechazoSolicitudDefensorInterviniente]
	CHECK CONSTRAINT [FK_RechazoSolicitudDefensorInterviniente_TN_CodTipoRechazoSolicitudDefensor]

GO
ALTER TABLE [DefensaPublica].[RechazoSolicitudDefensorInterviniente]
	WITH CHECK
	ADD CONSTRAINT [FK_RechazoSolicitudDefensorInterviniente_TU_CodSolicitudDefensor_TU_CodInterviniente]
	FOREIGN KEY ([TU_CodSolicitudDefensor], [TU_CodInterviniente]) REFERENCES [Expediente].[SolicitudDefensorInterviniente] ([TU_CodSolicitudDefensor], [TU_CodInterviniente])
ALTER TABLE [DefensaPublica].[RechazoSolicitudDefensorInterviniente]
	CHECK CONSTRAINT [FK_RechazoSolicitudDefensorInterviniente_TU_CodSolicitudDefensor_TU_CodInterviniente]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_RechazoSolicitudDefensorInterviniente_TF_Particion]
	ON [DefensaPublica].[RechazoSolicitudDefensorInterviniente] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Entidad que conserva el detalle del rechazo de una solicitud de defensor de una intervención', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RechazoSolicitudDefensorInterviniente', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la solicitud de defensor asociada.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RechazoSolicitudDefensorInterviniente', 'COLUMN', N'TU_CodSolicitudDefensor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la intervención asociada a la solicitud de defensor.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RechazoSolicitudDefensorInterviniente', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del catalogo de Tipos de rechazo de solicitud de defensor público del interviniente.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RechazoSolicitudDefensorInterviniente', 'COLUMN', N'TN_CodTipoRechazoSolicitudDefensor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de las observaciones adicionales ingresadas en el momento de rechazar la solicitud de defensor.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RechazoSolicitudDefensorInterviniente', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación del registro del rechazo de la solicitud de defensor.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'RechazoSolicitudDefensorInterviniente', 'COLUMN', N'TF_FechaCreacion'
GO
ALTER TABLE [DefensaPublica].[RechazoSolicitudDefensorInterviniente] SET (LOCK_ESCALATION = TABLE)
GO

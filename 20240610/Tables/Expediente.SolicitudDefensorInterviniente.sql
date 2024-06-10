SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[SolicitudDefensorInterviniente] (
		[TU_CodSolicitudDefensor]             [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]                 [uniqueidentifier] NOT NULL,
		[TB_Sustitucion]                      [bit] NOT NULL,
		[TB_Declaro]                          [bit] NOT NULL,
		[TC_Observaciones]                    [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_EstadoSolicitudInterviniente]     [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                        [datetime2](7) NOT NULL,
		CONSTRAINT [PK_SolicitudDefensorInterviniente]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitudDefensor], [TU_CodInterviniente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[SolicitudDefensorInterviniente]
	ADD
	CONSTRAINT [CK_SolicitudDefensorInterviniente_EstadoSolicitudInterviniente]
	CHECK
	([TC_EstadoSolicitudInterviniente]='A' OR [TC_EstadoSolicitudInterviniente]='R' OR [TC_EstadoSolicitudInterviniente]='E')
GO
ALTER TABLE [Expediente].[SolicitudDefensorInterviniente]
CHECK CONSTRAINT [CK_SolicitudDefensorInterviniente_EstadoSolicitudInterviniente]
GO
ALTER TABLE [Expediente].[SolicitudDefensorInterviniente]
	ADD
	CONSTRAINT [DF_SolicitudDefensorInterviniente_TB_Sustitucion]
	DEFAULT ((0)) FOR [TB_Sustitucion]
GO
ALTER TABLE [Expediente].[SolicitudDefensorInterviniente]
	ADD
	CONSTRAINT [DF_SolicitudDefensorInterviniente_TB_Declaro]
	DEFAULT ((0)) FOR [TB_Declaro]
GO
ALTER TABLE [Expediente].[SolicitudDefensorInterviniente]
	ADD
	CONSTRAINT [DF_SolicitudDefensorInterviniente_TC_Observaciones]
	DEFAULT ('') FOR [TC_Observaciones]
GO
ALTER TABLE [Expediente].[SolicitudDefensorInterviniente]
	ADD
	CONSTRAINT [DF__Solicitud__TF_Pa__7915792B]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[SolicitudDefensorInterviniente]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudDefensorInterviniente_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[SolicitudDefensorInterviniente]
	CHECK CONSTRAINT [FK_SolicitudDefensorInterviniente_Intervencion]

GO
ALTER TABLE [Expediente].[SolicitudDefensorInterviniente]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudDefensorInterviniente_SolicitudDefensor]
	FOREIGN KEY ([TU_CodSolicitudDefensor]) REFERENCES [Expediente].[SolicitudDefensor] ([TU_CodSolicitudDefensor])
ALTER TABLE [Expediente].[SolicitudDefensorInterviniente]
	CHECK CONSTRAINT [FK_SolicitudDefensorInterviniente_SolicitudDefensor]

GO
CREATE CLUSTERED INDEX [IX_Expediente_SolicitudDefensorInterviniente_TF_Particion]
	ON [Expediente].[SolicitudDefensorInterviniente] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información que asocia a los intervinientes con su solicitud de defensor.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensorInterviniente', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la solicitud de defensor.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensorInterviniente', 'COLUMN', N'TU_CodSolicitudDefensor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensorInterviniente', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la solicitud se realiza para sustituir a un defensor privado.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensorInterviniente', 'COLUMN', N'TB_Sustitucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el interviniente ya realizó su declaración.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensorInterviniente', 'COLUMN', N'TB_Declaro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones adicionales de la asignación de la solicitud.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensorInterviniente', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de la solicitud de defensor del interviniente (A = Aceptada, R = Rechazada, E = En Espera).', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudDefensorInterviniente', 'COLUMN', N'TC_EstadoSolicitudInterviniente'
GO
ALTER TABLE [Expediente].[SolicitudDefensorInterviniente] SET (LOCK_ESCALATION = TABLE)
GO

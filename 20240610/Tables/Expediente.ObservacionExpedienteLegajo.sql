SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ObservacionExpedienteLegajo] (
		[TU_CodObservacionExpedienteLegajo]     [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]                   [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodLegajo]                          [uniqueidentifier] NULL,
		[TC_UsuarioRed]                         [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Observacion]                        [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaCreacion]                      [datetime2](3) NOT NULL,
		[TB_Urgente]                            [bit] NOT NULL,
		[TN_CodEstado]                          [tinyint] NOT NULL,
		[TF_Particion]                          [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Expediente_ObservacionExpedienteLegajo]
		PRIMARY KEY
		CLUSTERED
		([TU_CodObservacionExpedienteLegajo])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Expediente].[ObservacionExpedienteLegajo]
	ADD
	CONSTRAINT [CK_ObservacionExpedienteLegajo_TN_CodEstado]
	CHECK
	([TN_CodEstado]='3' OR [TN_CodEstado]='4')
GO
ALTER TABLE [Expediente].[ObservacionExpedienteLegajo]
CHECK CONSTRAINT [CK_ObservacionExpedienteLegajo_TN_CodEstado]
GO
ALTER TABLE [Expediente].[ObservacionExpedienteLegajo]
	ADD
	CONSTRAINT [DF_Expediente_ObservacionExpedienteLegajo_TF_FechaCreacion]
	DEFAULT (getdate()) FOR [TF_FechaCreacion]
GO
ALTER TABLE [Expediente].[ObservacionExpedienteLegajo]
	ADD
	CONSTRAINT [DF_Expediente_ObservacionExpedienteLegajo_TB_Urgente]
	DEFAULT ((0)) FOR [TB_Urgente]
GO
ALTER TABLE [Expediente].[ObservacionExpedienteLegajo]
	ADD
	CONSTRAINT [DF_Expediente_ObservacionExpedienteLegajo_TN_CodEstado]
	DEFAULT ((3)) FOR [TN_CodEstado]
GO
ALTER TABLE [Expediente].[ObservacionExpedienteLegajo]
	ADD
	CONSTRAINT [DF_Expediente_ObservacionExpedienteLegajo_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[ObservacionExpedienteLegajo]
	WITH CHECK
	ADD CONSTRAINT [FK_ObservacionExpedienteLegajo_TC_NumeroExpediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[ObservacionExpedienteLegajo]
	CHECK CONSTRAINT [FK_ObservacionExpedienteLegajo_TC_NumeroExpediente]

GO
ALTER TABLE [Expediente].[ObservacionExpedienteLegajo]
	WITH CHECK
	ADD CONSTRAINT [FK_ObservacionExpedienteLegajo_TU_CodLegajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[ObservacionExpedienteLegajo]
	CHECK CONSTRAINT [FK_ObservacionExpedienteLegajo_TU_CodLegajo]

GO
CREATE NONCLUSTERED INDEX [INDEX_NumeroExpediente_Observacion_FechaCreacion_Urgente_CodEstado]
	ON [Expediente].[ObservacionExpedienteLegajo] ([TU_CodLegajo], [TC_UsuarioRed])
	INCLUDE ([TC_NumeroExpediente], [TC_Observacion], [TF_FechaCreacion], [TB_Urgente], [TN_CodEstado])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para registrar las observaciones que se indiquen a un expediente y/o legajo', 'SCHEMA', N'Expediente', 'TABLE', N'ObservacionExpedienteLegajo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la observación a registrar.', 'SCHEMA', N'Expediente', 'TABLE', N'ObservacionExpedienteLegajo', 'COLUMN', N'TU_CodObservacionExpedienteLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del expediente asociado a la observación.', 'SCHEMA', N'Expediente', 'TABLE', N'ObservacionExpedienteLegajo', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo asociado a la observación.', 'SCHEMA', N'Expediente', 'TABLE', N'ObservacionExpedienteLegajo', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de usuario que registra la observación.', 'SCHEMA', N'Expediente', 'TABLE', N'ObservacionExpedienteLegajo', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion de la observación asociada al expediente y/o legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'ObservacionExpedienteLegajo', 'COLUMN', N'TC_Observacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora del registro de la observación al expediente y/o legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'ObservacionExpedienteLegajo', 'COLUMN', N'TF_FechaCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador de que la observación es Urgente o Normal.', 'SCHEMA', N'Expediente', 'TABLE', N'ObservacionExpedienteLegajo', 'COLUMN', N'TB_Urgente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de la observación registrada (3 = BORRADOR PUBLICO | 4 = TERMINADO).', 'SCHEMA', N'Expediente', 'TABLE', N'ObservacionExpedienteLegajo', 'COLUMN', N'TN_CodEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha del momento del registro.', 'SCHEMA', N'Expediente', 'TABLE', N'ObservacionExpedienteLegajo', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Expediente].[ObservacionExpedienteLegajo] SET (LOCK_ESCALATION = TABLE)
GO

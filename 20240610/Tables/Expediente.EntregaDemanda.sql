SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[EntregaDemanda] (
		[TU_CodEntregaDemanda]         [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]          [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaIngresoRDD]           [datetime2](2) NOT NULL,
		[TC_Estado]                    [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaRecibido]             [datetime2](2) NOT NULL,
		[TF_FechaEstadoExpediente]     [datetime2](2) NULL,
		[TF_Actualizacion]             [datetime2](3) NULL,
		[TF_Particion]                 [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Expediente.EntregaDemanda]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodEntregaDemanda])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[EntregaDemanda]
	ADD
	CONSTRAINT [CK_Expediente.EntregaDemanda_Estado]
	CHECK
	([TC_Estado]='P' OR [TC_Estado]='D')
GO
ALTER TABLE [Expediente].[EntregaDemanda]
CHECK CONSTRAINT [CK_Expediente.EntregaDemanda_Estado]
GO
ALTER TABLE [Expediente].[EntregaDemanda]
	ADD
	CONSTRAINT [DF__EntregaDe__TF_Ac__0B9CA70C]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[EntregaDemanda]
	ADD
	CONSTRAINT [DF__EntregaDe__TF_Pa__188E2484]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[EntregaDemanda]
	WITH CHECK
	ADD CONSTRAINT [FK_EntregaDemanda_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[EntregaDemanda]
	CHECK CONSTRAINT [FK_EntregaDemanda_Expediente]

GO
CREATE CLUSTERED INDEX [IX_Expediente_EntregaDemanda_TF_Particion]
	ON [Expediente].[EntregaDemanda] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la entrega de demanda.', 'SCHEMA', N'Expediente', 'TABLE', N'EntregaDemanda', 'COLUMN', N'TU_CodEntregaDemanda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de expediente único a lo largo de la vida del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'EntregaDemanda', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de ingreso a la Oficina de Recepción de Documentos', 'SCHEMA', N'Expediente', 'TABLE', N'EntregaDemanda', 'COLUMN', N'TF_FechaIngresoRDD'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado en el que se encuentra la entrega de demanda, estos pueden ser: Pendientede distribuir = ''P'' y distribuido ''D''', 'SCHEMA', N'Expediente', 'TABLE', N'EntregaDemanda', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en la que la entrega de demanda ingresó al despacho', 'SCHEMA', N'Expediente', 'TABLE', N'EntregaDemanda', 'COLUMN', N'TF_FechaRecibido'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en la cual se establece el estado del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'EntregaDemanda', 'COLUMN', N'TF_FechaEstadoExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha destinada para el Datawarehouse', 'SCHEMA', N'Expediente', 'TABLE', N'EntregaDemanda', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Expediente].[EntregaDemanda] SET (LOCK_ESCALATION = TABLE)
GO

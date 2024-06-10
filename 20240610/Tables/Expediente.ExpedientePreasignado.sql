SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ExpedientePreasignado] (
		[TU_CodPreasignado]       [uniqueidentifier] NOT NULL,
		[TC_CodPuestoTrabajo]     [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroExpediente]     [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Estado]               [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Tramite]              [datetime2](7) NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		[TC_CodContexto]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_SistemaExterno]       [bit] NOT NULL,
		CONSTRAINT [PK_ExpedientePreasignado]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodPreasignado])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[ExpedientePreasignado]
	ADD
	CONSTRAINT [CK_ExpedientePreasignado]
	CHECK
	([TC_Estado]='A' OR [TC_Estado]='C' OR [TC_Estado]='R')
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado en el que se encuentra el consecutivo a pre-asignar
donde A-Aplicado C-Cancelado R-Reservado ', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedientePreasignado', 'CONSTRAINT', N'CK_ExpedientePreasignado'
GO
ALTER TABLE [Expediente].[ExpedientePreasignado]
CHECK CONSTRAINT [CK_ExpedientePreasignado]
GO
ALTER TABLE [Expediente].[ExpedientePreasignado]
	ADD
	CONSTRAINT [DF_ExpedientePreasignado_TC_Estado]
	DEFAULT ('R') FOR [TC_Estado]
GO
ALTER TABLE [Expediente].[ExpedientePreasignado]
	ADD
	CONSTRAINT [DF_ExpedientePreasignado_TF_Tramite]
	DEFAULT (getdate()) FOR [TF_Tramite]
GO
ALTER TABLE [Expediente].[ExpedientePreasignado]
	ADD
	CONSTRAINT [DF__Expedient__TF_Pa__0393079E]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[ExpedientePreasignado]
	ADD
	CONSTRAINT [DF_ExpedientePreasignado_TB_SIstemaExterno]
	DEFAULT ((0)) FOR [TB_SistemaExterno]
GO
ALTER TABLE [Expediente].[ExpedientePreasignado]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedientePreasignado_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[ExpedientePreasignado]
	CHECK CONSTRAINT [FK_ExpedientePreasignado_Contexto]

GO
ALTER TABLE [Expediente].[ExpedientePreasignado]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedientePreasignado_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Expediente].[ExpedientePreasignado]
	CHECK CONSTRAINT [FK_ExpedientePreasignado_PuestoTrabajo]

GO
CREATE CLUSTERED INDEX [IX_Expediente_ExpedientePreasignado_TF_Particion]
	ON [Expediente].[ExpedientePreasignado] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que permite registrar preasignación de números de expedientes interno o externos.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedientePreasignado', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la preasignación.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedientePreasignado', 'COLUMN', N'TU_CodPreasignado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo al cual se le pre asigna el consecutivo.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedientePreasignado', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente  preasignado.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedientePreasignado', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de la reserva del número expediente (A-Aplicado, C-Cancelado, R-Reservado).', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedientePreasignado', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha que realiza el trámite de preasingación.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedientePreasignado', 'COLUMN', N'TF_Tramite'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de contexto para el cual se generó el consecutivo de expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedientePreasignado', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el consecutivo de expediente preasignado se generó desde un sistema externo como GL y CEREDOC (1) o si fue desde SIAGPJ (0 y predeterminado)', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedientePreasignado', 'COLUMN', N'TB_SistemaExterno'
GO
ALTER TABLE [Expediente].[ExpedientePreasignado] SET (LOCK_ESCALATION = TABLE)
GO

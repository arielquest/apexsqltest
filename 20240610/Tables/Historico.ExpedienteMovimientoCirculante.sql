SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[ExpedienteMovimientoCirculante] (
		[TN_CodExpedienteMovimientoCirculante]     [bigint] NOT NULL,
		[TC_NumeroExpediente]                      [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fecha]                                 [datetime2](7) NOT NULL,
		[TC_CodContexto]                           [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodEstado]                             [int] NOT NULL,
		[TC_Movimiento]                            [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TU_CodArchivo]                            [uniqueidentifier] NULL,
		[TU_CodPuestoFuncionario]                  [uniqueidentifier] NOT NULL,
		[TC_Descripcion]                           [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                             [datetime2](7) NOT NULL,
		[IDFEP]                                    [bigint] NULL,
		CONSTRAINT [PK_ExpedienteMovimientoCirculante]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodExpedienteMovimientoCirculante])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[ExpedienteMovimientoCirculante]
	ADD
	CONSTRAINT [CK_ExpedienteMovimientoCirculante_Movimiento]
	CHECK
	([TC_Movimiento]='E' OR [TC_Movimiento]='F' OR [TC_Movimiento]='L' OR [TC_Movimiento]='R' OR [TC_Movimiento]='S')
GO
ALTER TABLE [Historico].[ExpedienteMovimientoCirculante]
CHECK CONSTRAINT [CK_ExpedienteMovimientoCirculante_Movimiento]
GO
ALTER TABLE [Historico].[ExpedienteMovimientoCirculante]
	ADD
	CONSTRAINT [DF__Expedient__TN_Co__5B70D302]
	DEFAULT (NEXT VALUE FOR [Historico].[SecuenciaExpedienteMovimientoCirculante]) FOR [TN_CodExpedienteMovimientoCirculante]
GO
ALTER TABLE [Historico].[ExpedienteMovimientoCirculante]
	ADD
	CONSTRAINT [DF__Expedient__TF_Pa__202F464C]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
CREATE CLUSTERED INDEX [IX_Historico_ExpedienteMovimientoCirculante_TF_Particion]
	ON [Historico].[ExpedienteMovimientoCirculante] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_Revision_PA_ConsultarProcesosNuevos]
	ON [Historico].[ExpedienteMovimientoCirculante] ([TC_NumeroExpediente], [TC_CodContexto])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_ExpedienteMovimientoCirculante]
	ON [Historico].[ExpedienteMovimientoCirculante] ([TC_NumeroExpediente], [TF_Fecha], [TC_CodContexto], [TN_CodEstado], [TC_Movimiento])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_ExpedienteMovimientoCirculante_TC_CodContexto_TC_Movimiento]
	ON [Historico].[ExpedienteMovimientoCirculante] ([TC_CodContexto], [TC_Movimiento])
	INCLUDE ([TC_NumeroExpediente], [TF_Fecha], [TN_CodEstado])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra los movimientos en el circulante que tiene un expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculante', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único numérico de la tabla.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculante', 'COLUMN', N'TN_CodExpedienteMovimientoCirculante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del expediente al que corresponde el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculante', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se realiza el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculante', 'COLUMN', N'TF_Fecha'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto donde se realiza el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculante', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado que se asigna al expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculante', 'COLUMN', N'TN_CodEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de movimiento que se le realiza al expediente. E:Entrar, F:Finalizar, L:Levantar suspensión, R:Reentrar, S:Suspender.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculante', 'COLUMN', N'TC_Movimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del archivo que se asocia al movimiento del expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculante', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto-funcionario que realiza el movimiento del expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculante', 'COLUMN', N'TU_CodPuestoFuncionario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción u observaciones relacionadas con el movimiento que se le realiza al expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteMovimientoCirculante', 'COLUMN', N'TC_Descripcion'
GO
ALTER TABLE [Historico].[ExpedienteMovimientoCirculante] SET (LOCK_ESCALATION = TABLE)
GO

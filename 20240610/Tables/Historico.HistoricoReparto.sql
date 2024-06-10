SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[HistoricoReparto] (
		[TU_CodBitacora]              [uniqueidentifier] NOT NULL,
		[TC_CodOficina]               [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]              [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroExpediente]         [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodLegajo]                [uniqueidentifier] NULL,
		[TN_CodTipoPuestoTrabajo]     [smallint] NOT NULL,
		[TC_CodPuestoTrabajo]         [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fecha]                    [datetime2](7) NOT NULL,
		[TC_Accion]                   [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Motivo]                   [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_ValorAtributos]           [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodCriterio]              [uniqueidentifier] NOT NULL,
		[TC_Prioridad]                [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]               [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                [datetime2](7) NOT NULL,
		CONSTRAINT [PK_BitacoraReparto]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodBitacora])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[HistoricoReparto]
	ADD
	CONSTRAINT [CK_HistoricoReparto_TC_Prioridad]
	CHECK
	([TC_Prioridad]='P' OR [TC_Prioridad]='S' OR [TC_Prioridad]='A')
GO
ALTER TABLE [Historico].[HistoricoReparto]
CHECK CONSTRAINT [CK_HistoricoReparto_TC_Prioridad]
GO
ALTER TABLE [Historico].[HistoricoReparto]
	ADD
	CONSTRAINT [DF_BitacoraReparto_TC_NumeroExpediente]
	DEFAULT ('Número de expediente que se reparte') FOR [TC_NumeroExpediente]
GO
ALTER TABLE [Historico].[HistoricoReparto]
	ADD
	CONSTRAINT [DF_HistoricoReparto_TC_Prioridad]
	DEFAULT ('P') FOR [TC_Prioridad]
GO
ALTER TABLE [Historico].[HistoricoReparto]
	ADD
	CONSTRAINT [DF_HistoricoReparto_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[HistoricoReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_Bitacora_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[HistoricoReparto]
	CHECK CONSTRAINT [FK_Bitacora_Contexto]

GO
ALTER TABLE [Historico].[HistoricoReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_Bitacora_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Historico].[HistoricoReparto]
	CHECK CONSTRAINT [FK_Bitacora_Legajo]

GO
ALTER TABLE [Historico].[HistoricoReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_Bitacora_Oficina]
	FOREIGN KEY ([TC_CodOficina]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Historico].[HistoricoReparto]
	CHECK CONSTRAINT [FK_Bitacora_Oficina]

GO
ALTER TABLE [Historico].[HistoricoReparto]
	WITH CHECK
	ADD CONSTRAINT [FK_Bitacora_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Historico].[HistoricoReparto]
	CHECK CONSTRAINT [FK_Bitacora_PuestoTrabajo]

GO
CREATE CLUSTERED INDEX [IX_Historico_HistoricoReparto_TF_Particion]
	ON [Historico].[HistoricoReparto] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la bitácora o historico de asignaciones de responsables por reparto', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la tabla de bitácora del reparto', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TU_CodBitacora'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de la oficina a la que pertenece el expediente que se reparte', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TC_CodOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del contexto al que pertenece el expediente que se reparte', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del legajo que se reparte', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de puesto de trabajo del responsable asignado', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TN_CodTipoPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Puesto de trabajo del responsable asignado', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha al realizar el proceso de reparto', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TF_Fecha'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Acción realizada por el proceso de reparto', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TC_Accion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Motivo por el que se generó el reparto', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TC_Motivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor de los datos del criterio de reparto que tenía la demanda cuando se ejecutó el reparto', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TC_ValorAtributos'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del criterio de reparto asignado.', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TU_CodCriterio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Señala el Tipo de Prioridad Asignada P-Principal, S-Secundaria, A-Adicional', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TC_Prioridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'''Señala el usuario asignado al momento del reparto''', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo para realizar las particiones', 'SCHEMA', N'Historico', 'TABLE', N'HistoricoReparto', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Historico].[HistoricoReparto] SET (LOCK_ESCALATION = TABLE)
GO

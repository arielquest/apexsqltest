SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[TareaPendiente] (
		[TU_CodTareaPendiente]             [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]              [char](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TU_CodLegajo]                     [uniqueidentifier] NULL,
		[TF_Recibido]                      [datetime2](7) NOT NULL,
		[TF_Vence]                         [datetime2](7) NOT NULL,
		[TC_Mensaje]                       [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodPuestoTrabajoOrigen]        [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRedOrigen]              [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTarea]                      [smallint] NOT NULL,
		[TC_CodPuestoTrabajoDestino]       [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodTareaPendienteAnterior]     [uniqueidentifier] NULL,
		[TF_Finalizacion]                  [datetime2](7) NULL,
		[TC_UsuarioRedFinaliza]            [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Reasignacion]                  [datetime2](7) NULL,
		[TC_UsuarioRedReasigna]            [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]                 [datetime2](7) NOT NULL,
		[TF_Particion]                     [datetime2](7) NOT NULL,
		[TC_CodPuestoTrabajoFinaliza]      [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodPuestoTrabajoReasigna]      [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodContexto]                   [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_TareaPendiente]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodTareaPendiente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[TareaPendiente]
	ADD
	CONSTRAINT [DF__TareaPend__TF_Re__1631A61D]
	DEFAULT (getdate()) FOR [TF_Recibido]
GO
ALTER TABLE [Expediente].[TareaPendiente]
	ADD
	CONSTRAINT [DF__TareaPend__TF_Ve__1725CA56]
	DEFAULT (getdate()) FOR [TF_Vence]
GO
ALTER TABLE [Expediente].[TareaPendiente]
	ADD
	CONSTRAINT [DF__TareaPend__TF_Ac__1819EE8F]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[TareaPendiente]
	ADD
	CONSTRAINT [DF__TareaPend__TF_Pa__190E12C8]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[TareaPendiente]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaPendiente_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[TareaPendiente]
	CHECK CONSTRAINT [FK_TareaPendiente_Contexto]

GO
ALTER TABLE [Expediente].[TareaPendiente]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaPendiente_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[TareaPendiente]
	CHECK CONSTRAINT [FK_TareaPendiente_Expediente]

GO
ALTER TABLE [Expediente].[TareaPendiente]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaPendiente_Funcionario]
	FOREIGN KEY ([TC_UsuarioRedOrigen]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Expediente].[TareaPendiente]
	CHECK CONSTRAINT [FK_TareaPendiente_Funcionario]

GO
ALTER TABLE [Expediente].[TareaPendiente]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaPendiente_FuncionarioFinaliza]
	FOREIGN KEY ([TC_UsuarioRedFinaliza]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Expediente].[TareaPendiente]
	CHECK CONSTRAINT [FK_TareaPendiente_FuncionarioFinaliza]

GO
ALTER TABLE [Expediente].[TareaPendiente]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaPendiente_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[TareaPendiente]
	CHECK CONSTRAINT [FK_TareaPendiente_Legajo]

GO
ALTER TABLE [Expediente].[TareaPendiente]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaPendiente_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajoOrigen]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Expediente].[TareaPendiente]
	CHECK CONSTRAINT [FK_TareaPendiente_PuestoTrabajo]

GO
ALTER TABLE [Expediente].[TareaPendiente]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaPendiente_PuestoTrabajoDestino]
	FOREIGN KEY ([TC_CodPuestoTrabajoDestino]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Expediente].[TareaPendiente]
	CHECK CONSTRAINT [FK_TareaPendiente_PuestoTrabajoDestino]

GO
ALTER TABLE [Expediente].[TareaPendiente]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaPendiente_PuestoTrabajoFinaliza]
	FOREIGN KEY ([TC_CodPuestoTrabajoFinaliza]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Expediente].[TareaPendiente]
	CHECK CONSTRAINT [FK_TareaPendiente_PuestoTrabajoFinaliza]

GO
ALTER TABLE [Expediente].[TareaPendiente]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaPendiente_PuestoTrabajoReasigna]
	FOREIGN KEY ([TC_CodPuestoTrabajoReasigna]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Expediente].[TareaPendiente]
	CHECK CONSTRAINT [FK_TareaPendiente_PuestoTrabajoReasigna]

GO
ALTER TABLE [Expediente].[TareaPendiente]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaPendiente_Tarea]
	FOREIGN KEY ([TN_CodTarea]) REFERENCES [Catalogo].[Tarea] ([TN_CodTarea])
ALTER TABLE [Expediente].[TareaPendiente]
	CHECK CONSTRAINT [FK_TareaPendiente_Tarea]

GO
ALTER TABLE [Expediente].[TareaPendiente]
	WITH CHECK
	ADD CONSTRAINT [FK_TareaPendiente_TareaPendiente]
	FOREIGN KEY ([TU_CodTareaPendienteAnterior]) REFERENCES [Expediente].[TareaPendiente] ([TU_CodTareaPendiente])
ALTER TABLE [Expediente].[TareaPendiente]
	CHECK CONSTRAINT [FK_TareaPendiente_TareaPendiente]

GO
CREATE CLUSTERED INDEX [IX_Expediente_TareaPendiente_TF_Particion]
	ON [Expediente].[TareaPendiente] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_Expediente_TareaPendiente_NumeroExpediente]
	ON [Expediente].[TareaPendiente] ([TC_NumeroExpediente], [TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_por_Carga_1079]
	ON [Expediente].[TareaPendiente] ([TF_Recibido], [TF_Vence], [TC_Mensaje], [TC_CodPuestoTrabajoOrigen], [TC_CodPuestoTrabajoDestino], [TN_CodTarea])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_Por_Carga_1090]
	ON [Expediente].[TareaPendiente] ([TU_CodTareaPendienteAnterior])
	INCLUDE ([TU_CodTareaPendiente], [TC_Mensaje], [TN_CodTarea], [TC_CodPuestoTrabajoDestino])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_Por_Carga_1098]
	ON [Expediente].[TareaPendiente] ([TU_CodLegajo], [TF_Finalizacion], [TC_UsuarioRedFinaliza], [TF_Reasignacion], [TC_UsuarioRedReasigna], [TC_CodContexto])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [Idx_TC_CodPuestoTrabajoDestino]
	ON [Expediente].[TareaPendiente] ([TC_CodPuestoTrabajoDestino], [TF_Finalizacion], [TC_UsuarioRedFinaliza], [TF_Reasignacion], [TC_UsuarioRedReasigna], [TC_CodContexto])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [Idx_TU_CodLegajo_TF_Finalizacion_TC_UsuarioRedFinaliza_TF_Reasignacion_TC_UsuarioRedReasigna_TC_CodContexto]
	ON [Expediente].[TareaPendiente] ([TU_CodLegajo], [TF_Finalizacion], [TC_UsuarioRedFinaliza], [TF_Reasignacion], [TC_UsuarioRedReasigna], [TC_CodContexto])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_TareaPendiente]
	ON [Expediente].[TareaPendiente] ([TU_CodLegajo])
	INCLUDE ([TU_CodTareaPendiente], [TC_Mensaje], [TN_CodTarea], [TC_CodPuestoTrabajoDestino], [TF_Actualizacion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_TareaPendiente_Migracion]
	ON [Expediente].[TareaPendiente] ([TC_NumeroExpediente], [TF_Recibido], [TF_Vence], [TC_Mensaje], [TC_CodPuestoTrabajoOrigen], [TN_CodTarea], [TC_CodPuestoTrabajoDestino])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [TC_NumeroExpediente_TU_CodLegajo_TF_Finalizacion_TC_UsuarioRedFinaliza_TF_Reasignacion_TC_UsuarioRedReasigna_TC_CodContexto]
	ON [Expediente].[TareaPendiente] ([TC_NumeroExpediente], [TU_CodLegajo], [TF_Finalizacion], [TC_UsuarioRedFinaliza], [TF_Reasignacion], [TC_UsuarioRedReasigna], [TC_CodContexto])
	WITH ( FILLFACTOR = 100)
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la tarea pendiente', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TU_CodTareaPendiente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del expediente al que se está asignando la tarea, no se pone si se indica el código del legajo', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo al que se está asignando la tarea, no se pone si se indica el número del expediente', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora en que se realiza la asignación de la tarea', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TF_Recibido'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora en que vence el plazo para realizar la tarea asignada', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TF_Vence'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Texto descriptivo que se el usuario digita al momento de asignar la tarea', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TC_Mensaje'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Puesto de trabajo desde donde se asigna la tarea', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TC_CodPuestoTrabajoOrigen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Puesto de trabajo desde donde se asigna la tarea', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TC_UsuarioRedOrigen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la tarea seleccionada por el usuario, la cual debe realizarse', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TN_CodTarea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Puesto de trabajo al que se le asigna la tarea', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TC_CodPuestoTrabajoDestino'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Es el código de la tarea anterior realizada al expediente (es decir la que se está finalizando en ese momento)', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TU_CodTareaPendienteAnterior'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de finalización de la tarea, opcional', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TF_Finalizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que finaliza la tarea, opcional', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TC_UsuarioRedFinaliza'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de re-asignación de la tarea, opcional', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TF_Reasignacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que re-asigna la tarea, opcional', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TC_UsuarioRedReasigna'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora del registro del destino de la evidencia', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TF_Particion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del puesto de trabajo que finaliza la tarea, puede ser nulo si la tarea no ha sido finalizada o si fue reasignada', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TC_CodPuestoTrabajoFinaliza'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del puesto de trabajo que reasigna la tarea, puede ser nulo si la tarea no ha sido reasignada o si fue finalizada', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TC_CodPuestoTrabajoReasigna'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto al cual se asigna la tarea', 'SCHEMA', N'Expediente', 'TABLE', N'TareaPendiente', 'COLUMN', N'TC_CodContexto'
GO
ALTER TABLE [Expediente].[TareaPendiente] SET (LOCK_ESCALATION = TABLE)
GO

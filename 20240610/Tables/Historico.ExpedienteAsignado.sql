SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[ExpedienteAsignado] (
		[TC_NumeroExpediente]       [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]            [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodPuestoTrabajo]       [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]           [datetime2](7) NULL,
		[TF_Actualizacion]          [datetime2](7) NOT NULL,
		[TF_Particion]              [datetime2](7) NOT NULL,
		[TB_AsignadoPorReparto]     [bit] NOT NULL,
		[TB_EsResponsable]          [bit] NULL,
		CONSTRAINT [PK_ExpedienteAsignado]
		PRIMARY KEY
		NONCLUSTERED
		([TC_NumeroExpediente], [TC_CodContexto], [TC_CodPuestoTrabajo], [TF_Inicio_Vigencia])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[ExpedienteAsignado]
	ADD
	CONSTRAINT [DF__Expedient__TF_Ac__040808EA]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Historico].[ExpedienteAsignado]
	ADD
	CONSTRAINT [DF__Expedient__TF_Pa__1DB2CC54]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[ExpedienteAsignado]
	ADD
	CONSTRAINT [DF__Expedient__TB_TB__1241E4FF]
	DEFAULT ((0)) FOR [TB_AsignadoPorReparto]
GO
ALTER TABLE [Historico].[ExpedienteAsignado]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteAsignado_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[ExpedienteAsignado]
	CHECK CONSTRAINT [FK_ExpedienteAsignado_Contexto]

GO
ALTER TABLE [Historico].[ExpedienteAsignado]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteAsignado_ExpedienteDetalle]
	FOREIGN KEY ([TC_NumeroExpediente], [TC_CodContexto]) REFERENCES [Expediente].[ExpedienteDetalle] ([TC_NumeroExpediente], [TC_CodContexto])
ALTER TABLE [Historico].[ExpedienteAsignado]
	CHECK CONSTRAINT [FK_ExpedienteAsignado_ExpedienteDetalle]

GO
ALTER TABLE [Historico].[ExpedienteAsignado]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteAsignado_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Historico].[ExpedienteAsignado]
	CHECK CONSTRAINT [FK_ExpedienteAsignado_PuestoTrabajo]

GO
CREATE CLUSTERED INDEX [IX_Historico_ExpedienteAsignado_TF_Particion]
	ON [Historico].[ExpedienteAsignado] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_ExpedienteAsignado_Migracion]
	ON [Historico].[ExpedienteAsignado] ([TC_NumeroExpediente], [TC_CodContexto], [TC_CodPuestoTrabajo], [TF_Inicio_Vigencia])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los asignados del expediente en el contexto.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAsignado', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del expediente al que corresponde el asignado.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAsignado', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto al que corresponde el asignado.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAsignado', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo al que corresponde el asignado.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAsignado', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia a partir de la cual el funcionario está asignado al expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAsignado', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia hasta la cual el funcionario está asignado al expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAsignado', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Última fecha en que se actualiza la información del asignado.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAsignado', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'Description', N'Campo que indica si el registro es el usuario responsable del expediente', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAsignado', 'COLUMN', N'TB_EsResponsable'
GO
ALTER TABLE [Historico].[ExpedienteAsignado] SET (LOCK_ESCALATION = TABLE)
GO

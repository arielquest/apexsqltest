SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[LegajoAsignado] (
		[TU_CodLegajo]              [uniqueidentifier] NOT NULL,
		[TC_CodContexto]            [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodPuestoTrabajo]       [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]           [datetime2](7) NULL,
		[TF_Actualizacion]          [datetime2](7) NOT NULL,
		[TF_Particion]              [datetime2](7) NOT NULL,
		[TB_AsignadoPorReparto]     [bit] NOT NULL,
		[TB_EsResponsable]          [bit] NULL,
		CONSTRAINT [PK_LegajoAsignado]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodLegajo], [TC_CodContexto], [TC_CodPuestoTrabajo], [TF_Inicio_Vigencia])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[LegajoAsignado]
	ADD
	CONSTRAINT [DF__LegajoAsi__TF_Ac__08CCBE07]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Historico].[LegajoAsignado]
	ADD
	CONSTRAINT [DF__LegajoAsi__TF_Pa__24F3FB69]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[LegajoAsignado]
	ADD
	CONSTRAINT [DF__LegajoAsi__TB_As__142A2D71]
	DEFAULT ((0)) FOR [TB_AsignadoPorReparto]
GO
ALTER TABLE [Historico].[LegajoAsignado]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoAsignado_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[LegajoAsignado]
	CHECK CONSTRAINT [FK_LegajoAsignado_Contexto]

GO
ALTER TABLE [Historico].[LegajoAsignado]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoAsignado_LegajoDetalle]
	FOREIGN KEY ([TU_CodLegajo], [TC_CodContexto]) REFERENCES [Expediente].[LegajoDetalle] ([TU_CodLegajo], [TC_CodContexto])
ALTER TABLE [Historico].[LegajoAsignado]
	CHECK CONSTRAINT [FK_LegajoAsignado_LegajoDetalle]

GO
ALTER TABLE [Historico].[LegajoAsignado]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoAsignado_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Historico].[LegajoAsignado]
	CHECK CONSTRAINT [FK_LegajoAsignado_PuestoTrabajo]

GO
CREATE CLUSTERED INDEX [IX_Historico_LegajoAsignado_TF_Particion]
	ON [Historico].[LegajoAsignado] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_LegajoAsignado]
	ON [Historico].[LegajoAsignado] ([TU_CodLegajo], [TC_CodContexto], [TC_CodPuestoTrabajo], [TF_Inicio_Vigencia], [TF_Fin_Vigencia])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_LegajoAsignado_TC_Contexto_TB_EsResponsable_TU_CodLegajo]
	ON [Historico].[LegajoAsignado] ([TC_CodContexto], [TB_EsResponsable])
	INCLUDE ([TU_CodLegajo])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los asignados del legajo en el contexto.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoAsignado', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo al que corresponde el asignado.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoAsignado', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto al que corresponde el asignado.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoAsignado', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo al que corresponde el asignado.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoAsignado', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia a partir de la cual el funcionario está asignado al legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoAsignado', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia hasta la cual el funcionario está asignado al legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoAsignado', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Última fecha en que se actualiza la información del asignado.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoAsignado', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'Description', N'Campo que indica si el registro es el usuario responsable del expediente', 'SCHEMA', N'Historico', 'TABLE', N'LegajoAsignado', 'COLUMN', N'TB_EsResponsable'
GO
ALTER TABLE [Historico].[LegajoAsignado] SET (LOCK_ESCALATION = TABLE)
GO

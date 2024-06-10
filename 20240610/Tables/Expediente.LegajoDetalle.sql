SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[LegajoDetalle] (
		[TU_CodLegajo]                  [uniqueidentifier] NOT NULL,
		[TC_CodContexto]                [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Entrada]                    [datetime2](7) NOT NULL,
		[TN_CodAsunto]                  [int] NOT NULL,
		[TN_CodClaseAsunto]             [int] NOT NULL,
		[TC_CodContextoProcedencia]     [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodGrupoTrabajo]            [smallint] NULL,
		[TB_Habilitado]                 [bit] NOT NULL,
		[TF_Actualizacion]              [datetime2](7) NOT NULL,
		[TF_Particion]                  [datetime2](7) NOT NULL,
		[TN_CodProceso]                 [smallint] NULL,
		CONSTRAINT [PK_LegajoDetalle]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodLegajo], [TC_CodContexto])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[LegajoDetalle]
	ADD
	CONSTRAINT [DF__LegajoDet__TF_Ac__7A7E9EB0]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[LegajoDetalle]
	ADD
	CONSTRAINT [DF__LegajoDet__TF_Pa__6E97EAB8]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[LegajoDetalle]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoDetalle_Asunto]
	FOREIGN KEY ([TN_CodAsunto]) REFERENCES [Catalogo].[Asunto] ([TN_CodAsunto])
ALTER TABLE [Expediente].[LegajoDetalle]
	CHECK CONSTRAINT [FK_LegajoDetalle_Asunto]

GO
ALTER TABLE [Expediente].[LegajoDetalle]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoDetalle_ClaseAsunto]
	FOREIGN KEY ([TN_CodClaseAsunto]) REFERENCES [Catalogo].[ClaseAsunto] ([TN_CodClaseAsunto])
ALTER TABLE [Expediente].[LegajoDetalle]
	CHECK CONSTRAINT [FK_LegajoDetalle_ClaseAsunto]

GO
ALTER TABLE [Expediente].[LegajoDetalle]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoDetalle_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[LegajoDetalle]
	CHECK CONSTRAINT [FK_LegajoDetalle_Contexto]

GO
ALTER TABLE [Expediente].[LegajoDetalle]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoDetalle_ContextoProcedencia]
	FOREIGN KEY ([TC_CodContextoProcedencia]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[LegajoDetalle]
	CHECK CONSTRAINT [FK_LegajoDetalle_ContextoProcedencia]

GO
ALTER TABLE [Expediente].[LegajoDetalle]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoDetalle_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[LegajoDetalle]
	CHECK CONSTRAINT [FK_LegajoDetalle_Legajo]

GO
ALTER TABLE [Expediente].[LegajoDetalle]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoDetalle_Proceso]
	FOREIGN KEY ([TN_CodProceso]) REFERENCES [Catalogo].[Proceso] ([TN_CodProceso])
ALTER TABLE [Expediente].[LegajoDetalle]
	CHECK CONSTRAINT [FK_LegajoDetalle_Proceso]

GO
CREATE CLUSTERED INDEX [IX_Expediente_LegajoDetalle_TF_Particion]
	ON [Expediente].[LegajoDetalle] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_LegajoDetalle_TC_CodContexto_TU_CodLegajo_TN_CodAsunto]
	ON [Expediente].[LegajoDetalle] ([TC_CodContexto])
	INCLUDE ([TU_CodLegajo], [TN_CodAsunto])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_LegajoDetalle_TC_Contexto_INCLUDE]
	ON [Expediente].[LegajoDetalle] ([TC_CodContexto])
	INCLUDE ([TU_CodLegajo], [TF_Entrada], [TN_CodAsunto], [TN_CodProceso])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_LegajoDetalle_TN_CodAsunto_INCLUDE]
	ON [Expediente].[LegajoDetalle] ([TN_CodAsunto])
	INCLUDE ([TU_CodLegajo], [TC_CodContexto], [TF_Entrada], [TN_CodProceso])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información detallada del legajo por contexto.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoDetalle', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo al que corresponde el detalle.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoDetalle', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto al que corresponde el legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoDetalle', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que el legajo ingresó al despacho.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoDetalle', 'COLUMN', N'TF_Entrada'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del asunto del legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoDetalle', 'COLUMN', N'TN_CodAsunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la clase de asunto del legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoDetalle', 'COLUMN', N'TN_CodClaseAsunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto de donde proviene del legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoDetalle', 'COLUMN', N'TC_CodContextoProcedencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del grupo de trabajo que tiene asignado el legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoDetalle', 'COLUMN', N'TN_CodGrupoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador que permite señalar si el legajo está habilitado o deshabilitado.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoDetalle', 'COLUMN', N'TB_Habilitado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoDetalle', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del proceso asociado al legajo', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoDetalle', 'COLUMN', N'TN_CodProceso'
GO
ALTER TABLE [Expediente].[LegajoDetalle] SET (LOCK_ESCALATION = TABLE)
GO

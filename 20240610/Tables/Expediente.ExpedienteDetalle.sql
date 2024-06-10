SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ExpedienteDetalle] (
		[TC_NumeroExpediente]           [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]                [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Entrada]                    [datetime2](7) NOT NULL,
		[TN_CodClase]                   [int] NOT NULL,
		[TN_CodProceso]                 [smallint] NOT NULL,
		[TN_CodFase]                    [smallint] NOT NULL,
		[TC_CodContextoProcedencia]     [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodGrupoTrabajo]            [smallint] NULL,
		[TB_Habilitado]                 [bit] NOT NULL,
		[TB_DocumentosFisicos]          [bit] NOT NULL,
		[TF_Actualizacion]              [datetime2](7) NOT NULL,
		[TF_Particion]                  [datetime2](7) NOT NULL,
		[TC_TestimonioPiezas]           [char](14) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_ExpedienteDetalle]
		PRIMARY KEY
		NONCLUSTERED
		([TC_NumeroExpediente], [TC_CodContexto])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[ExpedienteDetalle]
	ADD
	CONSTRAINT [DF__Expedient__TF_En__695412AE]
	DEFAULT (getdate()) FOR [TF_Entrada]
GO
ALTER TABLE [Expediente].[ExpedienteDetalle]
	ADD
	CONSTRAINT [DF__Expedient__TB_Do__6A4836E7]
	DEFAULT ((0)) FOR [TB_DocumentosFisicos]
GO
ALTER TABLE [Expediente].[ExpedienteDetalle]
	ADD
	CONSTRAINT [DF__Expedient__TF_Ac__6B3C5B20]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[ExpedienteDetalle]
	ADD
	CONSTRAINT [DF__Expedient__TF_Pa__0C284D9F]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[ExpedienteDetalle]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteDetalle_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[ExpedienteDetalle]
	CHECK CONSTRAINT [FK_ExpedienteDetalle_Contexto]

GO
ALTER TABLE [Expediente].[ExpedienteDetalle]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteDetalle_ContextoProcedencia]
	FOREIGN KEY ([TC_CodContextoProcedencia]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[ExpedienteDetalle]
	CHECK CONSTRAINT [FK_ExpedienteDetalle_ContextoProcedencia]

GO
ALTER TABLE [Expediente].[ExpedienteDetalle]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteDetalle_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[ExpedienteDetalle]
	CHECK CONSTRAINT [FK_ExpedienteDetalle_Expediente]

GO
ALTER TABLE [Expediente].[ExpedienteDetalle]
	WITH CHECK
	ADD CONSTRAINT [FK_TestimonioPiezas_Expediente]
	FOREIGN KEY ([TC_TestimonioPiezas]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[ExpedienteDetalle]
	CHECK CONSTRAINT [FK_TestimonioPiezas_Expediente]

GO
CREATE CLUSTERED INDEX [IX_Expediente_ExpedienteDetalle_TF_Particion]
	ON [Expediente].[ExpedienteDetalle] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [_dta_index_ExpedienteDetalle_5_1044211516__K1_K12_K4_2]
	ON [Expediente].[ExpedienteDetalle] ([TC_NumeroExpediente], [TN_CodClase], [TF_Particion])
	INCLUDE ([TC_CodContexto])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_TC_CodContexto]
	ON [Expediente].[ExpedienteDetalle] ([TC_CodContexto])
	INCLUDE ([TC_NumeroExpediente], [TF_Entrada], [TN_CodClase], [TN_CodProceso])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_ExpedienteDetalle_TC_CodContexto_TN_CodClase_INCLUDE]
	ON [Expediente].[ExpedienteDetalle] ([TC_CodContexto], [TN_CodClase])
	INCLUDE ([TC_NumeroExpediente], [TF_Entrada], [TN_CodProceso], [TN_CodFase])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_ExpedienteDetalle_TC_Contexto_INCLUDE]
	ON [Expediente].[ExpedienteDetalle] ([TC_CodContexto])
	INCLUDE ([TC_NumeroExpediente], [TF_Entrada], [TN_CodClase], [TN_CodProceso], [TN_CodFase])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información detallada del expediente por contexto.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteDetalle', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de expediente al que corresponde el detalle.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteDetalle', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto al que corresponde el expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteDetalle', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que el expediente ingresó al despacho.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteDetalle', 'COLUMN', N'TF_Entrada'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la clase del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteDetalle', 'COLUMN', N'TN_CodClase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del proceso del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteDetalle', 'COLUMN', N'TN_CodProceso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la fase en que se encuentra el expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteDetalle', 'COLUMN', N'TN_CodFase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto de donde proviene del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteDetalle', 'COLUMN', N'TC_CodContextoProcedencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del grupo de trabajo que tiene asignado el expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteDetalle', 'COLUMN', N'TN_CodGrupoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador que permite señalar si el expediente está habilitado o deshabilitado.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteDetalle', 'COLUMN', N'TB_Habilitado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador que permite señalar si el documento contiene documentos físicos.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteDetalle', 'COLUMN', N'TB_DocumentosFisicos'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteDetalle', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si es un testimonio de piezas cuando tenga un valor, será el número de expediente del cual se creó', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteDetalle', 'COLUMN', N'TC_TestimonioPiezas'
GO
ALTER TABLE [Expediente].[ExpedienteDetalle] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[PaseFallo] (
		[TU_CodPaseFallo]            [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]        [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodLegajo]               [uniqueidentifier] NULL,
		[TC_CodContexto]             [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRedAsigna]        [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodTareaAsigna]          [uniqueidentifier] NULL,
		[TF_FechaAsignacion]         [datetime2](7) NOT NULL,
		[TU_CodTareaDevuelve]        [uniqueidentifier] NULL,
		[TF_FechaDevolucion]         [datetime2](7) NULL,
		[TN_CodMotivoDevolucion]     [smallint] NULL,
		[TF_FechaVencimiento]        [datetime2](7) NOT NULL,
		[TU_CodArchivo]              [uniqueidentifier] NULL,
		[TF_Particion]               [datetime2](7) NOT NULL,
		CONSTRAINT [PK_PaseFallo]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodPaseFallo])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[PaseFallo]
	ADD
	CONSTRAINT [DF_PaseFallo_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[PaseFallo]
	WITH CHECK
	ADD CONSTRAINT [FK_PaseFallo_A_TareaPendiente]
	FOREIGN KEY ([TU_CodTareaAsigna]) REFERENCES [Expediente].[TareaPendiente] ([TU_CodTareaPendiente])
ALTER TABLE [Historico].[PaseFallo]
	CHECK CONSTRAINT [FK_PaseFallo_A_TareaPendiente]

GO
ALTER TABLE [Historico].[PaseFallo]
	WITH CHECK
	ADD CONSTRAINT [FK_PaseFallo_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Historico].[PaseFallo]
	CHECK CONSTRAINT [FK_PaseFallo_Archivo]

GO
ALTER TABLE [Historico].[PaseFallo]
	WITH CHECK
	ADD CONSTRAINT [FK_PaseFallo_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[PaseFallo]
	CHECK CONSTRAINT [FK_PaseFallo_Contexto]

GO
ALTER TABLE [Historico].[PaseFallo]
	WITH CHECK
	ADD CONSTRAINT [FK_PaseFallo_D_TareaPendiente]
	FOREIGN KEY ([TU_CodTareaDevuelve]) REFERENCES [Expediente].[TareaPendiente] ([TU_CodTareaPendiente])
ALTER TABLE [Historico].[PaseFallo]
	CHECK CONSTRAINT [FK_PaseFallo_D_TareaPendiente]

GO
ALTER TABLE [Historico].[PaseFallo]
	WITH CHECK
	ADD CONSTRAINT [FK_PaseFallo_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[PaseFallo]
	CHECK CONSTRAINT [FK_PaseFallo_Expediente]

GO
ALTER TABLE [Historico].[PaseFallo]
	WITH CHECK
	ADD CONSTRAINT [FK_PaseFallo_Funcionario]
	FOREIGN KEY ([TC_UsuarioRedAsigna]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Historico].[PaseFallo]
	CHECK CONSTRAINT [FK_PaseFallo_Funcionario]

GO
ALTER TABLE [Historico].[PaseFallo]
	WITH CHECK
	ADD CONSTRAINT [FK_PaseFallo_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Historico].[PaseFallo]
	CHECK CONSTRAINT [FK_PaseFallo_Legajo]

GO
ALTER TABLE [Historico].[PaseFallo]
	WITH CHECK
	ADD CONSTRAINT [FK_PaseFallo_MotivoDevolucionPaseFallo]
	FOREIGN KEY ([TN_CodMotivoDevolucion]) REFERENCES [Catalogo].[MotivoDevolucionPaseFallo] ([TN_CodMotivoDevolucion])
ALTER TABLE [Historico].[PaseFallo]
	CHECK CONSTRAINT [FK_PaseFallo_MotivoDevolucionPaseFallo]

GO
CREATE CLUSTERED INDEX [IX_Historico_PaseFallo_TF_Particion]
	ON [Historico].[PaseFallo] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [Idx_TC_NumeroExpediente_TU_CodLegajo_TC_CodContexto]
	ON [Historico].[PaseFallo] ([TC_NumeroExpediente], [TU_CodLegajo], [TC_CodContexto])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico para cada pase a fallo.', 'SCHEMA', N'Historico', 'TABLE', N'PaseFallo', 'COLUMN', N'TU_CodPaseFallo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente asociado al pase fallo.', 'SCHEMA', N'Historico', 'TABLE', N'PaseFallo', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de legajo asociado al pase fallo. Puede ir NULL si el pase a fallo se realiza en el expediente.', 'SCHEMA', N'Historico', 'TABLE', N'PaseFallo', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto donde se realiza el pase a fallo', 'SCHEMA', N'Historico', 'TABLE', N'PaseFallo', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la tarea que dió inicio al proceso de pase a fallo.', 'SCHEMA', N'Historico', 'TABLE', N'PaseFallo', 'COLUMN', N'TU_CodTareaAsigna'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de asignación de pase a fallo.', 'SCHEMA', N'Historico', 'TABLE', N'PaseFallo', 'COLUMN', N'TF_FechaAsignacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la tarea de devolución.', 'SCHEMA', N'Historico', 'TABLE', N'PaseFallo', 'COLUMN', N'TU_CodTareaDevuelve'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de devolución.', 'SCHEMA', N'Historico', 'TABLE', N'PaseFallo', 'COLUMN', N'TF_FechaDevolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de devolución.', 'SCHEMA', N'Historico', 'TABLE', N'PaseFallo', 'COLUMN', N'TN_CodMotivoDevolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de vencimiento del pase a fallo.', 'SCHEMA', N'Historico', 'TABLE', N'PaseFallo', 'COLUMN', N'TF_FechaVencimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del archivo asociado al pase a fallo.', 'SCHEMA', N'Historico', 'TABLE', N'PaseFallo', 'COLUMN', N'TU_CodArchivo'
GO
ALTER TABLE [Historico].[PaseFallo] SET (LOCK_ESCALATION = TABLE)
GO

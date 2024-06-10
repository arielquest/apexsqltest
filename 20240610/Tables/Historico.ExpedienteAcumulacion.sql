SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[ExpedienteAcumulacion] (
		[TU_CodAcumulacion]                        [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]                      [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroExpedienteAcumula]               [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodExpedienteMovimientoCirculante]     [bigint] NOT NULL,
		[TC_CodContexto]                           [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_InicioAcumulacion]                     [datetime2](7) NOT NULL,
		[TF_FinAcumulacion]                        [datetime2](7) NULL,
		[TF_Actualizacion]                         [datetime2](7) NOT NULL,
		[TU_CodArchivo]                            [uniqueidentifier] NULL,
		[TU_CodPuestoTrabajoFuncionario]           [uniqueidentifier] NOT NULL,
		[TF_Particion]                             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ExpedienteAcumulacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodAcumulacion])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	ADD
	CONSTRAINT [DF__Expedient__TF_Ac__06A2E7C5]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	ADD
	CONSTRAINT [DF__Expedient__TF_Pa__04872BD7]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteAcumulacion_Archivo]
	FOREIGN KEY ([TU_CodArchivo], [TC_NumeroExpediente]) REFERENCES [Expediente].[ArchivoExpediente] ([TU_CodArchivo], [TC_NumeroExpediente])
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	CHECK CONSTRAINT [FK_ExpedienteAcumulacion_Archivo]

GO
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteAcumulacion_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	CHECK CONSTRAINT [FK_ExpedienteAcumulacion_Contexto]

GO
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteAcumulacion_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	CHECK CONSTRAINT [FK_ExpedienteAcumulacion_Expediente]

GO
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteAcumulacion_ExpedienteAcum]
	FOREIGN KEY ([TC_NumeroExpedienteAcumula]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	CHECK CONSTRAINT [FK_ExpedienteAcumulacion_ExpedienteAcum]

GO
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteAcumulacion_ExpedienteMovimientoCirculante]
	FOREIGN KEY ([TN_CodExpedienteMovimientoCirculante]) REFERENCES [Historico].[ExpedienteMovimientoCirculante] ([TN_CodExpedienteMovimientoCirculante])
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	CHECK CONSTRAINT [FK_ExpedienteAcumulacion_ExpedienteMovimientoCirculante]

GO
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteAcumulacion_PuestoTrabajoFuncionario]
	FOREIGN KEY ([TU_CodPuestoTrabajoFuncionario]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Historico].[ExpedienteAcumulacion]
	CHECK CONSTRAINT [FK_ExpedienteAcumulacion_PuestoTrabajoFuncionario]

GO
CREATE CLUSTERED INDEX [IX_Historico_ExpedienteAcumulacion_TF_Particion]
	ON [Historico].[ExpedienteAcumulacion] ([TF_Particion])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Idx_TC_NumeroExpedienteAcumula]
	ON [Historico].[ExpedienteAcumulacion] ([TC_NumeroExpedienteAcumula])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Historico_ExpedienteAcumulacion_Migracion]
	ON [Historico].[ExpedienteAcumulacion] ([TC_NumeroExpediente], [TC_NumeroExpedienteAcumula], [TC_CodContexto], [TF_InicioAcumulacion])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAcumulacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de acumulación', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAcumulacion', 'COLUMN', N'TU_CodAcumulacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente que se acumula', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAcumulacion', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente que contiene la acumulación', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAcumulacion', 'COLUMN', N'TC_NumeroExpedienteAcumula'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del movimiento del circulante', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAcumulacion', 'COLUMN', N'TN_CodExpedienteMovimientoCirculante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de contexto', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAcumulacion', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de acumulación', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAcumulacion', 'COLUMN', N'TF_InicioAcumulacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha fin de acumulación', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAcumulacion', 'COLUMN', N'TF_FinAcumulacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAcumulacion', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de archivo de documento que contiene resolución de acumulación.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAcumulacion', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de puesto trabajo funcionario de quien realice la acumulacion', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteAcumulacion', 'COLUMN', N'TU_CodPuestoTrabajoFuncionario'
GO
ALTER TABLE [Historico].[ExpedienteAcumulacion] SET (LOCK_ESCALATION = TABLE)
GO

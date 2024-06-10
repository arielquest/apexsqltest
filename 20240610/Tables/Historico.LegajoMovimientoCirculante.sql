SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[LegajoMovimientoCirculante] (
		[TN_CodLegajoMovimientoCirculante]     [bigint] NOT NULL,
		[TU_CodLegajo]                         [uniqueidentifier] NOT NULL,
		[TF_Fecha]                             [datetime2](7) NOT NULL,
		[TC_NumeroExpediente]                  [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]                       [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodEstado]                         [int] NOT NULL,
		[TC_Movimiento]                        [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TU_CodArchivo]                        [uniqueidentifier] NULL,
		[TU_CodPuestoFuncionario]              [uniqueidentifier] NOT NULL,
		[TC_Descripcion]                       [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                         [datetime2](7) NOT NULL,
		[IDFEP]                                [bigint] NULL,
		CONSTRAINT [PK_LegajoMovimientoCirculante]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodLegajoMovimientoCirculante])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
	ADD
	CONSTRAINT [CK_LegajoMovimientoCirculante_Movimiento]
	CHECK
	([TC_Movimiento]='E' OR [TC_Movimiento]='F' OR [TC_Movimiento]='L' OR [TC_Movimiento]='R' OR [TC_Movimiento]='S')
GO
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
CHECK CONSTRAINT [CK_LegajoMovimientoCirculante_Movimiento]
GO
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
	ADD
	CONSTRAINT [DF__LegajoMov__TN_Co__5D24114A]
	DEFAULT (NEXT VALUE FOR [Historico].[SecuenciaLegajoMovimientoCirculante]) FOR [TN_CodLegajoMovimientoCirculante]
GO
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
	ADD
	CONSTRAINT [DF_LegajoMovimientoCirculante_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoMovimientoCirculante_ArchivoExpediente]
	FOREIGN KEY ([TU_CodArchivo], [TC_NumeroExpediente]) REFERENCES [Expediente].[ArchivoExpediente] ([TU_CodArchivo], [TC_NumeroExpediente])
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
	CHECK CONSTRAINT [FK_LegajoMovimientoCirculante_ArchivoExpediente]

GO
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoMovimientoCirculante_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
	CHECK CONSTRAINT [FK_LegajoMovimientoCirculante_Contexto]

GO
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoMovimientoCirculante_Estado]
	FOREIGN KEY ([TN_CodEstado]) REFERENCES [Catalogo].[Estado] ([TN_CodEstado])
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
	CHECK CONSTRAINT [FK_LegajoMovimientoCirculante_Estado]

GO
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoMovimientoCirculante_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
	CHECK CONSTRAINT [FK_LegajoMovimientoCirculante_Legajo]

GO
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoMovimientoCirculante_PuestoFuncionario]
	FOREIGN KEY ([TU_CodPuestoFuncionario]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Historico].[LegajoMovimientoCirculante]
	CHECK CONSTRAINT [FK_LegajoMovimientoCirculante_PuestoFuncionario]

GO
CREATE CLUSTERED INDEX [IX_Historico_LegajoMovimientoCirculante_TF_Particion]
	ON [Historico].[LegajoMovimientoCirculante] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_Historico_LegajoMovimientoCirculante_exped_Archivo]
	ON [Historico].[LegajoMovimientoCirculante] ([TC_NumeroExpediente], [TU_CodArchivo])
	WITH ( FILLFACTOR = 100)
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_LegajoMovimientoCirculante]
	ON [Historico].[LegajoMovimientoCirculante] ([TU_CodLegajo], [TC_NumeroExpediente], [TF_Fecha], [TC_CodContexto], [TN_CodEstado], [TC_Movimiento])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_LegajoMovimientoCirculanteCodContexto_Movimiento]
	ON [Historico].[LegajoMovimientoCirculante] ([TC_CodContexto], [TC_Movimiento])
	INCLUDE ([TU_CodLegajo], [TF_Fecha], [TC_NumeroExpediente], [TN_CodEstado])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [TU_CodPuestoFuncionario_Includes]
	ON [Historico].[LegajoMovimientoCirculante] ([TU_CodPuestoFuncionario])
	INCLUDE ([TU_CodLegajo], [TF_Fecha], [TC_NumeroExpediente], [TC_CodContexto], [TN_CodEstado], [TC_Movimiento], [TU_CodArchivo], [TC_Descripcion])
	WITH ( FILLFACTOR = 100)
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra los movimientos en el circulante que tiene un expediente.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculante', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número unico asignado por la secuencia para utilizarlo como identificador de la tabla.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculante', 'COLUMN', N'TN_CodLegajoMovimientoCirculante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del legajo al que corresponde el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculante', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se realiza el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculante', 'COLUMN', N'TF_Fecha'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número del expediente al que corresponde el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculante', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto donde se realiza el movimiento.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculante', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado que se asigna al legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculante', 'COLUMN', N'TN_CodEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de movimiento que se le realiza al legajo. E:Entrar, F:Finalizar, L:Levantar suspensión, R:Reentrar, S:Suspender.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculante', 'COLUMN', N'TC_Movimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del archivo que se asocia al movimiento del legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculante', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto-funcionario que realiza el movimiento del legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculante', 'COLUMN', N'TU_CodPuestoFuncionario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción u observaciones relacionadas con el movimiento que se le realiza al legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculante', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha utilizada para particionar la tabla por año y optimizar las consultas.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoMovimientoCirculante', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Historico].[LegajoMovimientoCirculante] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[MovimientosEscrito] (
		[TU_CodEscrito]                [uniqueidentifier] NOT NULL,
		[TF_FechaMovimiento]           [datetime2](2) NOT NULL,
		[TC_CodContextoDestino]        [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Movimiento]                [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]               [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]                [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_JustificacionTraslado]     [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                 [datetime2](7) NOT NULL,
		CONSTRAINT [PK_HistoricoMovimientosEscrito(Historico)_1]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodEscrito], [TF_FechaMovimiento])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[MovimientosEscrito]
	ADD
	CONSTRAINT [DF__Movimient__TF_Pa__1E46FDDA]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[MovimientosEscrito]
	WITH CHECK
	ADD CONSTRAINT [FK_HistoricoEscrito(Historico)_Contexto]
	FOREIGN KEY ([TC_CodContextoDestino]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[MovimientosEscrito]
	CHECK CONSTRAINT [FK_HistoricoEscrito(Historico)_Contexto]

GO
ALTER TABLE [Historico].[MovimientosEscrito]
	WITH CHECK
	ADD CONSTRAINT [FK_HistoricoMovimientosEscrito(Historico)_EscritoExpediente]
	FOREIGN KEY ([TU_CodEscrito]) REFERENCES [Expediente].[EscritoExpediente] ([TU_CodEscrito])
ALTER TABLE [Historico].[MovimientosEscrito]
	CHECK CONSTRAINT [FK_HistoricoMovimientosEscrito(Historico)_EscritoExpediente]

GO
CREATE CLUSTERED INDEX [IX_Historico_MovimientosEscrito_TF_Particion]
	ON [Historico].[MovimientosEscrito] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los movimientos que ha tenido un escrito', 'SCHEMA', N'Historico', 'TABLE', N'MovimientosEscrito', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de la entrega con el escrito', 'SCHEMA', N'Historico', 'TABLE', N'MovimientosEscrito', 'COLUMN', N'TU_CodEscrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora en que se realiza el movimiento', 'SCHEMA', N'Historico', 'TABLE', N'MovimientosEscrito', 'COLUMN', N'TF_FechaMovimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contexto al que se traslada el escrito', 'SCHEMA', N'Historico', 'TABLE', N'MovimientosEscrito', 'COLUMN', N'TC_CodContextoDestino'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Señala el movimiento que tiene el escrito', 'SCHEMA', N'Historico', 'TABLE', N'MovimientosEscrito', 'COLUMN', N'TC_Movimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contexto en que se realiza el movimiento', 'SCHEMA', N'Historico', 'TABLE', N'MovimientosEscrito', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que realiza el movimiento', 'SCHEMA', N'Historico', 'TABLE', N'MovimientosEscrito', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Justificación señalada en caso que se traslade un escrito a otro despacho judicial', 'SCHEMA', N'Historico', 'TABLE', N'MovimientosEscrito', 'COLUMN', N'TC_JustificacionTraslado'
GO
ALTER TABLE [Historico].[MovimientosEscrito] SET (LOCK_ESCALATION = TABLE)
GO

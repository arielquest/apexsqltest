SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[PagoDeuda] (
		[TU_CodigoPagoDeuda]               [uniqueidentifier] NOT NULL,
		[TN_CodMoneda]                     [smallint] NOT NULL,
		[TN_MontoDeposito]                 [decimal](18, 2) NULL,
		[TU_CodigoDeuda]                   [uniqueidentifier] NULL,
		[TF_FechaDeposito]                 [datetime2](7) NULL,
		[TF_FechaPago]                     [datetime2](7) NULL,
		[TN_MontoAbonoCapital]             [decimal](18, 2) NULL,
		[TN_MontoPagoCostasPersonales]     [decimal](18, 2) NULL,
		[TN_MontoPagoCostasProcesales]     [decimal](18, 2) NULL,
		[TN_MontoPagoInteres]              [decimal](18, 2) NULL,
		[TN_NumeroDeposito]                [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_UsuarioRed]                    [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaRegistroPago]             [datetime2](7) NOT NULL,
		[TF_Particion]                     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_PagoDeuda]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodigoPagoDeuda])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[PagoDeuda]
	ADD
	CONSTRAINT [DF__PagoDeuda__TF_Pa__2F7189DC]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[PagoDeuda]
	WITH CHECK
	ADD CONSTRAINT [FK_PagoDeuda_Deuda]
	FOREIGN KEY ([TU_CodigoDeuda]) REFERENCES [Expediente].[Deuda] ([TU_CodigoDeuda])
ALTER TABLE [Historico].[PagoDeuda]
	CHECK CONSTRAINT [FK_PagoDeuda_Deuda]

GO
ALTER TABLE [Historico].[PagoDeuda]
	WITH CHECK
	ADD CONSTRAINT [FK_PagoDeuda_Moneda]
	FOREIGN KEY ([TN_CodMoneda]) REFERENCES [Catalogo].[Moneda] ([TN_CodMoneda])
ALTER TABLE [Historico].[PagoDeuda]
	CHECK CONSTRAINT [FK_PagoDeuda_Moneda]

GO
CREATE CLUSTERED INDEX [IX_Historico_PagoDeuda_TF_Particion]
	ON [Historico].[PagoDeuda] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene información sobre los pagos realizados sobre una deuda de un expediente', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de pago de deuda', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', 'COLUMN', N'TU_CodigoPagoDeuda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la moneda', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', 'COLUMN', N'TN_CodMoneda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto del depósito', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', 'COLUMN', N'TN_MontoDeposito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de deuda', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', 'COLUMN', N'TU_CodigoDeuda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de depósito', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', 'COLUMN', N'TF_FechaDeposito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de pago', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', 'COLUMN', N'TF_FechaPago'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto correspondiente a abono del capital', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', 'COLUMN', N'TN_MontoAbonoCapital'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto liquidado sobre costas personales', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', 'COLUMN', N'TN_MontoPagoCostasPersonales'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto liquidado sobre costas procesales', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', 'COLUMN', N'TN_MontoPagoCostasProcesales'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto liquidado sobre intereses', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', 'COLUMN', N'TN_MontoPagoInteres'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de depósito', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', 'COLUMN', N'TN_NumeroDeposito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario del sistema que registró el pago.', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de sistema del registro del pago.', 'SCHEMA', N'Historico', 'TABLE', N'PagoDeuda', 'COLUMN', N'TF_FechaRegistroPago'
GO
ALTER TABLE [Historico].[PagoDeuda] SET (LOCK_ESCALATION = TABLE)
GO

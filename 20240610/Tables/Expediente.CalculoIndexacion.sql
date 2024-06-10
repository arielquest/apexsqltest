SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[CalculoIndexacion] (
		[TU_CodigoCalculoIndexacion]     [uniqueidentifier] NOT NULL,
		[TC_Descripcion]                 [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroExpediente]            [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]                 [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaCalculo]                [datetime2](7) NOT NULL,
		[TC_UsuarioRed]                  [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_MontoIndexacion]             [decimal](18, 2) NOT NULL,
		[TC_TipoMonto]                   [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_TipoPago]                    [smallint] NULL,
		[TN_MontoTotalIndexado]          [decimal](18, 2) NOT NULL,
		[TC_Indicador]                   [char](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodMoneda]                   [smallint] NOT NULL,
		[TU_CodigoDeuda]                 [uniqueidentifier] NULL,
		[TF_Particion]                   [datetime2](7) NOT NULL,
		CONSTRAINT [PK_CalculoIndexacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodigoCalculoIndexacion])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[CalculoIndexacion]
	ADD
	CONSTRAINT [CK_CalculoIndexacion_TipoMonto]
	CHECK
	([TC_TipoMonto]='F' OR [TC_TipoMonto]='V')
GO
ALTER TABLE [Expediente].[CalculoIndexacion]
CHECK CONSTRAINT [CK_CalculoIndexacion_TipoMonto]
GO
ALTER TABLE [Expediente].[CalculoIndexacion]
	ADD
	CONSTRAINT [CK_CalculoIndexacion_TipoPago]
	CHECK
	([TN_TipoPago]=(6) OR [TN_TipoPago]=(7) OR [TN_TipoPago]=(12) OR [TN_TipoPago]=(14) OR [TN_TipoPago]=(15) OR [TN_TipoPago]=(26) OR [TN_TipoPago]=(30))
GO
ALTER TABLE [Expediente].[CalculoIndexacion]
CHECK CONSTRAINT [CK_CalculoIndexacion_TipoPago]
GO
ALTER TABLE [Expediente].[CalculoIndexacion]
	ADD
	CONSTRAINT [CK_Indicador_CalculoIndexacion]
	CHECK
	([TC_Indicador]='I' OR [TC_Indicador]='P')
GO
ALTER TABLE [Expediente].[CalculoIndexacion]
CHECK CONSTRAINT [CK_Indicador_CalculoIndexacion]
GO
ALTER TABLE [Expediente].[CalculoIndexacion]
	ADD
	CONSTRAINT [DF__CalculoIn__TN_Mo__5E6C6FE7]
	DEFAULT ((0)) FOR [TN_MontoTotalIndexado]
GO
ALTER TABLE [Expediente].[CalculoIndexacion]
	ADD
	CONSTRAINT [DF__CalculoIn__TC_In__5F609420]
	DEFAULT ('I') FOR [TC_Indicador]
GO
ALTER TABLE [Expediente].[CalculoIndexacion]
	ADD
	CONSTRAINT [DF__CalculoIn__TN_Co__6054B859]
	DEFAULT ((1)) FOR [TN_CodMoneda]
GO
ALTER TABLE [Expediente].[CalculoIndexacion]
	ADD
	CONSTRAINT [DF__CalculoIn__TF_Pa__21236A85]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[CalculoIndexacion]
	WITH CHECK
	ADD CONSTRAINT [FK_CalculoIndexacion_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[CalculoIndexacion]
	CHECK CONSTRAINT [FK_CalculoIndexacion_Contexto]

GO
ALTER TABLE [Expediente].[CalculoIndexacion]
	WITH CHECK
	ADD CONSTRAINT [FK_CalculoIndexacion_Deuda]
	FOREIGN KEY ([TU_CodigoDeuda]) REFERENCES [Expediente].[Deuda] ([TU_CodigoDeuda])
ALTER TABLE [Expediente].[CalculoIndexacion]
	CHECK CONSTRAINT [FK_CalculoIndexacion_Deuda]

GO
ALTER TABLE [Expediente].[CalculoIndexacion]
	WITH CHECK
	ADD CONSTRAINT [FK_CalculoIndexacion_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[CalculoIndexacion]
	CHECK CONSTRAINT [FK_CalculoIndexacion_Expediente]

GO
ALTER TABLE [Expediente].[CalculoIndexacion]
	WITH CHECK
	ADD CONSTRAINT [FK_CalculoIndexacion_Moneda]
	FOREIGN KEY ([TN_CodMoneda]) REFERENCES [Catalogo].[Moneda] ([TN_CodMoneda])
ALTER TABLE [Expediente].[CalculoIndexacion]
	CHECK CONSTRAINT [FK_CalculoIndexacion_Moneda]

GO
CREATE CLUSTERED INDEX [IX_Expediente_CalculoIndexacion_TF_Particion]
	ON [Expediente].[CalculoIndexacion] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene los datos principales del cálculo de indexación', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cálculo de indexación', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', 'COLUMN', N'TU_CodigoCalculoIndexacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del cálculo de indexación', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de oficina', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de generación del cálculo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', 'COLUMN', N'TF_FechaCalculo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que realizó el cálculo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto a Indexar', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', 'COLUMN', N'TN_MontoIndexacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de monto para el cálculo: F para Fijo y V para Variable', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', 'COLUMN', N'TC_TipoMonto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de pago para el cálculo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', 'COLUMN', N'TN_TipoPago'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total del cálculo de indexación.', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', 'COLUMN', N'TN_MontoTotalIndexado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador utilizado para el cálculo: I para IPC, P para Prime Rate.', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', 'COLUMN', N'TC_Indicador'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Moneda utilizada para el cálculo.', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', 'COLUMN', N'TN_CodMoneda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deuda a la que se vincula en cálculo de indexación', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoIndexacion', 'COLUMN', N'TU_CodigoDeuda'
GO
ALTER TABLE [Expediente].[CalculoIndexacion] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[CalculoInteres] (
		[TU_CodigoCalculoInteres]            [uniqueidentifier] NOT NULL,
		[TF_FechaInicio]                     [datetime2](7) NOT NULL,
		[TF_FechaFinal]                      [datetime2](7) NOT NULL,
		[TC_TipoInteres]                     [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_EstadoCalculo]                   [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaResolucion]                 [datetime2](7) NULL,
		[TC_CodFormatoJuridico]              [varchar](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodResolucion]                   [uniqueidentifier] NULL,
		[TU_CodigoDeuda]                     [uniqueidentifier] NOT NULL,
		[TF_FechaCalculo]                    [datetime2](7) NOT NULL,
		[TC_UsuarioRed]                      [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]                     [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_CalculoLiquidado]                [bit] NOT NULL,
		[TB_CostasPersonales]                [bit] NOT NULL,
		[TB_EnFirme]                         [bit] NOT NULL,
		[TN_MontoCostasPersonales]           [decimal](18, 2) NOT NULL,
		[TN_SaldoCostasPersonales]           [decimal](18, 2) NOT NULL,
		[TN_MontoCostasProcesales]           [decimal](18, 2) NOT NULL,
		[TN_SaldoCostasProcesales]           [decimal](18, 2) NOT NULL,
		[TC_DescripcionCostasProcesales]     [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_MontoLiquidado]                  [decimal](18, 2) NOT NULL,
		[TN_SaldoMontoLiquidado]             [decimal](18, 2) NOT NULL,
		[TC_TipoCambioUsado]                 [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_MontoCambio]                     [decimal](6, 2) NULL,
		[TF_FechaTipoCambio]                 [datetime2](7) NULL,
		[TN_MontoTotal]                      [decimal](18, 2) NOT NULL,
		[TF_Particion]                       [datetime2](7) NOT NULL,
		CONSTRAINT [PK_CalculoInteres]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodigoCalculoInteres])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [CK_CalculoInteres_EstadoCalculo]
	CHECK
	([TC_EstadoCalculo]='P' OR [TC_EstadoCalculo]='T' OR [TC_EstadoCalculo]='A')
GO
ALTER TABLE [Expediente].[CalculoInteres]
CHECK CONSTRAINT [CK_CalculoInteres_EstadoCalculo]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [CK_CalculoInteres_TipoCalculo]
	CHECK
	([TC_TipoInteres]='C' OR [TC_TipoInteres]='M')
GO
ALTER TABLE [Expediente].[CalculoInteres]
CHECK CONSTRAINT [CK_CalculoInteres_TipoCalculo]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [CK_CalculoInteres_TipoCambioUsado]
	CHECK
	([TC_TipoCambioUsado]='A' OR [TC_TipoCambioUsado]='M')
GO
ALTER TABLE [Expediente].[CalculoInteres]
CHECK CONSTRAINT [CK_CalculoInteres_TipoCambioUsado]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [CK_CalculoInteres_TipoInteres]
	CHECK
	([TC_TipoInteres]='C' OR [TC_TipoInteres]='M')
GO
ALTER TABLE [Expediente].[CalculoInteres]
CHECK CONSTRAINT [CK_CalculoInteres_TipoInteres]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [DF_CalculoInteres_TB_CalculoLiquidado]
	DEFAULT ((0)) FOR [TB_CalculoLiquidado]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [DF_CalculoInteres_TB_CostasPersonales]
	DEFAULT ((0)) FOR [TB_CostasPersonales]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [DF_CalculoInteres_TB_EnFirme]
	DEFAULT ((0)) FOR [TB_EnFirme]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [DF_CalculoInteres_TN_MontoCostasPersonales]
	DEFAULT ((0)) FOR [TN_MontoCostasPersonales]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [DF_CalculoInteres_TN_SaldoCostasPersonales]
	DEFAULT ((0)) FOR [TN_SaldoCostasPersonales]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [DF_CalculoInteres_TN_MontoCostasProcesales]
	DEFAULT ((0)) FOR [TN_MontoCostasProcesales]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [DF_CalculoInteres_TN_SaldoCostasProcesales]
	DEFAULT ((0)) FOR [TN_SaldoCostasProcesales]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [DF_CalculoInteres_TN_MontoLiquidado]
	DEFAULT ((0)) FOR [TN_MontoLiquidado]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [DF_CalculoInteres_TN_SaldoMontoLiquidado]
	DEFAULT ((0)) FOR [TN_SaldoMontoLiquidado]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [DF_CalculoInteres_TN_MontoCambio]
	DEFAULT ((0)) FOR [TN_MontoCambio]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [DF_CalculoInteres_TN_MontoTotal]
	DEFAULT ((0)) FOR [TN_MontoTotal]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	ADD
	CONSTRAINT [DF__CalculoIn__TF_Pa__6DA3C67F]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[CalculoInteres]
	WITH CHECK
	ADD CONSTRAINT [FK_CalculoInteres_CalculoInteres]
	FOREIGN KEY ([TU_CodigoCalculoInteres]) REFERENCES [Expediente].[CalculoInteres] ([TU_CodigoCalculoInteres])
ALTER TABLE [Expediente].[CalculoInteres]
	CHECK CONSTRAINT [FK_CalculoInteres_CalculoInteres]

GO
ALTER TABLE [Expediente].[CalculoInteres]
	WITH CHECK
	ADD CONSTRAINT [FK_CalculoInteres_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[CalculoInteres]
	CHECK CONSTRAINT [FK_CalculoInteres_Contexto]

GO
CREATE CLUSTERED INDEX [IX_Expediente_CalculoInteres_TF_Particion]
	ON [Expediente].[CalculoInteres] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene los datos prinicipales de los cálculos de interés', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cálculo de intereses', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TU_CodigoCalculoInteres'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha inicial para el cálculo de intereses', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TF_FechaInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha final para el cálculo de intereses', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TF_FechaFinal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de cálculo utilizado: "C": Corriente, "M": Moratorio y "A : Ambos.', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TC_TipoInteres'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado del cálculo de intereses  Archivado = ''A'', Pendiente = ''P'', Terminado = ''T''', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TC_EstadoCalculo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de resolución del cálculo de intereses', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TF_FechaResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Formato jurídico seleccionado para el cálculo de intereses (Tipo de trámite)', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TC_CodFormatoJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de resolución generada para el cálculo de intereses', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TU_CodResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de deuda vinculada al cálculo de intereses', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TU_CodigoDeuda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha del cálculo de intereses', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TF_FechaCalculo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que realiza el cálculo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de oficina', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el cálculo de interés está liquidado (pagado)', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TB_CalculoLiquidado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si para el cálculo se señaló calcular las costas personales', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TB_CostasPersonales'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el cálculo de interés ya está en firme o no.', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TB_EnFirme'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene el monto de costas personales del cálculo según el decreto de la deuda', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TN_MontoCostasPersonales'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Saldo correspondiente a las costas personales', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TN_SaldoCostasPersonales'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene el monto de costas procesales del cálculo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TN_MontoCostasProcesales'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Saldo correspondiente a las costas procesales', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TN_SaldoCostasProcesales'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene el detalle de las costas procesales solicitadas', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TC_DescripcionCostasProcesales'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto del cálculo de intereses', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TN_MontoLiquidado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Saldo correspondiente al monto del cálculo de intereses', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TN_SaldoMontoLiquidado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Modo de obtención del tipo de cambio: A para Automático (BCCR) o M si se ingresó manualmente', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TC_TipoCambioUsado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto correspondiente al tipo de cambio', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TN_MontoCambio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha del tipo de cambio utilizado', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TF_FechaTipoCambio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto total del cálculo, incluídas las costas personales y procesales', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoInteres', 'COLUMN', N'TN_MontoTotal'
GO
ALTER TABLE [Expediente].[CalculoInteres] SET (LOCK_ESCALATION = TABLE)
GO

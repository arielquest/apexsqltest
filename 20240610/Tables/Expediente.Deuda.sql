SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[Deuda] (
		[TU_CodigoDeuda]                        [uniqueidentifier] NOT NULL,
		[TC_Descripcion]                        [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaCreacion]                      [datetime2](7) NOT NULL,
		[TC_ProcesoEstado]                      [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_TipoObligacion]                     [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_MontoDeuda]                         [decimal](18, 2) NOT NULL,
		[TN_MontoLPT]                           [decimal](18, 2) NULL,
		[TN_MontoObrero]                        [decimal](18, 2) NULL,
		[TN_MontoPatronal]                      [decimal](18, 2) NULL,
		[TN_MontoTrabajadorInd]                 [decimal](18, 2) NULL,
		[TN_ImpuestoRenta]                      [decimal](18, 2) NULL,
		[TN_ImpuestoVenta]                      [decimal](18, 2) NULL,
		[TN_Timbres]                            [decimal](18, 2) NULL,
		[TN_Sanciones]                          [decimal](18, 2) NULL,
		[TN_SaldoDeuda]                         [decimal](18, 2) NULL,
		[TN_CodMoneda]                          [smallint] NOT NULL,
		[TC_CodigoBanco]                        [char](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_TipoTasaInteres]                    [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Periodicidad]                       [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_TipoInteres]                        [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_InteresCorriente]                   [decimal](4, 2) NULL,
		[TN_InteresMoratorio]                   [decimal](4, 2) NULL,
		[TC_NumeroExpediente]                   [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodigoDecreto]                      [varchar](15) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_CostasPersonalesCapital]            [bit] NOT NULL,
		[TF_Particion]                          [datetime2](7) NOT NULL,
		[TN_MontoSobreGiro]                     [decimal](18, 2) NULL,
		[TN_InteresSobreGiro]                   [decimal](18, 2) NULL,
		[TF_FechaInicioSobreGiro]               [datetime2](7) NULL,
		[TF_FechaFinalSobreGiro]                [datetime2](7) NULL,
		[TN_MontoInteresSobreGiro]              [decimal](18, 2) NULL,
		[TN_TasaInteresPosterior]               [decimal](18, 2) NULL,
		[TF_FechaInteresPosterior]              [datetime2](7) NULL,
		[TN_TasaInteresPosteriorSobreGiro]      [decimal](18, 2) NULL,
		[TF_FechaInteresPosteriorSobreGiro]     [datetime2](7) NULL,
		CONSTRAINT [PK_Deuda]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodigoDeuda])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[Deuda]
	ADD
	CONSTRAINT [CK_Deuda_Periodicidad]
	CHECK
	([TC_Periodicidad]='D' OR [TC_Periodicidad]='S' OR [TC_Periodicidad]='Q' OR [TC_Periodicidad]='M' OR [TC_Periodicidad]='A')
GO
ALTER TABLE [Expediente].[Deuda]
CHECK CONSTRAINT [CK_Deuda_Periodicidad]
GO
ALTER TABLE [Expediente].[Deuda]
	ADD
	CONSTRAINT [CK_Deuda_ProcesoEstado]
	CHECK
	([TC_ProcesoEstado]='H' OR [TC_ProcesoEstado]='C' OR [TC_ProcesoEstado]='M' OR [TC_ProcesoEstado]='A' OR [TC_ProcesoEstado]='O' OR [TC_ProcesoEstado]='N')
GO
ALTER TABLE [Expediente].[Deuda]
CHECK CONSTRAINT [CK_Deuda_ProcesoEstado]
GO
ALTER TABLE [Expediente].[Deuda]
	ADD
	CONSTRAINT [CK_Deuda_TipoInteres]
	CHECK
	([TC_TipoInteres]='C' OR [TC_TipoInteres]='M' OR [TC_TipoInteres]='A')
GO
ALTER TABLE [Expediente].[Deuda]
CHECK CONSTRAINT [CK_Deuda_TipoInteres]
GO
ALTER TABLE [Expediente].[Deuda]
	ADD
	CONSTRAINT [CK_Deuda_TipoObligacion]
	CHECK
	([TC_TipoObligacion]='I' OR [TC_TipoObligacion]='C')
GO
ALTER TABLE [Expediente].[Deuda]
CHECK CONSTRAINT [CK_Deuda_TipoObligacion]
GO
ALTER TABLE [Expediente].[Deuda]
	ADD
	CONSTRAINT [CK_Deuda_TipoTasaInteres]
	CHECK
	([TC_TipoTasaInteres]='F' OR [TC_TipoTasaInteres]='L' OR [TC_TipoTasaInteres]='V')
GO
ALTER TABLE [Expediente].[Deuda]
CHECK CONSTRAINT [CK_Deuda_TipoTasaInteres]
GO
ALTER TABLE [Expediente].[Deuda]
	ADD
	CONSTRAINT [DF_Deuda_TB_CostasPersonalesCapital]
	DEFAULT ((0)) FOR [TB_CostasPersonalesCapital]
GO
ALTER TABLE [Expediente].[Deuda]
	ADD
	CONSTRAINT [DF__Deuda__TF_Partic__0857BCBB]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[Deuda]
	WITH CHECK
	ADD CONSTRAINT [FK_Deuda_Banco]
	FOREIGN KEY ([TC_CodigoBanco]) REFERENCES [Catalogo].[Banco] ([TC_CodigoBanco])
ALTER TABLE [Expediente].[Deuda]
	CHECK CONSTRAINT [FK_Deuda_Banco]

GO
ALTER TABLE [Expediente].[Deuda]
	WITH CHECK
	ADD CONSTRAINT [FK_Deuda_Decreto]
	FOREIGN KEY ([TC_CodigoDecreto]) REFERENCES [Catalogo].[Decreto] ([TC_CodigoDecreto])
ALTER TABLE [Expediente].[Deuda]
	CHECK CONSTRAINT [FK_Deuda_Decreto]

GO
ALTER TABLE [Expediente].[Deuda]
	WITH CHECK
	ADD CONSTRAINT [FK_Deuda_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[Deuda]
	CHECK CONSTRAINT [FK_Deuda_Expediente]

GO
ALTER TABLE [Expediente].[Deuda]
	WITH CHECK
	ADD CONSTRAINT [FK_Deuda_Moneda]
	FOREIGN KEY ([TN_CodMoneda]) REFERENCES [Catalogo].[Moneda] ([TN_CodMoneda])
ALTER TABLE [Expediente].[Deuda]
	CHECK CONSTRAINT [FK_Deuda_Moneda]

GO
CREATE CLUSTERED INDEX [IX_Expediente_Deuda_TF_Particion]
	ON [Expediente].[Deuda] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene el dato de la deuda en un expediente', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de deuda', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TU_CodigoDeuda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la deuda', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TF_FechaCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Proceso del estado: H para Hacienda, C para CCSS, M para IMAS, A para INA, O para COSEVI y N para Ninguno', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TC_ProcesoEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de obligación: I para Civil (360 días) y C para comercial (365 días)', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TC_TipoObligacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto de la deuda', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_MontoDeuda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto ley de protección al trabajador (Sólo procesos de Cobro del Estado CCSS)', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_MontoLPT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto cuota obrera (Sólo procesos de Cobro del Estado CCSS)', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_MontoObrero'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto cuota patronal (Sólo procesos de Cobro del Estado CCSS)', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_MontoPatronal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto correspondiente a Trabajador Independiente (para procesos de la CCSS)', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_MontoTrabajadorInd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto correspondiente a Impuesto de la Renta (procesos de Hacienda)', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_ImpuestoRenta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto correspondiente a Impuesto sobre la Venta (procesos de Hacienda)', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_ImpuestoVenta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto correspondiente a timbres (procesos de Hacienda)', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_Timbres'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto correspondiente a sanciones (procesos de Hacienda)', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_Sanciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Saldo de la deuda', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_SaldoDeuda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de moneda', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_CodMoneda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de banco', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TC_CodigoBanco'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de tasa de interés: F: Fija, L: Legal, V:Variable', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TC_TipoTasaInteres'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Periodicidad para tasa de interés variable: D para Diaria, S para Semanal, Q para Quincenal, M para Mensual y A para Anual', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TC_Periodicidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de interés: "A": Ambos, "C": Corriente, "M": Moratorio.', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TC_TipoInteres'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Interés corriente', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_InteresCorriente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Interés moratorio', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_InteresMoratorio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de decreto', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TC_CodigoDecreto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si ya se aplicó el cálculo de costas personales sobre el capital o monto de la deuda.', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TB_CostasPersonalesCapital'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que se utilizar para almacenar el monto correspiondiente al sobre giro (excedente en limite de credito)', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_MontoSobreGiro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tasa de interes que se aplica al sobre giro', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_InteresSobreGiro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio del sobre giro', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TF_FechaInicioSobreGiro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de finalización del sobre giro', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TF_FechaFinalSobreGiro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto del interes del sobre giro', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_MontoInteresSobreGiro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tasa interes posterior al sobre giro', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_TasaInteresPosterior'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de interes posterior', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TF_FechaInteresPosterior'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tasa interes posterior sobre giro', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TN_TasaInteresPosteriorSobreGiro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha interes posterior al sobre giro', 'SCHEMA', N'Expediente', 'TABLE', N'Deuda', 'COLUMN', N'TF_FechaInteresPosteriorSobreGiro'
GO
ALTER TABLE [Expediente].[Deuda] SET (LOCK_ESCALATION = TABLE)
GO

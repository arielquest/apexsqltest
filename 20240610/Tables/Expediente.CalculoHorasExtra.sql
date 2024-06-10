SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[CalculoHorasExtra] (
		[TU_CodigoCalculoHorasExtra]        [uniqueidentifier] NOT NULL,
		[TC_Descripcion]                    [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroExpediente]               [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodMoneda]                      [smallint] NOT NULL,
		[TC_CodContexto]                    [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaCalculo]                   [datetime2](7) NOT NULL,
		[TF_FechaInicio]                    [datetime2](7) NOT NULL,
		[TF_FechaFinal]                     [datetime2](7) NOT NULL,
		[TC_UsuarioRed]                     [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CantidadDiasFeriados]           [smallint] NULL,
		[TN_CantidadDiasIncapacidad]        [smallint] NULL,
		[TN_CantidadDiasNoLaborado]         [smallint] NULL,
		[TN_CantidadDiasVacaciones]         [smallint] NULL,
		[TN_CantidadHorasExtra]             [smallint] NOT NULL,
		[TN_CantidadHorasLaboradas]         [smallint] NOT NULL,
		[TN_FormaPago]                      [tinyint] NOT NULL,
		[TU_CodInterviniente]               [uniqueidentifier] NOT NULL,
		[TN_MontoSalarioMensual]            [decimal](18, 2) NOT NULL,
		[TN_MontoTotalHorasExtra]           [decimal](18, 2) NOT NULL,
		[TN_MontoUnitarioHoraExtra]         [decimal](18, 2) NOT NULL,
		[TB_CalculoHorasExtraEliminado]     [bit] NOT NULL,
		[TF_Particion]                      [datetime2](7) NOT NULL,
		CONSTRAINT [PK_CalculoHorasExtra]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodigoCalculoHorasExtra])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[CalculoHorasExtra]
	ADD
	CONSTRAINT [DF__CalculoHo__TF_Pa__487241D0]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[CalculoHorasExtra]
	WITH CHECK
	ADD CONSTRAINT [FK_CalculoHorasExtra_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[CalculoHorasExtra]
	CHECK CONSTRAINT [FK_CalculoHorasExtra_Contexto]

GO
ALTER TABLE [Expediente].[CalculoHorasExtra]
	WITH CHECK
	ADD CONSTRAINT [FK_CalculoHorasExtra_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[CalculoHorasExtra]
	CHECK CONSTRAINT [FK_CalculoHorasExtra_Expediente]

GO
ALTER TABLE [Expediente].[CalculoHorasExtra]
	WITH CHECK
	ADD CONSTRAINT [FK_CalculoHorasExtra_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[CalculoHorasExtra]
	CHECK CONSTRAINT [FK_CalculoHorasExtra_Intervencion]

GO
CREATE CLUSTERED INDEX [IX_Expediente_CalculoHorasExtra_TF_Particion]
	ON [Expediente].[CalculoHorasExtra] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_CalculoHorasExtra_Migracion]
	ON [Expediente].[CalculoHorasExtra] ([TC_NumeroExpediente], [TC_CodContexto], [TF_FechaCalculo], [TU_CodInterviniente])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene el detalle del cálculo de horas extra', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de cálculo de horas extra', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TU_CodigoCalculoHorasExtra'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del cálculo de indexación', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de moneda', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TN_CodMoneda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de oficina', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha del cálculo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TF_FechaCalculo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio del cálculo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TF_FechaInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha final del cálculo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TF_FechaFinal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que realizó el cálculo', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cantidad de días feriados', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TN_CantidadDiasFeriados'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cantidad de días no laborados por incapacidad', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TN_CantidadDiasIncapacidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cantidad de días no laborados por otros motivos', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TN_CantidadDiasNoLaborado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cantidad de días no laborados por vacaciones', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TN_CantidadDiasVacaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cantidad de horas extras reclamadas por el interviniente', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TN_CantidadHorasExtra'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cantidad de horas laboradas en el período', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TN_CantidadHorasLaboradas'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Forma de pago sólo puede llevar dos valores (26 días o 30 días)', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TN_FormaPago'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de interviniente', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Salario mensual', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TN_MontoSalarioMensual'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto de horas extra', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TN_MontoTotalHorasExtra'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Costo unitario de hora extra', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TN_MontoUnitarioHoraExtra'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el cálculo de horas extra está eliminado lógicamente', 'SCHEMA', N'Expediente', 'TABLE', N'CalculoHorasExtra', 'COLUMN', N'TB_CalculoHorasExtraEliminado'
GO
ALTER TABLE [Expediente].[CalculoHorasExtra] SET (LOCK_ESCALATION = TABLE)
GO

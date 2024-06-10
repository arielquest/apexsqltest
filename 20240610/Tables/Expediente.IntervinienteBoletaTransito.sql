SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[IntervinienteBoletaTransito] (
		[TU_CodBoletaTransito]      [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]       [uniqueidentifier] NOT NULL,
		[TC_Placa]                  [varchar](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_SerieBoleta]            [smallint] NOT NULL,
		[TN_NumeroBoleta]           [varchar](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]            [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaBoleta]            [datetime2](7) NOT NULL,
		[TN_CodMarcaVehiculo]       [smallint] NULL,
		[TC_Marca]                  [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodInspector]           [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NombreInspector]        [varchar](82) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_VehiculoDetenido]       [bit] NOT NULL,
		[TC_VehiculoDepositado]     [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_AutoridadRegistra]      [varchar](35) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]              [datetime2](7) NOT NULL,
		[TF_Actualizacion]          [datetime2](7) NOT NULL,
		[TB_Cargado]                [bit] NOT NULL,
		CONSTRAINT [U_TU_CodInterviniente]
		UNIQUE
		NONCLUSTERED
		([TU_CodInterviniente])
		ON [PRIMARY],
		CONSTRAINT [PK_IntervinienteBoletaTransito]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodBoletaTransito])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Expediente].[IntervinienteBoletaTransito]
	ADD
	CONSTRAINT [DF__Intervini__TF_Pa__01AABF2C]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervinienteBoletaTransito]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteBoletaTransito_Interviniente]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[IntervinienteBoletaTransito]
	CHECK CONSTRAINT [FK_IntervinienteBoletaTransito_Interviniente]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del registro de la boleta de tránsito.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TU_CodBoletaTransito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de placa del vehículo al que aplica la boleta de tránsito.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TC_Placa'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de serie de la boleta de tránsito.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TN_SerieBoleta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de la boleta de tránsito.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TN_NumeroBoleta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción opcional del registro de la boleta de tránsito.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la boleta de transito.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TF_FechaBoleta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de la marca.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TN_CodMarcaVehiculo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Marca del vehiculo colisionado.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TC_Marca'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del Inspector que confecciona el parte.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TC_CodInspector'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del Inspector que confecciona el parte.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TC_NombreInspector'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador si el vehiculo se encuentra detenido.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TB_VehiculoDetenido'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador de Vehiculo Depositado.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TC_VehiculoDepositado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Autoridad que registra el parte.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteBoletaTransito', 'COLUMN', N'TC_AutoridadRegistra'
GO
ALTER TABLE [Expediente].[IntervinienteBoletaTransito] SET (LOCK_ESCALATION = TABLE)
GO

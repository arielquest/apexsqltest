SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[PeriodoInventarioAmpliacion] (
		[TU_CodAmpliacion]          [uniqueidentifier] NOT NULL,
		[TU_CodPeriodo]             [uniqueidentifier] NOT NULL,
		[TC_Justificacion]          [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaFinalAnterior]     [datetime2](7) NOT NULL,
		[TF_FechaAplicacion]        [datetime2](7) NOT NULL,
		[TC_UsuarioRed]             [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Actualizacion]          [datetime2](7) NOT NULL,
		[TF_Particion]              [datetime2](7) NOT NULL,
		CONSTRAINT [PK_PeriodoInventarioAmpliacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodAmpliacion])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[PeriodoInventarioAmpliacion]
	ADD
	CONSTRAINT [DF_PeriodoInventarioAmpliacion_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[PeriodoInventarioAmpliacion]
	ADD
	CONSTRAINT [DF_PeriodoInventarioAmpliacion_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[PeriodoInventarioAmpliacion]
	WITH CHECK
	ADD CONSTRAINT [FK_PeriodoInventarioAmpliacion_PeriodoInventariado]
	FOREIGN KEY ([TU_CodPeriodo]) REFERENCES [Expediente].[PeriodoInventariado] ([TU_CodPeriodo])
ALTER TABLE [Expediente].[PeriodoInventarioAmpliacion]
	CHECK CONSTRAINT [FK_PeriodoInventarioAmpliacion_PeriodoInventariado]

GO
CREATE CLUSTERED INDEX [IX_PeriodoInventariadoAmpliacion_Particion]
	ON [Expediente].[PeriodoInventarioAmpliacion] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_FK_PeriodoInventariado_CodPeriodo]
	ON [Expediente].[PeriodoInventarioAmpliacion] ([TU_CodPeriodo])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para manejar las ampliaciones de los periodos de inventariado de expedientes. ', 'SCHEMA', N'Expediente', 'TABLE', N'PeriodoInventarioAmpliacion', NULL, NULL
GO
ALTER TABLE [Expediente].[PeriodoInventarioAmpliacion] SET (LOCK_ESCALATION = TABLE)
GO

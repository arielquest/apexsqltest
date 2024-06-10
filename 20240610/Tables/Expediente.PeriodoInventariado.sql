SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[PeriodoInventariado] (
		[TU_CodPeriodo]        [uniqueidentifier] NOT NULL,
		[TC_CodContexto]       [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NombrePeriodo]     [varchar](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fechainicio]       [datetime2](7) NOT NULL,
		[TF_FechaFinal]        [datetime2](7) NOT NULL,
		[TF_Actualizacion]     [datetime2](7) NOT NULL,
		[TF_Particion]         [datetime2](7) NOT NULL,
		CONSTRAINT [PK_PeriodoInventariado]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodPeriodo])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[PeriodoInventariado]
	ADD
	CONSTRAINT [DF_PeriodoInventariado_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[PeriodoInventariado]
	ADD
	CONSTRAINT [DF_PeriodoInventariado_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[PeriodoInventariado]
	WITH CHECK
	ADD CONSTRAINT [FK_PeriodoInventariado_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[PeriodoInventariado]
	CHECK CONSTRAINT [FK_PeriodoInventariado_Contexto]

GO
CREATE CLUSTERED INDEX [IX_PeriodoInventariado_Particion]
	ON [Expediente].[PeriodoInventariado] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_FK_PeriodoInventariado_CodContexto]
	ON [Expediente].[PeriodoInventariado] ([TC_CodContexto])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla para manejar los periodos de inventariado de expedientes ', 'SCHEMA', N'Expediente', 'TABLE', N'PeriodoInventariado', NULL, NULL
GO
ALTER TABLE [Expediente].[PeriodoInventariado] SET (LOCK_ESCALATION = TABLE)
GO

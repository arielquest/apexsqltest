SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[CriterioAsignacion] (
		[TU_CodCriterio]            [uniqueidentifier] NOT NULL,
		[TC_CodPuestoTrabajo]       [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_Asignaciones]           [smallint] NOT NULL,
		[TN_Adicionales]            [smallint] NOT NULL,
		[TN_TotalAcumulado]         [smallint] NOT NULL,
		[TF_UltimaAsignacion]       [datetime2](7) NOT NULL,
		[TU_CodConjuntoReparto]     [uniqueidentifier] NOT NULL,
		CONSTRAINT [PK_asignaciones]
		PRIMARY KEY
		CLUSTERED
		([TU_CodCriterio], [TC_CodPuestoTrabajo], [TU_CodConjuntoReparto])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[CriterioAsignacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Asignacion_Criterio]
	FOREIGN KEY ([TU_CodCriterio]) REFERENCES [Catalogo].[CriteriosReparto] ([TU_CodCriterio])
ALTER TABLE [Catalogo].[CriterioAsignacion]
	CHECK CONSTRAINT [FK_Asignacion_Criterio]

GO
ALTER TABLE [Catalogo].[CriterioAsignacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Asignacion_Puesto]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Catalogo].[CriterioAsignacion]
	CHECK CONSTRAINT [FK_Asignacion_Puesto]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único de la tabla', 'SCHEMA', N'Catalogo', 'TABLE', N'CriterioAsignacion', 'COLUMN', N'TU_CodCriterio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo asignado para el criterio de reparto', 'SCHEMA', N'Catalogo', 'TABLE', N'CriterioAsignacion', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total de asignaciones para la ronda de reparto para el puesto de trabajo', 'SCHEMA', N'Catalogo', 'TABLE', N'CriterioAsignacion', 'COLUMN', N'TN_Asignaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Expedientes que han sido revocados para el puesto de trabajo', 'SCHEMA', N'Catalogo', 'TABLE', N'CriterioAsignacion', 'COLUMN', N'TN_Adicionales'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total histórico de asignaciones', 'SCHEMA', N'Catalogo', 'TABLE', N'CriterioAsignacion', 'COLUMN', N'TN_TotalAcumulado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la última asignación', 'SCHEMA', N'Catalogo', 'TABLE', N'CriterioAsignacion', 'COLUMN', N'TF_UltimaAsignacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del conjunto de reparto al que pertence el puesto', 'SCHEMA', N'Catalogo', 'TABLE', N'CriterioAsignacion', 'COLUMN', N'TU_CodConjuntoReparto'
GO
ALTER TABLE [Catalogo].[CriterioAsignacion] SET (LOCK_ESCALATION = TABLE)
GO

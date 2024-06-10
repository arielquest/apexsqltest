SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Migracion].[EquivalenciaPuestoTrabajo] (
		[TC_CodPuestoTrabajoOrigen]      [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodPuestoTrabajoDestino]     [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]                 [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Oficina]                     [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la ubicacion asignada al funcionario en la oficina migrada, corresponde a codigo de oficina(CODDEJ) y al codigo de la ubicacion (UBIUSU)', 'SCHEMA', N'Migracion', 'TABLE', N'EquivalenciaPuestoTrabajo', 'COLUMN', N'TC_CodPuestoTrabajoOrigen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo migrado para la oficina judicial', 'SCHEMA', N'Migracion', 'TABLE', N'EquivalenciaPuestoTrabajo', 'COLUMN', N'TC_CodPuestoTrabajoDestino'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del Contexto al que pertenece el puesto de trabajo a corregir', 'SCHEMA', N'Migracion', 'TABLE', N'EquivalenciaPuestoTrabajo', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la oficina al que pertenece el puesto de trabajo a corregir', 'SCHEMA', N'Migracion', 'TABLE', N'EquivalenciaPuestoTrabajo', 'COLUMN', N'TC_Oficina'
GO
ALTER TABLE [Migracion].[EquivalenciaPuestoTrabajo] SET (LOCK_ESCALATION = TABLE)
GO

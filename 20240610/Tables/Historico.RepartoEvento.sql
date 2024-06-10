SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[RepartoEvento] (
		[TC_CodContexto]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodPuestoTrabajo]     [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CantidadCitas]        [int] NOT NULL,
		[TF_Actualizacion]        [datetime2](7) NOT NULL,
		CONSTRAINT [PK_RepartoEvento]
		PRIMARY KEY
		NONCLUSTERED
		([TC_CodContexto], [TC_CodPuestoTrabajo])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Historico].[RepartoEvento]
	ADD
	CONSTRAINT [DF_RepartoEvento_TN_CantidadCitas]
	DEFAULT ((0)) FOR [TN_CantidadCitas]
GO
ALTER TABLE [Historico].[RepartoEvento]
	ADD
	CONSTRAINT [DF_RepartoEvento_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
CREATE NONCLUSTERED INDEX [IX_RepartoEvento_Contexto]
	ON [Historico].[RepartoEvento] ([TC_CodContexto])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_RepartoEvento_Contexto_PuestoTrabajo]
	ON [Historico].[RepartoEvento] ([TC_CodContexto], [TC_CodPuestoTrabajo])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena el historial del reparto de citas asignadas a un puesto de trabajo por un contexto.', 'SCHEMA', N'Historico', 'TABLE', N'RepartoEvento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto al que corresponde el asignado.', 'SCHEMA', N'Historico', 'TABLE', N'RepartoEvento', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo al que corresponde el asignado.', 'SCHEMA', N'Historico', 'TABLE', N'RepartoEvento', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cantidad de citas que se le asignó a un  puesto de trabajo en un contexto.', 'SCHEMA', N'Historico', 'TABLE', N'RepartoEvento', 'COLUMN', N'TN_CantidadCitas'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Última fecha en que se actualiza la información del registro.', 'SCHEMA', N'Historico', 'TABLE', N'RepartoEvento', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Historico].[RepartoEvento] SET (LOCK_ESCALATION = TABLE)
GO

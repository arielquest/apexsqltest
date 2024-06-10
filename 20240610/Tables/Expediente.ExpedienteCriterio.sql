SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ExpedienteCriterio] (
		[TC_NumeroExpediente]      [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]           [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodLegajo]             [uniqueidentifier] NULL,
		[TN_CodCriterioManual]     [int] NOT NULL,
		[TU_CodCriterio]           [uniqueidentifier] NOT NULL,
		CONSTRAINT [PK_ExpedienteCriterio]
		PRIMARY KEY
		CLUSTERED
		([TU_CodCriterio])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Expediente].[ExpedienteCriterio]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteCriterio_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[ExpedienteCriterio]
	CHECK CONSTRAINT [FK_ExpedienteCriterio_Contexto]

GO
ALTER TABLE [Expediente].[ExpedienteCriterio]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteCriterio_CriterioManual]
	FOREIGN KEY ([TN_CodCriterioManual]) REFERENCES [Catalogo].[CriterioRepartoManual] ([TN_CodCriterioRepartoManual])
ALTER TABLE [Expediente].[ExpedienteCriterio]
	CHECK CONSTRAINT [FK_ExpedienteCriterio_CriterioManual]

GO
ALTER TABLE [Expediente].[ExpedienteCriterio]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteCriterio_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[ExpedienteCriterio]
	CHECK CONSTRAINT [FK_ExpedienteCriterio_Legajo]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteCriterio', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteCriterio', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteCriterio', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de criterio manual', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteCriterio', 'COLUMN', N'TN_CodCriterioManual'
GO
EXEC sp_addextendedproperty N'MS_Description', N'identificador de la tabla', 'SCHEMA', N'Expediente', 'TABLE', N'ExpedienteCriterio', 'COLUMN', N'TU_CodCriterio'
GO
ALTER TABLE [Expediente].[ExpedienteCriterio] SET (LOCK_ESCALATION = TABLE)
GO

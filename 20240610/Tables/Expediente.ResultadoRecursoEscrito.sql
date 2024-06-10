SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[ResultadoRecursoEscrito] (
		[TU_CodResultadoRecurso]     [uniqueidentifier] NOT NULL,
		[TU_CodEscrito]              [uniqueidentifier] NOT NULL,
		[TF_Particion]               [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Expediente_ResultadoRecursoEscrito]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodResultadoRecurso], [TU_CodEscrito])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[ResultadoRecursoEscrito]
	ADD
	CONSTRAINT [DF_ResultadoRecursoEscrito_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[ResultadoRecursoEscrito]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ResultadoRecursoEscrito_TU_CodEscrito]
	FOREIGN KEY ([TU_CodEscrito]) REFERENCES [Expediente].[EscritoExpediente] ([TU_CodEscrito])
ALTER TABLE [Expediente].[ResultadoRecursoEscrito]
	CHECK CONSTRAINT [FK_Expediente_ResultadoRecursoEscrito_TU_CodEscrito]

GO
ALTER TABLE [Expediente].[ResultadoRecursoEscrito]
	WITH CHECK
	ADD CONSTRAINT [FK_Expediente_ResultadoRecursoEscrito_TU_CodResultadoRecurso]
	FOREIGN KEY ([TU_CodResultadoRecurso]) REFERENCES [Expediente].[ResultadoRecurso] ([TU_CodResultadoRecurso])
ALTER TABLE [Expediente].[ResultadoRecursoEscrito]
	CHECK CONSTRAINT [FK_Expediente_ResultadoRecursoEscrito_TU_CodResultadoRecurso]

GO
CREATE CLUSTERED INDEX [IX_Expediente_ResultadoRecursoEscrito_TF_Particion]
	ON [Expediente].[ResultadoRecursoEscrito] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Entidad para conservar los escritos asociados a un resultado de un recurso', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecursoEscrito', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del resultado del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecursoEscrito', 'COLUMN', N'TU_CodResultadoRecurso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del escrito del expediente asociado al resultado del recurso.', 'SCHEMA', N'Expediente', 'TABLE', N'ResultadoRecursoEscrito', 'COLUMN', N'TU_CodEscrito'
GO
ALTER TABLE [Expediente].[ResultadoRecursoEscrito] SET (LOCK_ESCALATION = TABLE)
GO

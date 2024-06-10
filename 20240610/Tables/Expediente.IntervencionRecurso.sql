SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[IntervencionRecurso] (
		[TU_CodRecurso]           [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]     [uniqueidentifier] NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_IntervencionRecurso]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodRecurso], [TU_CodInterviniente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[IntervencionRecurso]
	ADD
	CONSTRAINT [DF__Intervenc__TF_Pa__057B5010]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervencionRecurso]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervinienteRecurso_Intervencio]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[IntervencionRecurso]
	CHECK CONSTRAINT [FK_IntervinienteRecurso_Intervencio]

GO
CREATE CLUSTERED INDEX [IX_Expediente_IntervencionRecurso_TF_Particion]
	ON [Expediente].[IntervencionRecurso] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del recurso al cual pertenece', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionRecurso', 'COLUMN', N'TU_CodRecurso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de interviniente', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionRecurso', 'COLUMN', N'TU_CodInterviniente'
GO
ALTER TABLE [Expediente].[IntervencionRecurso] SET (LOCK_ESCALATION = TABLE)
GO

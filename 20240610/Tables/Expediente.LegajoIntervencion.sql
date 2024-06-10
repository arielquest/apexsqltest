SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[LegajoIntervencion] (
		[TU_CodInterviniente]     [uniqueidentifier] NOT NULL,
		[TU_CodLegajo]            [uniqueidentifier] NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_LegajoIntervencion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodInterviniente], [TU_CodLegajo])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[LegajoIntervencion]
	ADD
	CONSTRAINT [DF__LegajoInt__TF_Pa__4A5A8A42]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[LegajoIntervencion]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervencionLegajo_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[LegajoIntervencion]
	CHECK CONSTRAINT [FK_IntervencionLegajo_Intervencion]

GO
ALTER TABLE [Expediente].[LegajoIntervencion]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervencionLegajo_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[LegajoIntervencion]
	CHECK CONSTRAINT [FK_IntervencionLegajo_Legajo]

GO
CREATE CLUSTERED INDEX [IX_Expediente_LegajoIntervencion_TF_Particion]
	ON [Expediente].[LegajoIntervencion] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_LegajoIntervencion_TU_Codlegajo]
	ON [Expediente].[LegajoIntervencion] ([TU_CodLegajo])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LegajoIntervencion_TU_Codlegajo]
	ON [Expediente].[LegajoIntervencion] ([TU_CodLegajo])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Permite señalar las intervenciones del expediente que son parte del legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoIntervencion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la intervención del expediente que se agrega al legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoIntervencion', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo en el que se agrega la intervención del expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'LegajoIntervencion', 'COLUMN', N'TU_CodLegajo'
GO
ALTER TABLE [Expediente].[LegajoIntervencion] SET (LOCK_ESCALATION = TABLE)
GO

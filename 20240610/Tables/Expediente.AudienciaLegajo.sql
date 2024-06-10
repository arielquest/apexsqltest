SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[AudienciaLegajo] (
		[TN_CodAudiencia]     [bigint] NOT NULL,
		[TU_CodLegajo]        [uniqueidentifier] NOT NULL,
		[TF_Particion]        [datetime2](7) NOT NULL,
		CONSTRAINT [PK_AudienciaLegajo]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodAudiencia], [TU_CodLegajo])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[AudienciaLegajo]
	ADD
	CONSTRAINT [DF__Audiencia__TF_Pa__4595D525]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[AudienciaLegajo]
	WITH CHECK
	ADD CONSTRAINT [FK_AudienciaLegajo_ExpedienteAudiencia]
	FOREIGN KEY ([TN_CodAudiencia]) REFERENCES [Expediente].[Audiencia] ([TN_CodAudiencia])
ALTER TABLE [Expediente].[AudienciaLegajo]
	CHECK CONSTRAINT [FK_AudienciaLegajo_ExpedienteAudiencia]

GO
ALTER TABLE [Expediente].[AudienciaLegajo]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteLegajo_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[AudienciaLegajo]
	CHECK CONSTRAINT [FK_ExpedienteLegajo_Legajo]

GO
CREATE CLUSTERED INDEX [IX_Expediente_AudienciaLegajo_TF_Particion]
	ON [Expediente].[AudienciaLegajo] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la relación de audiencias y legajos', 'SCHEMA', N'Expediente', 'TABLE', N'AudienciaLegajo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador correspondiente a la audiencia', 'SCHEMA', N'Expediente', 'TABLE', N'AudienciaLegajo', 'COLUMN', N'TN_CodAudiencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador correspondiente al legajo', 'SCHEMA', N'Expediente', 'TABLE', N'AudienciaLegajo', 'COLUMN', N'TU_CodLegajo'
GO
ALTER TABLE [Expediente].[AudienciaLegajo] SET (LOCK_ESCALATION = TABLE)
GO

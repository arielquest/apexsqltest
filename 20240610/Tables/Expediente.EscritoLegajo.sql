SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[EscritoLegajo] (
		[TU_CodEscrito]     [uniqueidentifier] NOT NULL,
		[TU_CodLegajo]      [uniqueidentifier] NOT NULL,
		[TF_Particion]      [datetime2](7) NOT NULL,
		CONSTRAINT [PK_EscritoLegajo]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodEscrito], [TU_CodLegajo])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[EscritoLegajo]
	ADD
	CONSTRAINT [DF__EscritoLe__TF_Pa__16A5DC12]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[EscritoLegajo]
	WITH CHECK
	ADD CONSTRAINT [FK_EscritoLegajo_EscritoExpediente]
	FOREIGN KEY ([TU_CodEscrito]) REFERENCES [Expediente].[EscritoExpediente] ([TU_CodEscrito])
ALTER TABLE [Expediente].[EscritoLegajo]
	CHECK CONSTRAINT [FK_EscritoLegajo_EscritoExpediente]

GO
ALTER TABLE [Expediente].[EscritoLegajo]
	WITH CHECK
	ADD CONSTRAINT [FK_EscritoLegajo_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[EscritoLegajo]
	CHECK CONSTRAINT [FK_EscritoLegajo_Legajo]

GO
CREATE CLUSTERED INDEX [IX_Expediente_EscritoLegajo_TF_Particion]
	ON [Expediente].[EscritoLegajo] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información del escrito asociado al legajo', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoLegajo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador correspondiente al escrito', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoLegajo', 'COLUMN', N'TU_CodEscrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador correspondiente al legajo', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoLegajo', 'COLUMN', N'TU_CodLegajo'
GO
ALTER TABLE [Expediente].[EscritoLegajo] SET (LOCK_ESCALATION = TABLE)
GO

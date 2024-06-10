SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[IntervencionMedioComunicacionLegajo] (
		[TU_CodMedioComunicacion]     [uniqueidentifier] NOT NULL,
		[TU_CodLegajo]                [uniqueidentifier] NOT NULL,
		[TN_PrioridadLegajo]          [smallint] NOT NULL,
		[TF_Particion]                [datetime2](7) NOT NULL,
		CONSTRAINT [PK_IntervencionMedioComunicacionLegajo]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodMedioComunicacion], [TU_CodLegajo])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacionLegajo]
	ADD
	CONSTRAINT [CK_IntervencionMedioComunicacionLegajo]
	CHECK
	([Expediente].[FN_ValidarIntervencionMedioComunicacionLegajos]([TU_CodMedioComunicacion],[TU_CodLegajo],[TN_PrioridadLegajo])=(1))
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valida que no se permita registrar medios de comunicación para un mismo interviniente en el mismo legajo, con la misma prioridad', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacionLegajo', 'CONSTRAINT', N'CK_IntervencionMedioComunicacionLegajo'
GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacionLegajo]
CHECK CONSTRAINT [CK_IntervencionMedioComunicacionLegajo]
GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacionLegajo]
	ADD
	CONSTRAINT [DF__Intervenc__TF_Pa__22178EBE]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacionLegajo]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervencionMedioComunicacionLegajo_IntervencionMedioComunicacion]
	FOREIGN KEY ([TU_CodMedioComunicacion]) REFERENCES [Expediente].[IntervencionMedioComunicacion] ([TU_CodMedioComunicacion])
ALTER TABLE [Expediente].[IntervencionMedioComunicacionLegajo]
	CHECK CONSTRAINT [FK_IntervencionMedioComunicacionLegajo_IntervencionMedioComunicacion]

GO
CREATE CLUSTERED INDEX [IX_Expediente_IntervencionMedioComunicacionLegajo_TF_Particion]
	ON [Expediente].[IntervencionMedioComunicacionLegajo] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_IntervencionMedioComunicacionLegajo_Migracion]
	ON [Expediente].[IntervencionMedioComunicacionLegajo] ([TU_CodMedioComunicacion], [TU_CodLegajo], [TN_PrioridadLegajo])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del medio de comunicación.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacionLegajo', 'COLUMN', N'TU_CodMedioComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del Legajo.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacionLegajo', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prioridad del medio de comunicación del Legajo. 1 = Primario, 2 = Accesorio', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacionLegajo', 'COLUMN', N'TN_PrioridadLegajo'
GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacionLegajo] SET (LOCK_ESCALATION = TABLE)
GO

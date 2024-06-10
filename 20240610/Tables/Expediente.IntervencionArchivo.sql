SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[IntervencionArchivo] (
		[TU_CodArchivo]           [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]     [uniqueidentifier] NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_IntervencionArchivo]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodArchivo], [TU_CodInterviniente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[IntervencionArchivo]
	ADD
	CONSTRAINT [DF__Intervenc__TF_Pa__23FFD730]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervencionArchivo]
	WITH CHECK
	ADD CONSTRAINT [Expediente.FK_IntervencionArchivo_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Expediente].[IntervencionArchivo]
	CHECK CONSTRAINT [Expediente.FK_IntervencionArchivo_Archivo]

GO
ALTER TABLE [Expediente].[IntervencionArchivo]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervencionArchivo_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[IntervencionArchivo]
	CHECK CONSTRAINT [FK_IntervencionArchivo_Intervencion]

GO
CREATE CLUSTERED INDEX [IX_Expediente_IntervencionArchivo]
	ON [Expediente].[IntervencionArchivo] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del archivo.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionArchivo', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de intervención.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionArchivo', 'COLUMN', N'TU_CodInterviniente'
GO
ALTER TABLE [Expediente].[IntervencionArchivo] SET (LOCK_ESCALATION = TABLE)
GO

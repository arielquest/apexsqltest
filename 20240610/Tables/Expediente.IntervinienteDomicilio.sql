SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[IntervinienteDomicilio] (
		[TU_CodDomicilio]         [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]     [uniqueidentifier] NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_DomicilioInterviniente]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodDomicilio], [TU_CodInterviniente])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[IntervinienteDomicilio]
	ADD
	CONSTRAINT [DF__Intervini__TF_Pa__1F3B2213]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervinienteDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DomicilioInterviniente_Domicilio]
	FOREIGN KEY ([TU_CodDomicilio]) REFERENCES [Persona].[Domicilio] ([TU_CodDomicilio])
ALTER TABLE [Expediente].[IntervinienteDomicilio]
	CHECK CONSTRAINT [FK_DomicilioInterviniente_Domicilio]

GO
ALTER TABLE [Expediente].[IntervinienteDomicilio]
	WITH CHECK
	ADD CONSTRAINT [FK_DomicilioInterviniente_Interviniente]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[IntervinienteDomicilio]
	CHECK CONSTRAINT [FK_DomicilioInterviniente_Interviniente]

GO
CREATE CLUSTERED INDEX [IX_Expediente_IntervinienteDomicilio_TF_Particion]
	ON [Expediente].[IntervinienteDomicilio] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Domicilio]
	ON [Expediente].[IntervinienteDomicilio] ([TU_CodDomicilio])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Interviniente]
	ON [Expediente].[IntervinienteDomicilio] ([TU_CodInterviniente])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la asociación de domicilios de la persona con el interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDomicilio', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del domicilio de la persona.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDomicilio', 'COLUMN', N'TU_CodDomicilio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervinienteDomicilio', 'COLUMN', N'TU_CodInterviniente'
GO
ALTER TABLE [Expediente].[IntervinienteDomicilio] SET (LOCK_ESCALATION = TABLE)
GO

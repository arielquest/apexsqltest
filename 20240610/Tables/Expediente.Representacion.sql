SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Expediente].[Representacion] (
		[TU_CodInterviniente]                  [uniqueidentifier] NOT NULL,
		[TU_CodIntervinienteRepresentante]     [uniqueidentifier] NOT NULL,
		[TN_CodTipoRepresentacion]             [smallint] NOT NULL,
		[TB_Principal]                         [bit] NULL,
		[TB_NotificaRepresentante]             [bit] NULL,
		[TF_Inicio_Vigencia]                   [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]                      [datetime2](7) NOT NULL,
		[TF_Particion]                         [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Representacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodInterviniente], [TU_CodIntervinienteRepresentante])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[Representacion]
	ADD
	CONSTRAINT [DF__Represent__TF_Pa__7A099D64]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[Representacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Representacion_Intervencion]
	FOREIGN KEY ([TU_CodIntervinienteRepresentante]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[Representacion]
	CHECK CONSTRAINT [FK_Representacion_Intervencion]

GO
ALTER TABLE [Expediente].[Representacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Representacion_Representante]
	FOREIGN KEY ([TU_CodIntervinienteRepresentante]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[Representacion]
	CHECK CONSTRAINT [FK_Representacion_Representante]

GO
ALTER TABLE [Expediente].[Representacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Representacion_TipoRepresentacion]
	FOREIGN KEY ([TN_CodTipoRepresentacion]) REFERENCES [Catalogo].[TipoRepresentacion] ([TN_CodTipoRepresentacion])
ALTER TABLE [Expediente].[Representacion]
	CHECK CONSTRAINT [FK_Representacion_TipoRepresentacion]

GO
CREATE CLUSTERED INDEX [IX_Expediente_Representacion_TF_Participacion]
	ON [Expediente].[Representacion] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificdor único del interviniente.', 'SCHEMA', N'Expediente', 'TABLE', N'Representacion', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del representante.', 'SCHEMA', N'Expediente', 'TABLE', N'Representacion', 'COLUMN', N'TU_CodIntervinienteRepresentante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del tipo de representación.', 'SCHEMA', N'Expediente', 'TABLE', N'Representacion', 'COLUMN', N'TN_CodTipoRepresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la representación es la principal', 'SCHEMA', N'Expediente', 'TABLE', N'Representacion', 'COLUMN', N'TB_Principal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si se notifica al representante para esta representación', 'SCHEMA', N'Expediente', 'TABLE', N'Representacion', 'COLUMN', N'TB_NotificaRepresentante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia de la representación', 'SCHEMA', N'Expediente', 'TABLE', N'Representacion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia de la representación', 'SCHEMA', N'Expediente', 'TABLE', N'Representacion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Expediente].[Representacion] SET (LOCK_ESCALATION = TABLE)
GO

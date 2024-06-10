SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[Prevencion] (
		[TU_CodPrevencion]         [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]      [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]           [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodInterviniente]      [uniqueidentifier] NOT NULL,
		[TN_CodTipoPrevencion]     [smallint] NOT NULL,
		[TN_Monto]                 [decimal](18, 2) NULL,
		[TF_Actualizacion]         [datetime2](7) NOT NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		[TB_Activa]                [bit] NOT NULL,
		CONSTRAINT [PK_Prevencion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodPrevencion])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Expediente].[Prevencion]
	ADD
	CONSTRAINT [DF__Prevencio__TF_Ac__3DCB6182]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[Prevencion]
	ADD
	CONSTRAINT [DF__Prevencio__TF_Pa__3EBF85BB]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[Prevencion]
	ADD
	CONSTRAINT [DF_Prevencion_TB_Activa]
	DEFAULT ((1)) FOR [TB_Activa]
GO
ALTER TABLE [Expediente].[Prevencion]
	WITH CHECK
	ADD CONSTRAINT [FK_Prevencion_ExpedienteDetalle]
	FOREIGN KEY ([TC_NumeroExpediente], [TC_CodContexto]) REFERENCES [Expediente].[ExpedienteDetalle] ([TC_NumeroExpediente], [TC_CodContexto])
ALTER TABLE [Expediente].[Prevencion]
	CHECK CONSTRAINT [FK_Prevencion_ExpedienteDetalle]

GO
ALTER TABLE [Expediente].[Prevencion]
	WITH CHECK
	ADD CONSTRAINT [FK_Prevencion_Interviniente]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[Prevencion]
	CHECK CONSTRAINT [FK_Prevencion_Interviniente]

GO
ALTER TABLE [Expediente].[Prevencion]
	WITH CHECK
	ADD CONSTRAINT [FK_Prevencion_TipoPrevencion]
	FOREIGN KEY ([TN_CodTipoPrevencion]) REFERENCES [Catalogo].[TipoPrevencion] ([TN_CodTipoPrevencion])
ALTER TABLE [Expediente].[Prevencion]
	CHECK CONSTRAINT [FK_Prevencion_TipoPrevencion]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla de registros de prevención asociados a un expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'Prevencion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único del registro de Prevención', 'SCHEMA', N'Expediente', 'TABLE', N'Prevencion', 'COLUMN', N'TU_CodPrevencion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el código del Expediente que hace referencia a la tabla de Prevencion', 'SCHEMA', N'Expediente', 'TABLE', N'Prevencion', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto al que corresponde la Prevención.', 'SCHEMA', N'Expediente', 'TABLE', N'Prevencion', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la intervención asociada', 'SCHEMA', N'Expediente', 'TABLE', N'Prevencion', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del Tipo de Prevención asociado', 'SCHEMA', N'Expediente', 'TABLE', N'Prevencion', 'COLUMN', N'TN_CodTipoPrevencion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Monto de la prevención', 'SCHEMA', N'Expediente', 'TABLE', N'Prevencion', 'COLUMN', N'TN_Monto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora de registro o última actualización realizada al registro. Usado por SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'Prevencion', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la prevención se encuentra activa o no, por defecto se encuentra activa', 'SCHEMA', N'Expediente', 'TABLE', N'Prevencion', 'COLUMN', N'TB_Activa'
GO
ALTER TABLE [Expediente].[Prevencion] SET (LOCK_ESCALATION = TABLE)
GO

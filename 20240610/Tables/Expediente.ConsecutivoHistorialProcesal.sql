SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ConsecutivoHistorialProcesal] (
		[TU_CodHistorialConsecutivo]     [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]            [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodLegajo]                   [uniqueidentifier] NULL,
		[TN_Consecutivo]                 [int] NOT NULL,
		[TF_Actualizacion]               [datetime2](7) NOT NULL,
		[TF_Particion]                   [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ConsecutivoHistorialProcesal]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodHistorialConsecutivo])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Expediente].[ConsecutivoHistorialProcesal]
	ADD
	CONSTRAINT [DF_ConsecutivoHistorialProcesal_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[ConsecutivoHistorialProcesal]
	ADD
	CONSTRAINT [DF__Consecuti__TF_Pa__4D36F6ED]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[ConsecutivoHistorialProcesal]
	ADD
	CONSTRAINT [DF_ConsecutivoHistorialProcesal_TN_Consecutivo]
	DEFAULT ((1)) FOR [TN_Consecutivo]
GO
ALTER TABLE [Expediente].[ConsecutivoHistorialProcesal]
	WITH CHECK
	ADD CONSTRAINT [FK_ConsecutivoHistorialProcesal_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[ConsecutivoHistorialProcesal]
	CHECK CONSTRAINT [FK_ConsecutivoHistorialProcesal_Expediente]

GO
ALTER TABLE [Expediente].[ConsecutivoHistorialProcesal]
	WITH CHECK
	ADD CONSTRAINT [FK_ConsecutivoHistorialProcesal_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[ConsecutivoHistorialProcesal]
	CHECK CONSTRAINT [FK_ConsecutivoHistorialProcesal_Legajo]

GO
CREATE NONCLUSTERED INDEX [Idx_TC_NumeroExpediente_TU_CodLegajo]
	ON [Expediente].[ConsecutivoHistorialProcesal] ([TC_NumeroExpediente], [TU_CodLegajo])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de consecutivo de historial procesal', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoHistorialProcesal', 'COLUMN', N'TU_CodHistorialConsecutivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoHistorialProcesal', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de legajo', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoHistorialProcesal', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor del consecutivo actual que tiene el expediente en el historial procesal', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoHistorialProcesal', 'COLUMN', N'TN_Consecutivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización', 'SCHEMA', N'Expediente', 'TABLE', N'ConsecutivoHistorialProcesal', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Expediente].[ConsecutivoHistorialProcesal] SET (LOCK_ESCALATION = TABLE)
GO

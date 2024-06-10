SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [DefensaPublica].[Asignacion] (
		[TU_CodAsignacion]             [uniqueidentifier] NOT NULL,
		[TU_CodRepresentacion]         [uniqueidentifier] NOT NULL,
		[TN_CodMotivoFinalizacion]     [smallint] NULL,
		[TC_CodPuestoTrabajo]          [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Inicio_Vigencia]           [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]              [datetime2](7) NULL,
		[TF_Actualizacion]             [datetime2](7) NOT NULL,
		[TF_Particion]                 [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Asignacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodAsignacion])
	ON [PRIMARY]
) ON [DefPubPS] ([TF_Particion])
GO
ALTER TABLE [DefensaPublica].[Asignacion]
	ADD
	CONSTRAINT [DF__Asignacio__TF_Ac__45FE52CB]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [DefensaPublica].[Asignacion]
	ADD
	CONSTRAINT [DF__Asignacio__TF_Pa__13C96F67]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [DefensaPublica].[Asignacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Asignacion_MotivoFinalizacion]
	FOREIGN KEY ([TN_CodMotivoFinalizacion]) REFERENCES [Catalogo].[MotivoFinalizacion] ([TN_CodMotivoFinalizacion])
ALTER TABLE [DefensaPublica].[Asignacion]
	CHECK CONSTRAINT [FK_Asignacion_MotivoFinalizacion]

GO
ALTER TABLE [DefensaPublica].[Asignacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Asignacion_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [DefensaPublica].[Asignacion]
	CHECK CONSTRAINT [FK_Asignacion_PuestoTrabajo]

GO
ALTER TABLE [DefensaPublica].[Asignacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Asignacion_Representacion]
	FOREIGN KEY ([TU_CodRepresentacion]) REFERENCES [DefensaPublica].[Representacion] ([TU_CodRepresentacion])
ALTER TABLE [DefensaPublica].[Asignacion]
	CHECK CONSTRAINT [FK_Asignacion_Representacion]

GO
CREATE CLUSTERED INDEX [IX_DefensaPublica_Asignacion_TF_Particion]
	ON [DefensaPublica].[Asignacion] ([TF_Particion])
	ON [DefPubPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico de la asignacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Asignacion', 'COLUMN', N'TU_CodAsignacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico de la representacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Asignacion', 'COLUMN', N'TU_CodRepresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico del motivo de finalizcion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Asignacion', 'COLUMN', N'TN_CodMotivoFinalizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo definido para un número  de oficina, cuatro letras y consecutivo.', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Asignacion', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de la asignacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Asignacion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de la asignacion', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Asignacion', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de ultima actualizacion para sigma', 'SCHEMA', N'DefensaPublica', 'TABLE', N'Asignacion', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [DefensaPublica].[Asignacion] SET (LOCK_ESCALATION = TABLE)
GO

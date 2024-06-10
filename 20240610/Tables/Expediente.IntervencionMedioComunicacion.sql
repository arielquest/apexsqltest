SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[IntervencionMedioComunicacion] (
		[TU_CodMedioComunicacion]     [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]         [uniqueidentifier] NOT NULL,
		[TN_PrioridadExpediente]      [smallint] NOT NULL,
		[TN_CodMedio]                 [smallint] NOT NULL,
		[TC_Valor]                    [varchar](350) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodProvincia]             [smallint] NULL,
		[TN_CodCanton]                [smallint] NULL,
		[TN_CodDistrito]              [smallint] NULL,
		[TN_CodBarrio]                [smallint] NULL,
		[TC_Rotulado]                 [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]            [datetime2](7) NULL,
		[TG_UbicacionPunto]           [geography] NULL,
		[TN_CodHorario]               [smallint] NULL,
		[TB_PerteneceExpediente]      [bit] NULL,
		[IDDOMI]                      [int] NULL,
		[TF_Particion]                [datetime2](7) NOT NULL,
		CONSTRAINT [PK_IntervencionMedioComunicacion_1]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodMedioComunicacion])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacion]
	ADD
	CONSTRAINT [CK_IntervencionMedioComunicacion_PrioridadExpediente]
	CHECK
	([TN_PrioridadExpediente]=(1) OR [TN_PrioridadExpediente]=(2))
GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacion]
CHECK CONSTRAINT [CK_IntervencionMedioComunicacion_PrioridadExpediente]
GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacion]
	ADD
	CONSTRAINT [CK_IntervencionMedioComunicacionExpediente]
	CHECK
	([Expediente].[FN_ValidarIntervencionMedioComunicacionExpediente]([TU_CodMedioComunicacion],[TU_CodInterviniente],[TN_PrioridadExpediente],[TB_PerteneceExpediente])=(1))
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valida que no se permita registrar medios de comunicación para un mismo interviniente en el expediente, con la misma prioridad', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'CONSTRAINT', N'CK_IntervencionMedioComunicacionExpediente'
GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacion]
CHECK CONSTRAINT [CK_IntervencionMedioComunicacionExpediente]
GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacion]
	ADD
	CONSTRAINT [DF__Intervenc__TF_Ac__2A212E2C]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacion]
	ADD
	CONSTRAINT [DF__Intervenc__TF_Pa__094BE0F4]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervencionMedioComunicacion_Barrio]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio]) REFERENCES [Catalogo].[Barrio] ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio])
ALTER TABLE [Expediente].[IntervencionMedioComunicacion]
	CHECK CONSTRAINT [FK_IntervencionMedioComunicacion_Barrio]

GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervencionMedioComunicacion_HorarioMedioComunicacion]
	FOREIGN KEY ([TN_CodHorario]) REFERENCES [Catalogo].[HorarioMedioComunicacion] ([TN_CodHorario])
ALTER TABLE [Expediente].[IntervencionMedioComunicacion]
	CHECK CONSTRAINT [FK_IntervencionMedioComunicacion_HorarioMedioComunicacion]

GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_IntervencionMedioComunicacion_Intervencion]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Expediente].[IntervencionMedioComunicacion]
	CHECK CONSTRAINT [FK_IntervencionMedioComunicacion_Intervencion]

GO
CREATE CLUSTERED INDEX [IX_Expediente_IntervencionMedioComunicacion_TF_Particion]
	ON [Expediente].[IntervencionMedioComunicacion] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_IntervencionMedioComunicacion_Migracion]
	ON [Expediente].[IntervencionMedioComunicacion] ([TU_CodInterviniente], [TN_PrioridadExpediente], [TB_PerteneceExpediente])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los medios de comunicación del Intervencion.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del medio de comunicación.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TU_CodMedioComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de interviniente', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prioridad del medio de comunicación. 1 = Primario, 2 = Accesorio', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TN_PrioridadExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo de medios de comunicación.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TN_CodMedio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena diferentes datos, puede ser la dirección, teléfono, fax, email, etc.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TC_Valor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la provincia.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cantón.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TN_CodCanton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del distrito.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TN_CodDistrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del barrio.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TN_CodBarrio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rotulado que se debe mostrar al enviar fax o email.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TC_Rotulado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de última actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene los punto geograficos del medio comunicacion', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TG_UbicacionPunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Indentificador para el horario de medio de comunicacion', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TN_CodHorario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el medio de comunicación pertenece a un expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'IntervencionMedioComunicacion', 'COLUMN', N'TB_PerteneceExpediente'
GO
ALTER TABLE [Expediente].[IntervencionMedioComunicacion] SET (LOCK_ESCALATION = TABLE)
GO

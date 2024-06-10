SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[EscritoExpediente] (
		[TU_CodEscrito]              [uniqueidentifier] NOT NULL,
		[TC_CodPuestoTrabajo]        [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_NumeroExpediente]        [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoEscrito]          [smallint] NOT NULL,
		[TC_CodContexto]             [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodEntrega]              [varchar](12) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Descripcion]             [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaIngresoOficina]     [datetime2](2) NOT NULL,
		[TC_IDARCHIVO]               [uniqueidentifier] NULL,
		[TF_FechaEnvio]              [datetime2](2) NOT NULL,
		[TC_EstadoEscrito]           [varchar](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaRegistro]           [datetime2](3) NOT NULL,
		[TN_Consecutivo]             [int] NULL,
		[TB_VariasGestiones]         [bit] NOT NULL,
		[TF_Particion]               [datetime2](7) NOT NULL,
		[IDACO]                      [int] NULL,
		CONSTRAINT [PK_EscritoExpediente]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodEscrito])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[EscritoExpediente]
	ADD
	CONSTRAINT [CK_EscritoExpediente_Estado]
	CHECK
	([TC_EstadoEscrito]='P' OR [TC_EstadoEscrito]='T' OR [TC_EstadoEscrito]='R' OR [TC_EstadoEscrito]='E')
GO
ALTER TABLE [Expediente].[EscritoExpediente]
CHECK CONSTRAINT [CK_EscritoExpediente_Estado]
GO
ALTER TABLE [Expediente].[EscritoExpediente]
	ADD
	CONSTRAINT [DF__EscritoEx__TF_Fe__611EBF60]
	DEFAULT (getdate()) FOR [TF_FechaRegistro]
GO
ALTER TABLE [Expediente].[EscritoExpediente]
	ADD
	CONSTRAINT [DF_EscritoExpediente_TB_VariasGestiones]
	DEFAULT ((0)) FOR [TB_VariasGestiones]
GO
ALTER TABLE [Expediente].[EscritoExpediente]
	ADD
	CONSTRAINT [DF__EscritoEx__TF_Pa__6049CB61]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[EscritoExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_Escrito_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Expediente].[EscritoExpediente]
	CHECK CONSTRAINT [FK_Escrito_PuestoTrabajo]

GO
ALTER TABLE [Expediente].[EscritoExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_EscritoExpediente_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[EscritoExpediente]
	CHECK CONSTRAINT [FK_EscritoExpediente_Contexto]

GO
ALTER TABLE [Expediente].[EscritoExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_EscritoExpediente_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[EscritoExpediente]
	CHECK CONSTRAINT [FK_EscritoExpediente_Expediente]

GO
ALTER TABLE [Expediente].[EscritoExpediente]
	WITH CHECK
	ADD CONSTRAINT [FK_EscritoExpediente_TipoEscrito(Catalogo)]
	FOREIGN KEY ([TN_CodTipoEscrito]) REFERENCES [Catalogo].[TipoEscrito] ([TN_CodTipoEscrito])
ALTER TABLE [Expediente].[EscritoExpediente]
	CHECK CONSTRAINT [FK_EscritoExpediente_TipoEscrito(Catalogo)]

GO
CREATE CLUSTERED INDEX [IX_Expediente_EscritoExpediente_TF_Particion]
	ON [Expediente].[EscritoExpediente] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_Exped_EscritoExped_TN_CodTipoEscrito_INCLUDE]
	ON [Expediente].[EscritoExpediente] ([TN_CodTipoEscrito])
	INCLUDE ([TU_CodEscrito], [TC_NumeroExpediente], [TC_CodContexto], [TC_Descripcion], [TF_FechaIngresoOficina], [TC_IDARCHIVO], [TF_FechaEnvio], [TC_EstadoEscrito], [TN_Consecutivo], [TB_VariasGestiones])
	WITH ( FILLFACTOR = 100)
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_EscritoExpediente_Migracion]
	ON [Expediente].[EscritoExpediente] ([TC_NumeroExpediente], [TN_CodTipoEscrito], [TC_CodContexto], [TF_FechaIngresoOficina], [TC_EstadoEscrito], [TF_FechaRegistro])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de los escritos', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del escrito', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TU_CodEscrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo al cual se le asigna el escrito', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente único al que va dirigido el escrito', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de escrito', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TN_CodTipoEscrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto donde se encuentra el escrito', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de la entrega con el escrito', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TC_CodEntrega'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del escrito', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que ingresa el escrito a la oficina', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TF_FechaIngresoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del archivo. Mismo identificador que tiene el archivo en la base de datos FileStream', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TC_IDARCHIVO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se envía el escrito', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TF_FechaEnvio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena el tipo de escrito del escrito registrado. Donde: P=Pendiente, T=Tramitandose, R=Resuelto, E=Traslado', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TC_EstadoEscrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena fecha y hora de registro en CEREDOC', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TF_FechaRegistro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Consecutivo asignado para el Historial Procesal', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TN_Consecutivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el escrito posee varias gestiones', 'SCHEMA', N'Expediente', 'TABLE', N'EscritoExpediente', 'COLUMN', N'TB_VariasGestiones'
GO
ALTER TABLE [Expediente].[EscritoExpediente] SET (LOCK_ESCALATION = TABLE)
GO

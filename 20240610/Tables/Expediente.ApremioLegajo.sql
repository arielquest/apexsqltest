SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[ApremioLegajo] (
		[TU_CodApremio]              [uniqueidentifier] NOT NULL,
		[TU_CodLegajo]               [uniqueidentifier] NOT NULL,
		[TC_CodPuestoTrabajo]        [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodContexto]             [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodEntrega]              [varchar](12) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Descripcion]             [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaIngresoOficina]     [datetime2](2) NOT NULL,
		[TC_IDARCHIVO]               [uniqueidentifier] NOT NULL,
		[TF_FechaEnvio]              [datetime2](2) NOT NULL,
		[TC_EstadoApremio]           [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_OrigenApremio]           [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioEntrega]          [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_TramiteOrdenApremio]     [varchar](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaEstado]             [datetime2](2) NOT NULL,
		[TF_Particion]               [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ApremioLegajo]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodApremio], [TU_CodLegajo])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[ApremioLegajo]
	ADD
	CONSTRAINT [CK_EstadoApremioLegajo]
	CHECK
	([TC_EstadoApremio]='P' OR [TC_EstadoApremio]='A' OR [TC_EstadoApremio]='R' OR [TC_EstadoApremio]='C' OR [TC_EstadoApremio]='T')
GO
ALTER TABLE [Expediente].[ApremioLegajo]
CHECK CONSTRAINT [CK_EstadoApremioLegajo]
GO
ALTER TABLE [Expediente].[ApremioLegajo]
	ADD
	CONSTRAINT [CK_OrigenApremioLegajo]
	CHECK
	([TC_OrigenApremio]='A' OR [TC_OrigenApremio]='G' OR [TC_OrigenApremio]='S')
GO
ALTER TABLE [Expediente].[ApremioLegajo]
CHECK CONSTRAINT [CK_OrigenApremioLegajo]
GO
ALTER TABLE [Expediente].[ApremioLegajo]
	ADD
	CONSTRAINT [CK_TramiteOrdenApremio]
	CHECK
	([TC_TramiteOrdenApremio]='D' OR [TC_TramiteOrdenApremio]='P' OR [TC_TramiteOrdenApremio]='I' OR [TC_TramiteOrdenApremio]='C')
GO
ALTER TABLE [Expediente].[ApremioLegajo]
CHECK CONSTRAINT [CK_TramiteOrdenApremio]
GO
ALTER TABLE [Expediente].[ApremioLegajo]
	ADD
	CONSTRAINT [DF_ApremioLegajo_TF_FechaEstado]
	DEFAULT (getdate()) FOR [TF_FechaEstado]
GO
ALTER TABLE [Expediente].[ApremioLegajo]
	ADD
	CONSTRAINT [DF_ApremioLegajo_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[ApremioLegajo]
	WITH CHECK
	ADD CONSTRAINT [FK_ApremioLegajo_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[ApremioLegajo]
	CHECK CONSTRAINT [FK_ApremioLegajo_Contexto]

GO
ALTER TABLE [Expediente].[ApremioLegajo]
	WITH CHECK
	ADD CONSTRAINT [FK_ApremioLegajo_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[ApremioLegajo]
	CHECK CONSTRAINT [FK_ApremioLegajo_Legajo]

GO
ALTER TABLE [Expediente].[ApremioLegajo]
	WITH CHECK
	ADD CONSTRAINT [FK_ApremioLegajo_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Expediente].[ApremioLegajo]
	CHECK CONSTRAINT [FK_ApremioLegajo_PuestoTrabajo]

GO
CREATE CLUSTERED INDEX [Expediente_ApremioLegajo_TF_Particion]
	ON [Expediente].[ApremioLegajo] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [Idx_TU_CodLegajo_TF_FechaIngresoOficina_TC_IDARCHIVO]
	ON [Expediente].[ApremioLegajo] ([TU_CodLegajo], [TF_FechaIngresoOficina], [TC_IDARCHIVO])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información del apremio asociado al legajo', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador correspondiente al escrito', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TU_CodApremio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador correspondiente al legajo', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo al cual se le asigna el apremio', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto donde se encuentra el apremio', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de la entrega con el apremio', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TC_CodEntrega'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del apremio', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que ingresa el apremio a la oficina', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TF_FechaIngresoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del archivo. Mismo identificador que tiene el archivo en la base de datos FileStream', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TC_IDARCHIVO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se envía el apremio', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TF_FechaEnvio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena el estado del apremio donde P = PendienteDistribuir, A = Aprobado, R = Rechazado, C = ConservarDerechos, T = Tramitandose', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TC_EstadoApremio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena origen de donde viene el apremio. Donde A = AppMovil, G = GELDJ, S = SIAGPJ', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TC_OrigenApremio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código o identificación del usuario que realiza la entrega', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TC_UsuarioEntrega'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del trámite para la orden de apremio', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TC_TramiteOrdenApremio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha del cambio de estado del apremio', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TF_FechaEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de partición de los registros', 'SCHEMA', N'Expediente', 'TABLE', N'ApremioLegajo', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Expediente].[ApremioLegajo] SET (LOCK_ESCALATION = TABLE)
GO

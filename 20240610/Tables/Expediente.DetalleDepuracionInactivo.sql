SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[DetalleDepuracionInactivo] (
		[TN_CodDetalleDepuracion]     [bigint] NOT NULL,
		[TN_CodSolicitud]             [bigint] NOT NULL,
		[TC_NumeroExpediente]         [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodLegajo]                [uniqueidentifier] NULL,
		[TB_TieneMandamientos]        [bit] NOT NULL,
		[TB_TieneDepositos]           [bit] NOT NULL,
		[TF_UltimoAcontecimiento]     [datetime2](3) NOT NULL,
		[TC_TipoAcontecimiento]       [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Estado]                   [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Resultado]                [varchar](200) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                [datetime2](7) NOT NULL,
		[TN_CodEstado]                [int] NOT NULL,
		[TC_DescripcionEstado]        [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_TieneEmbargos]            [bit] NOT NULL,
		CONSTRAINT [PK_DetalleDepuracionInactivo]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodDetalleDepuracion])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
	ADD
	CONSTRAINT [CK_EstadoDetalleDepuracionInactivo]
	CHECK
	([TC_Estado]='T' OR [TC_Estado]='P' OR [TC_Estado]='F' OR [TC_Estado]='E' OR [TC_Estado]='D' OR [TC_Estado]='M')
GO
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
CHECK CONSTRAINT [CK_EstadoDetalleDepuracionInactivo]
GO
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
	ADD
	CONSTRAINT [CK_TipoAcontecimientoDetalleDepuracionInactivo]
	CHECK
	([TC_TipoAcontecimiento]='A' OR [TC_TipoAcontecimiento]='P' OR [TC_TipoAcontecimiento]='E' OR [TC_TipoAcontecimiento]='D')
GO
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
CHECK CONSTRAINT [CK_TipoAcontecimientoDetalleDepuracionInactivo]
GO
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
	ADD
	CONSTRAINT [DF__DetalleDe__TN_Co__02FFA16F]
	DEFAULT (NEXT VALUE FOR [Expediente].[SecuenciaDetalleDepuracionInactivo]) FOR [TN_CodDetalleDepuracion]
GO
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
	ADD
	CONSTRAINT [DF__DetalleDe__TC_Es__04E7E9E1]
	DEFAULT ('P') FOR [TC_Estado]
GO
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
	ADD
	CONSTRAINT [DF__DetalleDe__TF_Pa__03F3C5A8]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
	WITH CHECK
	ADD CONSTRAINT [FK_DetalleDepuracionInactivo_Estado]
	FOREIGN KEY ([TN_CodEstado]) REFERENCES [Catalogo].[Estado] ([TN_CodEstado])
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
	CHECK CONSTRAINT [FK_DetalleDepuracionInactivo_Estado]

GO
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
	WITH CHECK
	ADD CONSTRAINT [FK_DetalleDepuracionInactivo_Expediente_TC_NumeroExpediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
	CHECK CONSTRAINT [FK_DetalleDepuracionInactivo_Expediente_TC_NumeroExpediente]

GO
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
	WITH CHECK
	ADD CONSTRAINT [FK_DetalleDepuracionInactivo_Legajo_TU_CodLegajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
	CHECK CONSTRAINT [FK_DetalleDepuracionInactivo_Legajo_TU_CodLegajo]

GO
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
	WITH CHECK
	ADD CONSTRAINT [FK_DetalleDepuracionInactivo_Solicitud_TN_CodSolicitud]
	FOREIGN KEY ([TN_CodSolicitud]) REFERENCES [Expediente].[SolicitudCargaInactivo] ([TN_CodSolicitud])
ALTER TABLE [Expediente].[DetalleDepuracionInactivo]
	CHECK CONSTRAINT [FK_DetalleDepuracionInactivo_Solicitud_TN_CodSolicitud]

GO
CREATE CLUSTERED INDEX [IX_Clustered_TF_ParticionDetalleDepuracion]
	ON [Expediente].[DetalleDepuracionInactivo] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_NonClusteredIndex_SolicitudCarga]
	ON [Expediente].[DetalleDepuracionInactivo] ([TN_CodSolicitud])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Descripcion', N' Estructura para guardar la información de los expedientes candidatos a ser inactivados.', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del detalle de la solicitud, Que Permite Identificar  una fila única de expediente.
Como valor por defecto usa secuencia [Expediente].[SecuenciaDetalleDepuracionInactivo]', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', 'COLUMN', N'TN_CodDetalleDepuracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene la referencia a la solicitud generada por el usuario, funciona como maestro.', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', 'COLUMN', N'TN_CodSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena información del número único de un expediente posible a inactivar.', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'En caso de que sea un legajo se guardará el código de legajo, en caso de ser el registro solo expediente se dejará null.', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'En caso de que el expediente tenga mandamientos se almacenará un true, caso contrario false.', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', 'COLUMN', N'TB_TieneMandamientos'
GO
EXEC sp_addextendedproperty N'MS_Description', N'En caso de que el expediente o legajo tenga montos pendientes en el SDJ se guardará true caso contrario false.', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', 'COLUMN', N'TB_TieneDepositos'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacenará la información del ultimo acontecimiento del expediente, la fecha mayor entre documentos ingresados, apremios y documentos ingresados.', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', 'COLUMN', N'TF_UltimoAcontecimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacenará la información del ultimo acontecimiento del expediente, puede ser Escritos=E, Documentos=D,Audiencia=A, Apremio=P.', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', 'COLUMN', N'TC_TipoAcontecimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de la solicitud de carga, puede ser Pendiente=P,Procesando=T,Procesada=F, ErrorSDJ = D, ErrorSREM = M, ErrorSDJSREM = E, valor predeterminado es P', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena información relacionado al resultado de la depuración, ejemplo Expediente validado correctamente, No se pudo validar si existen mandamientos para el expediente debido a un problema entre servicios.', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', 'COLUMN', N'TC_Resultado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena  fecha del registro para usar en función de partición.', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', 'COLUMN', N'TF_Particion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene el codigo del último estado del movimiento circulante asignado al expediente o legajo en el contexto.', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', 'COLUMN', N'TN_CodEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene la descripción del último estado del movimiento circulante asignado al expediente o legajo en el contexto.', 'SCHEMA', N'Expediente', 'TABLE', N'DetalleDepuracionInactivo', 'COLUMN', N'TC_DescripcionEstado'
GO
ALTER TABLE [Expediente].[DetalleDepuracionInactivo] SET (LOCK_ESCALATION = TABLE)
GO

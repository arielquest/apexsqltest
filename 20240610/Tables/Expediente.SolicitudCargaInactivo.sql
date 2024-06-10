SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[SolicitudCargaInactivo] (
		[TN_CodSolicitud]         [bigint] NOT NULL,
		[TB_ValidarSREM]          [bit] NOT NULL,
		[TB_ValidarDocumento]     [bit] NOT NULL,
		[TB_ValidarEscrito]       [bit] NOT NULL,
		[TF_Corte]                [datetime2](3) NOT NULL,
		[TC_CodContexto]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]           [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Solicitud]            [datetime2](7) NOT NULL,
		[TC_Estado]               [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_Solicitud_Carga]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodSolicitud])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Solicitud])
GO
ALTER TABLE [Expediente].[SolicitudCargaInactivo]
	ADD
	CONSTRAINT [CK_EstadoSolicitudCargaInactivo]
	CHECK
	([TC_Estado]='T' OR [TC_Estado]='P' OR [TC_Estado]='F' OR [TC_Estado]='E' OR [TC_Estado]='D' OR [TC_Estado]='M')
GO
ALTER TABLE [Expediente].[SolicitudCargaInactivo]
CHECK CONSTRAINT [CK_EstadoSolicitudCargaInactivo]
GO
ALTER TABLE [Expediente].[SolicitudCargaInactivo]
	ADD
	CONSTRAINT [DF__Solicitud__TN_Co__5C2F21BA]
	DEFAULT (NEXT VALUE FOR [Expediente].[SecuenciaSolictudCargaInactivos]) FOR [TN_CodSolicitud]
GO
ALTER TABLE [Expediente].[SolicitudCargaInactivo]
	ADD
	CONSTRAINT [DF__Solicitud__TF_So__5D2345F3]
	DEFAULT (sysdatetime()) FOR [TF_Solicitud]
GO
ALTER TABLE [Expediente].[SolicitudCargaInactivo]
	ADD
	CONSTRAINT [DF__Solicitud__TC_Es__5E176A2C]
	DEFAULT ('P') FOR [TC_Estado]
GO
ALTER TABLE [Expediente].[SolicitudCargaInactivo]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudCargaInactivo_CatalogoContexto_CodContexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[SolicitudCargaInactivo]
	CHECK CONSTRAINT [FK_SolicitudCargaInactivo_CatalogoContexto_CodContexto]

GO
ALTER TABLE [Expediente].[SolicitudCargaInactivo]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudCargaInactivo_Funcionario_UsuarioRed]
	FOREIGN KEY ([TC_UsuarioRed]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Expediente].[SolicitudCargaInactivo]
	CHECK CONSTRAINT [FK_SolicitudCargaInactivo_Funcionario_UsuarioRed]

GO
CREATE CLUSTERED INDEX [IXClusteredIndex-ParticionTFSolicitud_SolicitudCarga]
	ON [Expediente].[SolicitudCargaInactivo] ([TF_Solicitud])
	ON [ExpedientePS] ([TF_Solicitud])
GO
EXEC sp_addextendedproperty N'MS_Descripction', N'Indice de particionamiento', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudCargaInactivo', 'INDEX', N'IXClusteredIndex-ParticionTFSolicitud_SolicitudCarga'
GO
CREATE NONCLUSTERED INDEX [IX_NonClusteredContexto_usuario_SolicitudCarga]
	ON [Expediente].[SolicitudCargaInactivo] ([TC_CodContexto], [TC_UsuarioRed])
	ON [ExpedientePS] ([TF_Solicitud])
GO
EXEC sp_addextendedproperty N'MS_Descripcion', N'Estructura para guardar la informaci�n por usuario y contexto de solicitudes de carga de expedientes inactivos que realicen los usuarios.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudCargaInactivo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'C�digo De La Solicitud Que Permite Identificar C�mo �nica La Misma.
Usa Secuencia
Expediente. SecuenciaSolictudCargaInactivos
.
.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudCargaInactivo', 'COLUMN', N'TN_CodSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo Que Indica Si Se debe Validar Los Registros De Mandamientos Electr�nicos Para Los Expedientes.
.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudCargaInactivo', 'COLUMN', N'TB_ValidarSREM'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que indica si se debe validar los �ltimos documentos asociados al expediente en el periodo de tiempo seleccionado.
.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudCargaInactivo', 'COLUMN', N'TB_ValidarDocumento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de corte hasta la cual van a ser revisado los expedientes.
.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudCargaInactivo', 'COLUMN', N'TF_Corte'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contexto donde se realiza la carga.
.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudCargaInactivo', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que realiza la solicitud de carga de expedientes inactivos', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudCargaInactivo', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en la que se guarda la solicitud de carga de los expedientes. Este campo se usa  para particionamiento de la tabla, pertenece al grupo de expediente es �ndice cl�ster
.', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudCargaInactivo', 'COLUMN', N'TF_Solicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de la solicitud de carga, puede ser Pendiente=P,Procesando=T,Procesada=F,Error=E, valor predeterminado es P', 'SCHEMA', N'Expediente', 'TABLE', N'SolicitudCargaInactivo', 'COLUMN', N'TC_Estado'
GO
ALTER TABLE [Expediente].[SolicitudCargaInactivo] SET (LOCK_ESCALATION = TABLE)
GO

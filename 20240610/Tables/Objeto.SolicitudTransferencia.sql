SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Objeto].[SolicitudTransferencia] (
		[TU_CodSolicitudTransferencia]       [uniqueidentifier] NOT NULL,
		[TU_CodObjeto]                       [uniqueidentifier] NOT NULL,
		[TC_UsuarioRedRealizaSolicitud]      [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodOficina_Destino]              [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodOficina_Genera_Solicitud]     [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fecha]                           [datetime2](7) NOT NULL,
		[TC_Observaciones]                   [varchar](250) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Estado]                          [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Actualizacion]                   [datetime2](7) NOT NULL,
		[TC_UsuarioRedAutorizaSolicitud]     [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_ObservacionesAutorizacion]       [varchar](250) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaAutorizacion]               [datetime2](7) NULL,
		[TF_Particion]                       [datetime2](7) NOT NULL,
		CONSTRAINT [PK_SolicitudTransferencia]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitudTransferencia])
	ON [PRIMARY]
) ON [ObjetoPS] ([TF_Particion])
GO
ALTER TABLE [Objeto].[SolicitudTransferencia]
	ADD
	CONSTRAINT [CK_SolicitudTransferencia_Estado]
	CHECK
	([TC_Estado]='G' OR [TC_Estado]='P' OR [TC_Estado]='A' OR [TC_Estado]='R')
GO
ALTER TABLE [Objeto].[SolicitudTransferencia]
CHECK CONSTRAINT [CK_SolicitudTransferencia_Estado]
GO
ALTER TABLE [Objeto].[SolicitudTransferencia]
	ADD
	CONSTRAINT [DF__Solicitud__TC_Es__7F2F108B]
	DEFAULT ('G') FOR [TC_Estado]
GO
ALTER TABLE [Objeto].[SolicitudTransferencia]
	ADD
	CONSTRAINT [DF__Solicitud__TF_Ac__002334C4]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Objeto].[SolicitudTransferencia]
	ADD
	CONSTRAINT [DF__Solicitud__TF_Pa__5E6182EF]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Objeto].[SolicitudTransferencia]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudTransferencia_Objeto]
	FOREIGN KEY ([TU_CodObjeto]) REFERENCES [Objeto].[Objeto] ([TU_CodObjeto])
ALTER TABLE [Objeto].[SolicitudTransferencia]
	CHECK CONSTRAINT [FK_SolicitudTransferencia_Objeto]

GO
ALTER TABLE [Objeto].[SolicitudTransferencia]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudTransferencia_Oficina_Destino]
	FOREIGN KEY ([TC_CodOficina_Destino]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Objeto].[SolicitudTransferencia]
	CHECK CONSTRAINT [FK_SolicitudTransferencia_Oficina_Destino]

GO
ALTER TABLE [Objeto].[SolicitudTransferencia]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudTransferencia_Oficina_Genera_Solicitud]
	FOREIGN KEY ([TC_CodOficina_Genera_Solicitud]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Objeto].[SolicitudTransferencia]
	CHECK CONSTRAINT [FK_SolicitudTransferencia_Oficina_Genera_Solicitud]

GO
CREATE CLUSTERED INDEX [IX_Objeto_SolicitudTransferencia_TF_Particion]
	ON [Objeto].[SolicitudTransferencia] ([TF_Particion])
	ON [ObjetoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único de la solicitud de Transferencia', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTransferencia', 'COLUMN', N'TU_CodSolicitudTransferencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el código del objeto que hace referencia a la tabla de SolicitudTransferencia', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTransferencia', 'COLUMN', N'TU_CodObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el usuario de red de la persona que realiza la solicitud', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTransferencia', 'COLUMN', N'TC_UsuarioRedRealizaSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el id de la oficina a la que será transferido el objeto', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTransferencia', 'COLUMN', N'TC_CodOficina_Destino'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el id de la oficina que genera la solicitud de Transferencia', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTransferencia', 'COLUMN', N'TC_CodOficina_Genera_Solicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora en que se realiza el registro de Transferencia', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTransferencia', 'COLUMN', N'TF_Fecha'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener las observaciones relacionadas a la solicitud de Transferencia', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTransferencia', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el estado en que se encuentra la solicitud (Guardado=[G], Pendiente=[P], Autorizada=[A], Rechazada=[R])', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTransferencia', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora de registro o última actualización realizada al registro de la solicitud', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTransferencia', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo no obligatorio que va a contener el nombre de usuario del funcionario que autoriza o no la solicitud de transferencia del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTransferencia', 'COLUMN', N'TC_UsuarioRedAutorizaSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo no obligatorio que va a contener las observaciones  del funcionario que autoriza o no la solicitud de transferencia del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTransferencia', 'COLUMN', N'TC_ObservacionesAutorizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo no obligatorio que va a contener la fecha en que se realiza la autorización o no de la solicitud de transferencia del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTransferencia', 'COLUMN', N'TF_FechaAutorizacion'
GO
ALTER TABLE [Objeto].[SolicitudTransferencia] SET (LOCK_ESCALATION = TABLE)
GO

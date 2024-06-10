SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Objeto].[SolicitudTraslado] (
		[TU_CodSolicitudTraslado]              [uniqueidentifier] NOT NULL,
		[TU_CodObjeto]                         [uniqueidentifier] NOT NULL,
		[TC_UsuarioRedRealizaSolicitud]        [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodOficina_Destino]                [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodOficina_Genera_Solicitud]       [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NombreCompletoRealizaTraslado]     [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fecha]                             [datetime2](7) NOT NULL,
		[TC_Observaciones]                     [varchar](250) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Estado]                            [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Actualizacion]                     [datetime2](7) NOT NULL,
		[TC_UsuarioRedAutorizaSolicitud]       [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_ObservacionesAutorizacion]         [varchar](250) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaAutorizacion]                 [datetime2](7) NULL,
		[TF_Particion]                         [datetime2](7) NOT NULL,
		CONSTRAINT [PK_SolicitudTraslado]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodSolicitudTraslado])
	ON [PRIMARY]
) ON [ObjetoPS] ([TF_Particion])
GO
ALTER TABLE [Objeto].[SolicitudTraslado]
	ADD
	CONSTRAINT [CK_SolicitudTraslado_Estado]
	CHECK
	([TC_Estado]='P' OR [TC_Estado]='A' OR [TC_Estado]='R')
GO
ALTER TABLE [Objeto].[SolicitudTraslado]
CHECK CONSTRAINT [CK_SolicitudTraslado_Estado]
GO
ALTER TABLE [Objeto].[SolicitudTraslado]
	ADD
	CONSTRAINT [DF__Solicitud__TC_Es__57211F31]
	DEFAULT ('P') FOR [TC_Estado]
GO
ALTER TABLE [Objeto].[SolicitudTraslado]
	ADD
	CONSTRAINT [DF__Solicitud__TF_Ac__5815436A]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Objeto].[SolicitudTraslado]
	ADD
	CONSTRAINT [DF__Solicitud__TF_Pa__641A5C45]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Objeto].[SolicitudTraslado]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudTraslado_Objeto]
	FOREIGN KEY ([TU_CodObjeto]) REFERENCES [Objeto].[Objeto] ([TU_CodObjeto])
ALTER TABLE [Objeto].[SolicitudTraslado]
	CHECK CONSTRAINT [FK_SolicitudTraslado_Objeto]

GO
ALTER TABLE [Objeto].[SolicitudTraslado]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudTraslado_Oficina_Destino]
	FOREIGN KEY ([TC_CodOficina_Destino]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Objeto].[SolicitudTraslado]
	CHECK CONSTRAINT [FK_SolicitudTraslado_Oficina_Destino]

GO
ALTER TABLE [Objeto].[SolicitudTraslado]
	WITH CHECK
	ADD CONSTRAINT [FK_SolicitudTraslado_Oficina_Genera_Solicitud]
	FOREIGN KEY ([TC_CodOficina_Genera_Solicitud]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Objeto].[SolicitudTraslado]
	CHECK CONSTRAINT [FK_SolicitudTraslado_Oficina_Genera_Solicitud]

GO
CREATE CLUSTERED INDEX [IX_Objeto_SolicitudTraslado_TF_Particion]
	ON [Objeto].[SolicitudTraslado] ([TF_Particion])
	ON [ObjetoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único de la solicitud de traslado', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTraslado', 'COLUMN', N'TU_CodSolicitudTraslado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el código del objeto que hace referencia a la tabla de SolicitudTraslado', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTraslado', 'COLUMN', N'TU_CodObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el usuario de red de la persona que realiza la solicitud', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTraslado', 'COLUMN', N'TC_UsuarioRedRealizaSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el id de la oficina a la que será trasladado el objeto', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTraslado', 'COLUMN', N'TC_CodOficina_Destino'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el id de la oficina que genera la solicitud de traslado', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTraslado', 'COLUMN', N'TC_CodOficina_Genera_Solicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre completo de la persona que realiza el traslado', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTraslado', 'COLUMN', N'TC_NombreCompletoRealizaTraslado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora en que se realiza el registro de traslado', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTraslado', 'COLUMN', N'TF_Fecha'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener las observaciones relacionadas a la solicitud de traslado', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTraslado', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el estado en que se encuentra la solicitud (Pendiente=[P], Autorizada=[A], Rechazada=[R])', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTraslado', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora de registro o última actualización realizada al registro de la solicitud', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTraslado', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo no obligatorio que va a contener el nombre de usuario del funcionario que autoriza o no la solicitud de traslado del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTraslado', 'COLUMN', N'TC_UsuarioRedAutorizaSolicitud'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo no obligatorio que va a contener las observaciones  del funcionario que autoriza o no la solicitud de traslado del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTraslado', 'COLUMN', N'TC_ObservacionesAutorizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo no obligatorio que va a contener la fecha en que se realiza la autorización o no de la solicitud de traslado del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'SolicitudTraslado', 'COLUMN', N'TF_FechaAutorizacion'
GO
ALTER TABLE [Objeto].[SolicitudTraslado] SET (LOCK_ESCALATION = TABLE)
GO

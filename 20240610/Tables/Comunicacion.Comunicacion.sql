SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Comunicacion].[Comunicacion] (
		[TU_CodComunicacion]                   [uniqueidentifier] NOT NULL,
		[TC_ConsecutivoComunicacion]           [varchar](35) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroExpediente]                  [char](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodPuestoTrabajo]                  [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodContexto]                       [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContextoOCJ]                    [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodInterviniente]                  [uniqueidentifier] NULL,
		[TC_CodMedio]                          [smallint] NOT NULL,
		[TC_Valor]                             [varchar](350) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodProvincia]                      [smallint] NULL,
		[TN_CodCanton]                         [smallint] NULL,
		[TN_CodDistrito]                       [smallint] NULL,
		[TN_CodBarrio]                         [smallint] NULL,
		[TN_CodSector]                         [smallint] NULL,
		[TG_UbicacionPunto]                    [geography] NULL,
		[TC_Rotulado]                          [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_TienePrioridad]                    [bit] NOT NULL,
		[TN_PrioridadMedio]                    [tinyint] NOT NULL,
		[TC_Estado]                            [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaResolucion]                   [datetime2](7) NULL,
		[TN_CodHorarioMedio]                   [smallint] NULL,
		[TB_RequiereCopias]                    [bit] NOT NULL,
		[TC_Observaciones]                     [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Resultado]                         [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodMotivoResultado]                [smallint] NULL,
		[TF_Actualizacion]                     [datetime2](7) NOT NULL,
		[TB_Revisado]                          [bit] NULL,
		[TF_FechaDevolucion]                   [datetime2](7) NULL,
		[TU_CodPuestoFuncionarioRegistro]      [uniqueidentifier] NULL,
		[TF_FechaRegistro]                     [datetime2](7) NOT NULL,
		[TF_FechaEnvio]                        [datetime2](7) NULL,
		[TU_CodPuestoFuncionarioEnvio]         [uniqueidentifier] NULL,
		[TF_FechaResultado]                    [datetime2](7) NULL,
		[TU_CodPuestoFuncionarioResultado]     [uniqueidentifier] NULL,
		[TB_Cancelar]                          [bit] NOT NULL,
		[TU_CodPuestoFuncionarioCancelar]      [uniqueidentifier] NULL,
		[TF_FechaCancelar]                     [datetime2](7) NULL,
		[TC_TipoComunicacion]                  [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]                         [datetime2](7) NOT NULL,
		[IDACO]                                [int] NULL,
		[TB_ComunicacionAppMovil]              [bit] NOT NULL,
		[TB_ExcluidaAppMovil]                  [bit] NOT NULL,
		[IDUSU_REGISTRO]                       [varchar](25) COLLATE Modern_Spanish_CI_AS NULL,
		[IDUSU_ENVIO]                          [varchar](25) COLLATE Modern_Spanish_CI_AS NULL,
		[TU_CodLegajo]                         [uniqueidentifier] NULL,
		[TN_IdNotiEntidadJuridica]             [bigint] NULL,
		[TN_IdActaEntidadJuridica]             [bigint] NULL,
		[TC_MensajeError]                      [varchar](max) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_MensajeUsuario]                    [varchar](max) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Comunicacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodComunicacion])
	ON [PRIMARY]
) ON [ComunicacionPS] ([TF_Particion])
GO
ALTER TABLE [Comunicacion].[Comunicacion]
	ADD
	CONSTRAINT [CK_Comunicacion_Estado]
	CHECK
	([TC_Estado]='K' OR [TC_Estado]='J' OR [TC_Estado]='I' OR [TC_Estado]='H' OR [TC_Estado]='G' OR [TC_Estado]='F' OR [TC_Estado]='E' OR [TC_Estado]='D' OR [TC_Estado]='C' OR [TC_Estado]='B' OR [TC_Estado]='A' OR [TC_Estado]='L' OR [TC_Estado]='R')
GO
ALTER TABLE [Comunicacion].[Comunicacion]
CHECK CONSTRAINT [CK_Comunicacion_Estado]
GO
ALTER TABLE [Comunicacion].[Comunicacion]
	ADD
	CONSTRAINT [CK_Comunicacion_Resultado]
	CHECK
	([TC_Resultado]='E' OR [TC_Resultado]='N' OR [TC_Resultado]='P')
GO
ALTER TABLE [Comunicacion].[Comunicacion]
CHECK CONSTRAINT [CK_Comunicacion_Resultado]
GO
ALTER TABLE [Comunicacion].[Comunicacion]
	ADD
	CONSTRAINT [CK_Comunicacion_TipoComunicacion]
	CHECK
	([TC_TipoComunicacion]='C' OR [TC_TipoComunicacion]='N' OR [TC_TipoComunicacion]='I')
GO
ALTER TABLE [Comunicacion].[Comunicacion]
CHECK CONSTRAINT [CK_Comunicacion_TipoComunicacion]
GO
ALTER TABLE [Comunicacion].[Comunicacion]
	ADD
	CONSTRAINT [CK_ComunicacionMedioComunicacion_Prioridad]
	CHECK
	([TN_PrioridadMedio]=(1) OR [TN_PrioridadMedio]=(2))
GO
ALTER TABLE [Comunicacion].[Comunicacion]
CHECK CONSTRAINT [CK_ComunicacionMedioComunicacion_Prioridad]
GO
ALTER TABLE [Comunicacion].[Comunicacion]
	ADD
	CONSTRAINT [DF_Comunicacion_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Comunicacion].[Comunicacion]
	ADD
	CONSTRAINT [DF__Comunicac__TB_Ca__7737525A]
	DEFAULT ((0)) FOR [TB_Cancelar]
GO
ALTER TABLE [Comunicacion].[Comunicacion]
	ADD
	CONSTRAINT [DF__Comunicac__TF_Pa__52EFD043]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Comunicacion].[Comunicacion]
	ADD
	CONSTRAINT [DF__Comunicac__TB_Co__15D27EC1]
	DEFAULT ((0)) FOR [TB_ComunicacionAppMovil]
GO
ALTER TABLE [Comunicacion].[Comunicacion]
	ADD
	CONSTRAINT [DF__Comunicac__TB_Ex__16C6A2FA]
	DEFAULT ((0)) FOR [TB_ExcluidaAppMovil]
GO
ALTER TABLE [Comunicacion].[Comunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Comunicacion].[Comunicacion]
	CHECK CONSTRAINT [FK_Comunicacion_Contexto]

GO
ALTER TABLE [Comunicacion].[Comunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_ContextoOCJ]
	FOREIGN KEY ([TC_CodContextoOCJ]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Comunicacion].[Comunicacion]
	CHECK CONSTRAINT [FK_Comunicacion_ContextoOCJ]

GO
ALTER TABLE [Comunicacion].[Comunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_HorarioMedioComunicacion]
	FOREIGN KEY ([TN_CodHorarioMedio]) REFERENCES [Catalogo].[HorarioMedioComunicacion] ([TN_CodHorario])
ALTER TABLE [Comunicacion].[Comunicacion]
	CHECK CONSTRAINT [FK_Comunicacion_HorarioMedioComunicacion]

GO
ALTER TABLE [Comunicacion].[Comunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Comunicacion].[Comunicacion]
	CHECK CONSTRAINT [FK_Comunicacion_Legajo]

GO
ALTER TABLE [Comunicacion].[Comunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_MotivoResultadoComunicacionJudicial]
	FOREIGN KEY ([TN_CodMotivoResultado]) REFERENCES [Catalogo].[MotivoResultadoComunicacionJudicial] ([TN_CodMotivoResultado])
ALTER TABLE [Comunicacion].[Comunicacion]
	CHECK CONSTRAINT [FK_Comunicacion_MotivoResultadoComunicacionJudicial]

GO
ALTER TABLE [Comunicacion].[Comunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_NumeroExpediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Comunicacion].[Comunicacion]
	CHECK CONSTRAINT [FK_Comunicacion_NumeroExpediente]

GO
ALTER TABLE [Comunicacion].[Comunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Comunicacion].[Comunicacion]
	CHECK CONSTRAINT [FK_Comunicacion_PuestoTrabajo]

GO
ALTER TABLE [Comunicacion].[Comunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_PuestoTrabajoFuncionarioCancelar]
	FOREIGN KEY ([TU_CodPuestoFuncionarioCancelar]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Comunicacion].[Comunicacion]
	CHECK CONSTRAINT [FK_Comunicacion_PuestoTrabajoFuncionarioCancelar]

GO
ALTER TABLE [Comunicacion].[Comunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_PuestoTrabajoFuncionarioEnvio]
	FOREIGN KEY ([TU_CodPuestoFuncionarioEnvio]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Comunicacion].[Comunicacion]
	CHECK CONSTRAINT [FK_Comunicacion_PuestoTrabajoFuncionarioEnvio]

GO
ALTER TABLE [Comunicacion].[Comunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_PuestoTrabajoFuncionarioRegistro]
	FOREIGN KEY ([TU_CodPuestoFuncionarioRegistro]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Comunicacion].[Comunicacion]
	CHECK CONSTRAINT [FK_Comunicacion_PuestoTrabajoFuncionarioRegistro]

GO
ALTER TABLE [Comunicacion].[Comunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_PuestoTrabajoFuncionarioResultado]
	FOREIGN KEY ([TU_CodPuestoFuncionarioResultado]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Comunicacion].[Comunicacion]
	CHECK CONSTRAINT [FK_Comunicacion_PuestoTrabajoFuncionarioResultado]

GO
ALTER TABLE [Comunicacion].[Comunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_Sector]
	FOREIGN KEY ([TN_CodSector]) REFERENCES [Comunicacion].[Sector] ([TN_CodSector])
ALTER TABLE [Comunicacion].[Comunicacion]
	CHECK CONSTRAINT [FK_Comunicacion_Sector]

GO
ALTER TABLE [Comunicacion].[Comunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Comunicacion_TipoMedioComunicacion]
	FOREIGN KEY ([TC_CodMedio]) REFERENCES [Catalogo].[TipoMedioComunicacion] ([TN_CodMedio])
ALTER TABLE [Comunicacion].[Comunicacion]
	CHECK CONSTRAINT [FK_Comunicacion_TipoMedioComunicacion]

GO
CREATE CLUSTERED INDEX [IX_Comunicacion_Comunicacion_TF_Particion]
	ON [Comunicacion].[Comunicacion] ([TF_Particion])
	ON [ComunicacionPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IDX_Comunicacion_Comunicacion_TC_Estado_INCLUDE]
	ON [Comunicacion].[Comunicacion] ([TC_Estado])
	INCLUDE ([TU_CodComunicacion], [TC_NumeroExpediente], [TC_CodPuestoTrabajo], [TC_CodContexto], [TC_CodContextoOCJ], [TU_CodInterviniente], [TC_CodMedio], [TN_CodSector], [TN_CodHorarioMedio], [TB_RequiereCopias], [TC_Resultado], [TF_FechaEnvio], [TC_TipoComunicacion], [TB_ComunicacionAppMovil])
	WITH ( FILLFACTOR = 100)
	ON [ComunicacionPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Comunicacion_Comunicacion_Migracion]
	ON [Comunicacion].[Comunicacion] ([TC_NumeroExpediente], [TC_CodContexto], [TC_CodMedio], [TC_Valor], [TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio], [TN_PrioridadMedio], [TF_FechaRegistro])
	ON [ComunicacionPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Comunicacion_ConsultarBuzonOficina]
	ON [Comunicacion].[Comunicacion] ([TC_CodContexto], [TC_Estado] DESC, [TF_FechaEnvio])
	INCLUDE ([TU_CodComunicacion], [TC_NumeroExpediente], [TC_CodContextoOCJ], [TC_CodMedio], [TC_Resultado], [TC_TipoComunicacion])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indice para optimizar Comunicacion.PA_ConsultarBuzonOficina.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'INDEX', N'IX_Comunicacion_ConsultarBuzonOficina'
GO
CREATE NONCLUSTERED INDEX [IX_Comunicacion_ConsultarDomiciliosEntregasExitosa]
	ON [Comunicacion].[Comunicacion] ([TU_CodInterviniente], [TC_CodMedio], [TC_Estado], [TC_Resultado])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Ýndice creado para optimizar Comunicacion.PA_ConsultarDomiciliosEntregasExitosa.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'INDEX', N'IX_Comunicacion_ConsultarDomiciliosEntregasExitosa'
GO
CREATE NONCLUSTERED INDEX [IX_Comunicacion_TF_FechaRegistro]
	ON [Comunicacion].[Comunicacion] ([TF_FechaRegistro])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena las comunicaciones judiciales que deben ser enviadas a los intervinientes de los expedientes en que son parte', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador único del registro de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TU_CodComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Consecutivo de la comunicación que se genera en la oficina origen. Contiene por tipo comunicación, año, materia y oficina', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_ConsecutivoComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo del oficial de comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_CodContextoOCJ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del interviniente a quien va dirigida la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del medio de comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_CodMedio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena diferentes datos, puede ser la dirección del domicilio, teléfono, fax, email, etc.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_Valor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la provincia', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cantón', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TN_CodCanton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del distrito', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TN_CodDistrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del barrio', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TN_CodBarrio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del sector al cual pertenece la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TN_CodSector'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Punto de geolocalización especifico indicado por el destinatario', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TG_UbicacionPunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rotulado que se debe mostrar al enviar fax o email', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_Rotulado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la comunicación tiene prioridad. Si = 1, No = 0', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TB_TienePrioridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prioridad del medio de comunicación. 1 = Primario, 2 = Accesorio', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TN_PrioridadMedio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el estado de la comunicación judicial, WITH CHECK ADD CONSTRAINT para que solo acepte los siguientes valores, para   Registrada = ''A'', ParaTramitar = ''B'', Revisando = ''C'', EspereandoCopias = ''D'', ParaComunicar = ''E'', Comunicandose = ''F'', ParaEntregar = ''G'', ParaCorregir = ''H'', Entregandose = ''I'', Entregada = ''J'', Comisionada = ''K''', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación de la resolución o documento a comunicar', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TF_FechaResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador parael horario del medio de comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TN_CodHorarioMedio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si se requiere aportar copias para tramitar la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TB_RequiereCopias'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el resultado de la comunicación judicial, WITH CHECK ADD CONSTRAINT para que solo acepte los siguientes valores  Positivo = ''P'', Negativo = ''N'', Error = ''E''', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_Resultado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador del motivo del resultado', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TN_CodMotivoResultado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización de la comunicación. SIGMA', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Columna para llevar el control de cuando una comunicación ya ha sido revisada por la oficina de OCJ', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TB_Revisado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en la cual se realiza la devolución de la comunicación a la oficina de origen', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TF_FechaDevolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del funcionario asociado a un puesto que realizó el registro de la comunicación. Se deja en null cuando se tratan de comunicaciones recibidas por itineración de Gestión, caso contrario SIAGPJ si llena este dato.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TU_CodPuestoFuncionarioRegistro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se realizó el registro de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TF_FechaRegistro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se realizó el envío de la comunicación a la OCJ', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TF_FechaEnvio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del funcionario asociado a un puesto que realizó el envío de la comunicación a la OCJ', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TU_CodPuestoFuncionarioEnvio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se registró el resultado de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TF_FechaResultado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del funcionario asociado a un puesto que registró el resultado de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TU_CodPuestoFuncionarioResultado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica que el despacho ha solicitado cancelar la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TB_Cancelar'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del funcionario asociado a un puesto que solicitó cancelar la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TU_CodPuestoFuncionarioCancelar'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se solicitó cancelar la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TF_FechaCancelar'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el tipo de comunicación judicial, solo acepta los siguientes valores: C=Comunicación,N=Notificación,I=Citación.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_TipoComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bandera que indica si la comunicación se encuentra en la aplicación móvil.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TB_ComunicacionAppMovil'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bandera que indica si la comunicación fue excluida de la aplicación móvil.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TB_ExcluidaAppMovil'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario de red que realizó el registro de la comunicación en el sistema de Gestión, se almacena cuando se reciben itineraciones, para no perder este dato.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'IDUSU_REGISTRO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario de red que realizó el envío de la comunicación en el sistema de Gestión, se almacena cuando se reciben itineraciones, para no perder este dato.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'IDUSU_ENVIO'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador que retorna el servicio expuesto por la entidad jurídica luego de recibir la notificación. Este campo aplica solo para las comunicaciones con tipo de medio de comunicación igual a Notificación electrónica entidad jurídica.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TN_IdNotiEntidadJuridica'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador que retorna el servicio expuesto por la entidad jurídica luego de recibir el acta de la notificación. Este campo aplica solo para las comunicaciones con tipo de medio de comunicación igual a Notificación electrónica entidad jurídica.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TN_IdActaEntidadJuridica'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Especifica el detalle del error que tuvo la notificación sólo en caso que haya existido algún error al enviarla.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_MensajeError'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Muestra al usuario una descripción general del error al procesar una notificación, si existió alguno.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Comunicacion', 'COLUMN', N'TC_MensajeUsuario'
GO
ALTER TABLE [Comunicacion].[Comunicacion] SET (LOCK_ESCALATION = TABLE)
GO

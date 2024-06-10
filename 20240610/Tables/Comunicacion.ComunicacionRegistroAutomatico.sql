SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Comunicacion].[ComunicacionRegistroAutomatico] (
		[TU_CodComunicacionAut]               [uniqueidentifier] NOT NULL,
		[TU_CodAsignacionFirmado]             [uniqueidentifier] NOT NULL,
		[TC_CodContextoOCJ]                   [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodMedio]                         [smallint] NOT NULL,
		[TC_Valor]                            [varchar](350) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodProvincia]                     [smallint] NULL,
		[TN_CodCanton]                        [smallint] NULL,
		[TN_CodDistrito]                      [smallint] NULL,
		[TN_CodBarrio]                        [smallint] NULL,
		[TN_CodSector]                        [smallint] NULL,
		[TC_Rotulado]                         [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_TienePrioridad]                   [bit] NOT NULL,
		[TN_PrioridadMedio]                   [tinyint] NOT NULL,
		[TF_FechaResolucion]                  [datetime2](7) NULL,
		[TN_CodHorarioMedio]                  [smallint] NULL,
		[TB_RequiereCopias]                   [bit] NOT NULL,
		[TC_Observaciones]                    [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TU_CodPuestoFuncionarioRegistro]     [uniqueidentifier] NULL,
		[TF_FechaPreRegistro]                 [datetime2](7) NOT NULL,
		[TC_TipoComunicacion]                 [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_EstadoEnvio]                      [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]                        [datetime2](7) NOT NULL,
		[TU_CodInterviniente]                 [uniqueidentifier] NOT NULL,
		[TN_Intento]                          [int] NOT NULL,
		CONSTRAINT [PK_ComunicacionRegistroAutomatico]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodComunicacionAut])
	ON [PRIMARY]
) ON [FG_Comunicacion]
GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	ADD
	CONSTRAINT [CK_ComunicacionRegistroAutomatico_Estado]
	CHECK
	([TC_EstadoEnvio]='P' OR [TC_EstadoEnvio]='E' OR [TC_EstadoEnvio]='X' OR [TC_EstadoEnvio]='R')
GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
CHECK CONSTRAINT [CK_ComunicacionRegistroAutomatico_Estado]
GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	ADD
	CONSTRAINT [CK_ComunicacionRegistroAutomatico_TipoComunicacion]
	CHECK
	([TC_TipoComunicacion]='C' OR [TC_TipoComunicacion]='N' OR [TC_TipoComunicacion]='I')
GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
CHECK CONSTRAINT [CK_ComunicacionRegistroAutomatico_TipoComunicacion]
GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	ADD
	CONSTRAINT [CK_ComunicacionRegistroAutomaticoMedioComunicacion_Prioridad]
	CHECK
	([TN_PrioridadMedio]=(1) OR [TN_PrioridadMedio]=(2))
GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
CHECK CONSTRAINT [CK_ComunicacionRegistroAutomaticoMedioComunicacion_Prioridad]
GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	ADD
	CONSTRAINT [DF_ComunicacionRegistroAutomatico_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	ADD
	CONSTRAINT [DF_ComunicacionRegistroAutomatico_TN_Intento]
	DEFAULT ((0)) FOR [TN_Intento]
GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	WITH CHECK
	ADD CONSTRAINT [FK_ComunicacionRegistroAutomatico_AsignacionFirmado]
	FOREIGN KEY ([TU_CodAsignacionFirmado]) REFERENCES [Archivo].[AsignacionFirmado] ([TU_CodAsignacionFirmado])
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	CHECK CONSTRAINT [FK_ComunicacionRegistroAutomatico_AsignacionFirmado]

GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	WITH CHECK
	ADD CONSTRAINT [FK_ComunicacionRegistroAutomatico_ContextoOCJ]
	FOREIGN KEY ([TC_CodContextoOCJ]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	CHECK CONSTRAINT [FK_ComunicacionRegistroAutomatico_ContextoOCJ]

GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	WITH CHECK
	ADD CONSTRAINT [FK_ComunicacionRegistroAutomatico_HorarioMedioComunicacion]
	FOREIGN KEY ([TN_CodHorarioMedio]) REFERENCES [Catalogo].[HorarioMedioComunicacion] ([TN_CodHorario])
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	CHECK CONSTRAINT [FK_ComunicacionRegistroAutomatico_HorarioMedioComunicacion]

GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	WITH CHECK
	ADD CONSTRAINT [FK_ComunicacionRegistroAutomatico_Interviniente]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	CHECK CONSTRAINT [FK_ComunicacionRegistroAutomatico_Interviniente]

GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	WITH CHECK
	ADD CONSTRAINT [FK_ComunicacionRegistroAutomatico_PuestoTrabajoFuncionarioRegistro]
	FOREIGN KEY ([TU_CodPuestoFuncionarioRegistro]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	CHECK CONSTRAINT [FK_ComunicacionRegistroAutomatico_PuestoTrabajoFuncionarioRegistro]

GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	WITH CHECK
	ADD CONSTRAINT [FK_ComunicacionRegistroAutomatico_Sector]
	FOREIGN KEY ([TN_CodSector]) REFERENCES [Comunicacion].[Sector] ([TN_CodSector])
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	CHECK CONSTRAINT [FK_ComunicacionRegistroAutomatico_Sector]

GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	WITH CHECK
	ADD CONSTRAINT [FK_ComunicacionRegistroAutomatico_TipoMedioComunicacion]
	FOREIGN KEY ([TC_CodMedio]) REFERENCES [Catalogo].[TipoMedioComunicacion] ([TN_CodMedio])
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico]
	CHECK CONSTRAINT [FK_ComunicacionRegistroAutomatico_TipoMedioComunicacion]

GO
CREATE CLUSTERED INDEX [IX_Comunicacion_ComunicacionRegistroAutomatico_TF_Particion]
	ON [Comunicacion].[ComunicacionRegistroAutomatico] ([TF_Particion])
	ON [FG_Comunicacion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena el preregistro las comunicaciones judiciales que deben ser enviadas a los intervinientes de los expedientes en que son parte', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador único del preregistro de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TU_CodComunicacionAut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la asignación de firmado asociada al preregistro de comunicación.', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TU_CodAsignacionFirmado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto.', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TC_CodContextoOCJ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del medio de comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TC_CodMedio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena diferentes datos, puede ser la dirección del domicilio, teléfono, fax, email, etc.', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TC_Valor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la provincia', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cantón', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TN_CodCanton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del distrito', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TN_CodDistrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del barrio', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TN_CodBarrio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del sector al cual pertenece la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TN_CodSector'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Rotulado que se debe mostrar al enviar fax o email', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TC_Rotulado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la comunicación tiene prioridad. Si = 1, No = 0', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TB_TienePrioridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prioridad del medio de comunicación. 1 = Primario, 2 = Accesorio', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TN_PrioridadMedio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación de la resolución o documento a comunicar', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TF_FechaResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador parael horario del medio de comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TN_CodHorarioMedio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si se requiere aportar copias para tramitar la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TB_RequiereCopias'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del funcionario asociado a un puesto que realizó el pre registro de la comunicación. Se deja en null cuando se tratan de comunicaciones recibidas por itineración de Gestión, caso contrario SIAGPJ si llena este dato.', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TU_CodPuestoFuncionarioRegistro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se realizó el preregistro de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TF_FechaPreRegistro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el tipo de comunicación judicial, solo acepta los siguientes valores: C=Comunicación,N=Notificación,I=Citación.', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TC_TipoComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el estado del preregistro, solo acepta los siguientes valores, para   Pendiente = ''P'', En Proceso = ''E'', Enviado = ''X'', ErrorEnviar = ''R''', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TC_EstadoEnvio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del interviniente asociado al preregistro de la comunicación automática', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Se utiliza para llevar la cuenta de número de intentos de envío de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'ComunicacionRegistroAutomatico', 'COLUMN', N'TN_Intento'
GO
ALTER TABLE [Comunicacion].[ComunicacionRegistroAutomatico] SET (LOCK_ESCALATION = TABLE)
GO

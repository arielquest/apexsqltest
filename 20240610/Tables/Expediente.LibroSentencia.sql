SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[LibroSentencia] (
		[TU_CodLibroSentencia]      [uniqueidentifier] NOT NULL,
		[TC_AnnoSentencia]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]            [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodPuestoTrabajo]       [varchar](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_NumeroResolucion]       [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaAsignacion]        [datetime2](7) NOT NULL,
		[TC_Estado]                 [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodResolucion]          [uniqueidentifier] NULL,
		[TU_UsuarioCrea]            [uniqueidentifier] NULL,
		[TU_UsuarioConfirma]        [uniqueidentifier] NULL,
		[TC_JustificacionNoUso]     [varchar](150) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]          [datetime2](7) NOT NULL,
		[TF_Particion]              [datetime2](7) NOT NULL,
		[JUEZ]                      [varchar](11) COLLATE Modern_Spanish_CI_AS NULL,
		[USUREDAC]                  [varchar](25) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_LibroSentencia]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodLibroSentencia])
	ON [PRIMARY]
) ON [ExpedientePS] ([TF_Particion])
GO
ALTER TABLE [Expediente].[LibroSentencia]
	ADD
	CONSTRAINT [CK_LibroSentencia]
	CHECK
	([TC_Estado]='P' OR [TC_Estado]='I' OR [TC_Estado]='A' OR [TC_Estado]='C')
GO
EXEC sp_addextendedproperty N'MS_Description', N'Verifica que los valores del estado sean unicamente los indicados para estos', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'CONSTRAINT', N'CK_LibroSentencia'
GO
ALTER TABLE [Expediente].[LibroSentencia]
CHECK CONSTRAINT [CK_LibroSentencia]
GO
ALTER TABLE [Expediente].[LibroSentencia]
	ADD
	CONSTRAINT [DF_LibroSentencia_TC_Estado]
	DEFAULT ('R') FOR [TC_Estado]
GO
ALTER TABLE [Expediente].[LibroSentencia]
	ADD
	CONSTRAINT [DF__LibroSent__TF_Ac__57E7F8DC]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Expediente].[LibroSentencia]
	ADD
	CONSTRAINT [DF__LibroSent__TF_Pa__3EE8D796]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Expediente].[LibroSentencia]
	WITH CHECK
	ADD CONSTRAINT [FK_LibroSentencia_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[LibroSentencia]
	CHECK CONSTRAINT [FK_LibroSentencia_Contexto]

GO
ALTER TABLE [Expediente].[LibroSentencia]
	WITH CHECK
	ADD CONSTRAINT [FK_LibroSentencia_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Expediente].[LibroSentencia]
	CHECK CONSTRAINT [FK_LibroSentencia_PuestoTrabajo]

GO
ALTER TABLE [Expediente].[LibroSentencia]
	WITH CHECK
	ADD CONSTRAINT [FK_LibroSentencia_UsuarioConfirma]
	FOREIGN KEY ([TU_UsuarioConfirma]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Expediente].[LibroSentencia]
	CHECK CONSTRAINT [FK_LibroSentencia_UsuarioConfirma]

GO
ALTER TABLE [Expediente].[LibroSentencia]
	WITH CHECK
	ADD CONSTRAINT [FK_LibroSentencia_UsuarioCrea]
	FOREIGN KEY ([TU_UsuarioCrea]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Expediente].[LibroSentencia]
	CHECK CONSTRAINT [FK_LibroSentencia_UsuarioCrea]

GO
CREATE CLUSTERED INDEX [IX_Expediente_LibroSentencia_TF_Particion]
	ON [Expediente].[LibroSentencia] ([TF_Particion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Expediente_LibroSentencia_Migracion]
	ON [Expediente].[LibroSentencia] ([TC_AnnoSentencia], [TC_CodContexto], [TC_NumeroResolucion], [TF_FechaAsignacion], [TU_CodResolucion])
	ON [ExpedientePS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_LibroSentencia_NumeroRes]
	ON [Expediente].[LibroSentencia] ([TU_CodResolucion])
	INCLUDE ([TC_NumeroResolucion])
	ON [ExpedientePS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla que permite llevar el registro de los números de sentencia generados.', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Año en que se genera el numero de sentencia', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'COLUMN', N'TC_AnnoSentencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del Contexto donde pertenece el nùmero de sentencia.', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo que utiliza y solicita el numero de sentencia.', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de sentencia de la oficina.', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'COLUMN', N'TC_NumeroResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que realiza la asignaciòn al juez del numero de resolucion', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'COLUMN', N'TF_FechaAsignacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado de la reserva del número resolución (I-Inhabilitado C-Confirmado P-Pendiente A-Asignado).', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Referencia al documento de resolucion asignado.', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'COLUMN', N'TU_CodResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del persona que realiza la asignaciòn', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'COLUMN', N'TU_UsuarioCrea'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de Puesto de trabajo de la persona que confirma el cambio de estado del nùmero de sentencia', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'COLUMN', N'TU_UsuarioConfirma'
GO
EXEC sp_addextendedproperty N'MS_Description', N'El usuario debe indicar el motivo por el cual no uso el nùmero de sentencia', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'COLUMN', N'TC_JustificacionNoUso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA.', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que identifica el valor del campo JUEZ en DACORES de Gestión', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'COLUMN', N'JUEZ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que identifica el valor del campo USUREDAC en DACORES de Gestión', 'SCHEMA', N'Expediente', 'TABLE', N'LibroSentencia', 'COLUMN', N'USUREDAC'
GO
ALTER TABLE [Expediente].[LibroSentencia] SET (LOCK_ESCALATION = TABLE)
GO

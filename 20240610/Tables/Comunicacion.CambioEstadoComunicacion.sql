SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Comunicacion].[CambioEstadoComunicacion] (
		[TU_CodCambioEstado]     [uniqueidentifier] NOT NULL,
		[TU_CodComunicacion]     [uniqueidentifier] NOT NULL,
		[TF_Fecha]               [datetime2](7) NOT NULL,
		[TC_Observaciones]       [varchar](500) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Estado]              [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]          [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]           [datetime2](7) NOT NULL,
		[IDNOTIF]                [int] NULL,
		CONSTRAINT [PK_CambioEstadoComunicacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodCambioEstado])
	ON [PRIMARY]
) ON [ComunicacionPS] ([TF_Particion])
GO
ALTER TABLE [Comunicacion].[CambioEstadoComunicacion]
	ADD
	CONSTRAINT [DF__CambioEst__TF_Pa__12D54B2E]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
CREATE CLUSTERED INDEX [IX_Comunicacion_CambioEstadoComunicacion_TF_Particion]
	ON [Comunicacion].[CambioEstadoComunicacion] ([TF_Particion])
	ON [ComunicacionPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_CambioEstado_ConsultarCambioEstadoComunicacion]
	ON [Comunicacion].[CambioEstadoComunicacion] ([TU_CodComunicacion])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice creado para optimizar Comunicacion.PA_ConsultarCambioEstadoComunicacion.', 'SCHEMA', N'Comunicacion', 'TABLE', N'CambioEstadoComunicacion', 'INDEX', N'IX_CambioEstado_ConsultarCambioEstadoComunicacion'
GO
CREATE NONCLUSTERED INDEX [IX_Comunicacion_CambioEstadoComunicacion_Migracion]
	ON [Comunicacion].[CambioEstadoComunicacion] ([TU_CodComunicacion], [TF_Fecha], [TC_Estado])
	ON [ComunicacionPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena el historial de los cambios de estado de una comunicación judicial', 'SCHEMA', N'Comunicacion', 'TABLE', N'CambioEstadoComunicacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cambio de estado de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'CambioEstadoComunicacion', 'COLUMN', N'TU_CodCambioEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador unico del registro de la cominicacion ', 'SCHEMA', N'Comunicacion', 'TABLE', N'CambioEstadoComunicacion', 'COLUMN', N'TU_CodComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'CambioEstadoComunicacion', 'COLUMN', N'TF_Fecha'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'CambioEstadoComunicacion', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el estado de la comunicación judicial, WITH CHECK ADD CONSTRAINT para que solo acepte los siguientes valores, para   Registrada = ''A'', ParaTramitar = ''B'', Revisando = ''C'', EspereandoCopias = ''D'', ParaComunicar = ''E'', Comunicandose = ''F'', ParaEntregar = ''G'', ParaCorregir = ''H'', Entregandose = ''I'', Entregada = ''J'', Comisionada = ''K''', 'SCHEMA', N'Comunicacion', 'TABLE', N'CambioEstadoComunicacion', 'COLUMN', N'TC_Estado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del usuario que realiza el cambio de estado', 'SCHEMA', N'Comunicacion', 'TABLE', N'CambioEstadoComunicacion', 'COLUMN', N'TC_UsuarioRed'
GO
ALTER TABLE [Comunicacion].[CambioEstadoComunicacion] SET (LOCK_ESCALATION = TABLE)
GO

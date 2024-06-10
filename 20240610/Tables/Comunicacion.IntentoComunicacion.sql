SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Comunicacion].[IntentoComunicacion] (
		[TU_CodIntento]               [uniqueidentifier] NOT NULL,
		[TU_CodComunicacion]          [uniqueidentifier] NOT NULL,
		[TC_Observaciones]            [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaIntento]             [datetime2](7) NOT NULL,
		[TC_UsuarioRed]               [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		[TG_UbicacionPuntoVisita]     [geography] NULL,
		[TB_Positivo]                 [bit] NOT NULL,
		[TC_NombreRecibe]             [varchar](150) COLLATE Modern_Spanish_CI_AS NULL,
		[TI_FirmaDestinatario]        [image] NULL,
		[TC_NombreTestigo]            [varchar](150) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                [datetime2](7) NOT NULL,
		CONSTRAINT [PK_IntentoVisitaComunicacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodIntento])
	ON [PRIMARY]
) ON [ComunicacionPS] ([TF_Particion])
GO
ALTER TABLE [Comunicacion].[IntentoComunicacion]
	ADD
	CONSTRAINT [DF_IntentoComunicacion_TB_IntentoPositivo]
	DEFAULT ((0)) FOR [TB_Positivo]
GO
ALTER TABLE [Comunicacion].[IntentoComunicacion]
	ADD
	CONSTRAINT [DF__IntentoCo__TF_Pa__6602A4B7]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Comunicacion].[IntentoComunicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_IntentoComunicacion_Funcionario]
	FOREIGN KEY ([TC_UsuarioRed]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Comunicacion].[IntentoComunicacion]
	CHECK CONSTRAINT [FK_IntentoComunicacion_Funcionario]

GO
CREATE CLUSTERED INDEX [IX_Comunicacion_IntentoComunicacion_TF_Particion]
	ON [Comunicacion].[IntentoComunicacion] ([TF_Particion])
	ON [ComunicacionPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Comunicacion_IntentoComunicacion_Migracion]
	ON [Comunicacion].[IntentoComunicacion] ([TU_CodComunicacion], [TF_FechaIntento])
	ON [ComunicacionPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los intentos que se realizan para poder entregar una comunicación, física y electrónica', 'SCHEMA', N'Comunicacion', 'TABLE', N'IntentoComunicacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del intento realizado', 'SCHEMA', N'Comunicacion', 'TABLE', N'IntentoComunicacion', 'COLUMN', N'TU_CodIntento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la comunicación judicial', 'SCHEMA', N'Comunicacion', 'TABLE', N'IntentoComunicacion', 'COLUMN', N'TU_CodComunicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones de la visita', 'SCHEMA', N'Comunicacion', 'TABLE', N'IntentoComunicacion', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha del intento de visita o resultado', 'SCHEMA', N'Comunicacion', 'TABLE', N'IntentoComunicacion', 'COLUMN', N'TF_FechaIntento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del usuario que registra el resultado', 'SCHEMA', N'Comunicacion', 'TABLE', N'IntentoComunicacion', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Coordenadas geográficas de dónde se efectúa el intento.', 'SCHEMA', N'Comunicacion', 'TABLE', N'IntentoComunicacion', 'COLUMN', N'TG_UbicacionPuntoVisita'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el intento de comunicación fue positivo. Positivo =1, Negativo = 0', 'SCHEMA', N'Comunicacion', 'TABLE', N'IntentoComunicacion', 'COLUMN', N'TB_Positivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la persona que recibe la comunicación, en caso de que reciba otra persona distinta al destinatario original', 'SCHEMA', N'Comunicacion', 'TABLE', N'IntentoComunicacion', 'COLUMN', N'TC_NombreRecibe'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Firma del destinatario de la comunicación', 'SCHEMA', N'Comunicacion', 'TABLE', N'IntentoComunicacion', 'COLUMN', N'TI_FirmaDestinatario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del testigo', 'SCHEMA', N'Comunicacion', 'TABLE', N'IntentoComunicacion', 'COLUMN', N'TC_NombreTestigo'
GO
ALTER TABLE [Comunicacion].[IntentoComunicacion] SET (LOCK_ESCALATION = TABLE)
GO

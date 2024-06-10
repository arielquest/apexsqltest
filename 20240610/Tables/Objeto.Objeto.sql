SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Objeto].[Objeto] (
		[TU_CodObjeto]             [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]      [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodOficina]            [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_TipoObjeto]            [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroObjeto]          [varchar](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]           [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Observacion]           [varchar](500) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Marca]                 [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Modelo]                [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Serie]                 [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Color]                 [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_Peritaje]              [bit] NOT NULL,
		[TN_CodMoneda]             [smallint] NULL,
		[TN_Valor]                 [decimal](18, 2) NULL,
		[TF_FechaRegistro]         [datetime] NOT NULL,
		[TB_Contenedor]            [bit] NOT NULL,
		[TU_CodigoObjetoPadre]     [uniqueidentifier] NULL,
		[TC_UsuarioRed]            [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_Ley]                   [bit] NOT NULL,
		[TF_Actualizacion]         [datetime2](7) NOT NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		CONSTRAINT [UQ__Objeto__01DE7BCDEDBA4DB3]
		UNIQUE
		NONCLUSTERED
		([TC_NumeroObjeto])
		ON [PRIMARY],
		CONSTRAINT [PK__Objeto__9E0B2122B8CAF77C]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodObjeto])
	ON [PRIMARY]
) ON [ObjetoPS] ([TF_Particion])
GO
ALTER TABLE [Objeto].[Objeto]
	ADD
	CONSTRAINT [DF__Objeto__TC_TipoO__62BCEF0F]
	DEFAULT ('0') FOR [TC_TipoObjeto]
GO
ALTER TABLE [Objeto].[Objeto]
	ADD
	CONSTRAINT [DF__Objeto__TB_Conte__63B11348]
	DEFAULT ('0') FOR [TB_Contenedor]
GO
ALTER TABLE [Objeto].[Objeto]
	ADD
	CONSTRAINT [DF__Objeto__TB_Ley__64A53781]
	DEFAULT ('0') FOR [TB_Ley]
GO
ALTER TABLE [Objeto].[Objeto]
	ADD
	CONSTRAINT [DF_Objeto_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Objeto].[Objeto]
	ADD
	CONSTRAINT [DF__Objeto__TF_Parti__7080332A]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Objeto].[Objeto]
	WITH CHECK
	ADD CONSTRAINT [FK_Objeto_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Objeto].[Objeto]
	CHECK CONSTRAINT [FK_Objeto_Expediente]

GO
ALTER TABLE [Objeto].[Objeto]
	WITH CHECK
	ADD CONSTRAINT [FK_Objeto_Moneda]
	FOREIGN KEY ([TN_CodMoneda]) REFERENCES [Catalogo].[Moneda] ([TN_CodMoneda])
ALTER TABLE [Objeto].[Objeto]
	CHECK CONSTRAINT [FK_Objeto_Moneda]

GO
ALTER TABLE [Objeto].[Objeto]
	WITH CHECK
	ADD CONSTRAINT [FK_Objeto_Objeto]
	FOREIGN KEY ([TU_CodigoObjetoPadre]) REFERENCES [Objeto].[Objeto] ([TU_CodObjeto])
ALTER TABLE [Objeto].[Objeto]
	CHECK CONSTRAINT [FK_Objeto_Objeto]

GO
ALTER TABLE [Objeto].[Objeto]
	WITH CHECK
	ADD CONSTRAINT [FK_Objeto_Oficina]
	FOREIGN KEY ([TC_CodOficina]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Objeto].[Objeto]
	CHECK CONSTRAINT [FK_Objeto_Oficina]

GO
CREATE CLUSTERED INDEX [IX_Objeto_Objeto_TF_Particion]
	ON [Objeto].[Objeto] ([TF_Particion])
	ON [ObjetoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta tabla va a contener toda la información relacionada a los objetos', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el código, este código se va a generar por secuencia, se va a utilizar como llave primaria', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TU_CodObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente asociado al objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo Oficina.', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TC_CodOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'General = ''G'', Vehiculo = ''V'', BienInmueble = ''I'', Arma = ''A'', DepositoBancario = ''D''', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TC_TipoObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el número del objeto, este campo es único', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TC_NumeroObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener la descripción del objeto de manera detalla', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observación del objeto, campo alfanumérico, opcional', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TC_Observacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener la marca del objeto, este campo no es requerido', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TC_Marca'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el modelo del objeto, este campo no es requerido', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TC_Modelo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el número de serie del objeto, este campo no es requerido', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TC_Serie'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el color del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TC_Color'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que indica si ya se realizó un peritaje para determinar el valor del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TB_Peritaje'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Moneda utilizada en el valor del objeto.', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TN_CodMoneda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor monetario del objeto.', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TN_Valor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora De recibido el objeto - Ley 6106.', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TF_FechaRegistro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a definir si el objeto es un contenedor o no, en caso de que sea contenerdor no puede estar contenido en otro objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TB_Contenedor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a contener el código del objeto padre, solo para los objetos que el campo es contenedor es falso', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TU_CodigoObjetoPadre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que registró el objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a definir si el objeto cumple con la Ley 6106 (3 meses para gestionar disposición de evidencias decomisadas)', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TB_Ley'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora de registro o última actualización realizada al registro de objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Objeto', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Objeto].[Objeto] SET (LOCK_ESCALATION = TABLE)
GO

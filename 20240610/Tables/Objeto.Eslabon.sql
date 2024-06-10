SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Objeto].[Eslabon] (
		[TU_CodEslabon]                       [uniqueidentifier] NOT NULL,
		[TU_CodObjeto]                        [uniqueidentifier] NOT NULL,
		[TC_CodOficina_Entrega]               [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_CodTipoIdentificacionEntrega]     [smallint] NOT NULL,
		[TC_IdentificacionEntrega]            [varchar](21) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NombreCompletoEntrega]            [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRedEntrega]                [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodOficina_Recibe]                [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoIdentificacionRecibe]      [smallint] NOT NULL,
		[TC_IdentificacionRecibe]             [varchar](21) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NombreCompletoRecibe]             [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRedRecibe]                 [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Tomo]                             [varchar](10) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Folio]                            [varchar](10) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Fecha]                            [datetime2](7) NOT NULL,
		[TC_Observaciones]                    [varchar](250) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]                    [datetime2](7) NOT NULL,
		[TF_Particion]                        [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Eslabon]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodEslabon])
	ON [PRIMARY]
) ON [ObjetoPS] ([TF_Particion])
GO
ALTER TABLE [Objeto].[Eslabon]
	ADD
	CONSTRAINT [DF__Eslabon__TF_Actu__70F5FFCD]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Objeto].[Eslabon]
	ADD
	CONSTRAINT [DF__Eslabon__TF_Part__51FBAC0A]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Objeto].[Eslabon]
	WITH CHECK
	ADD CONSTRAINT [FK_Eslabon_Objeto]
	FOREIGN KEY ([TU_CodObjeto]) REFERENCES [Objeto].[Objeto] ([TU_CodObjeto])
ALTER TABLE [Objeto].[Eslabon]
	CHECK CONSTRAINT [FK_Eslabon_Objeto]

GO
ALTER TABLE [Objeto].[Eslabon]
	WITH CHECK
	ADD CONSTRAINT [FK_Eslabon_Oficina_Entrega]
	FOREIGN KEY ([TC_CodOficina_Entrega]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Objeto].[Eslabon]
	CHECK CONSTRAINT [FK_Eslabon_Oficina_Entrega]

GO
ALTER TABLE [Objeto].[Eslabon]
	WITH CHECK
	ADD CONSTRAINT [FK_Eslabon_Oficina_Recibe]
	FOREIGN KEY ([TC_CodOficina_Recibe]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Objeto].[Eslabon]
	CHECK CONSTRAINT [FK_Eslabon_Oficina_Recibe]

GO
ALTER TABLE [Objeto].[Eslabon]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonaEntrega_TipoIdentificacion]
	FOREIGN KEY ([TN_CodTipoIdentificacionEntrega]) REFERENCES [Catalogo].[TipoIdentificacion] ([TN_CodTipoIdentificacion])
ALTER TABLE [Objeto].[Eslabon]
	CHECK CONSTRAINT [FK_PersonaEntrega_TipoIdentificacion]

GO
ALTER TABLE [Objeto].[Eslabon]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonaRecibe_TipoIdentificacion]
	FOREIGN KEY ([TN_CodTipoIdentificacionRecibe]) REFERENCES [Catalogo].[TipoIdentificacion] ([TN_CodTipoIdentificacion])
ALTER TABLE [Objeto].[Eslabon]
	CHECK CONSTRAINT [FK_PersonaRecibe_TipoIdentificacion]

GO
CREATE CLUSTERED INDEX [IX_Objeto_Eslabon_TF_Particion]
	ON [Objeto].[Eslabon] ([TF_Particion])
	ON [ObjetoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único del eslabón', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TU_CodEslabon'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el código del objeto que hace referencia a la tabla de Eslabon', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TU_CodObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el id de la oficina que se encuentra relacionada con la persona que entrega el objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TC_CodOficina_Entrega'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de identificación de la persona que entrega.', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TN_CodTipoIdentificacionEntrega'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificación de la persona que entrega.', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TC_IdentificacionEntrega'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre completo de la persona que entrega.', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TC_NombreCompletoEntrega'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el usuario de red de la persona que entrega.', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TC_UsuarioRedEntrega'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el id de la oficina que se encuentra relacionada con la persona que recibe el objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TC_CodOficina_Recibe'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de identificación de la persona que recibe.', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TN_CodTipoIdentificacionRecibe'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificación de la persona que recibe.', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TC_IdentificacionRecibe'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre completo de la persona que recibe.', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TC_NombreCompletoRecibe'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el usuario de red de la persona que recibe.', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TC_UsuarioRedRecibe'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo opcional que va a contener el número de tomo asociado a la entrega del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TC_Tomo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo opcional que va a contener el número de folio asociado a la entrega del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TC_Folio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora de la entrega del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TF_Fecha'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener las observaciones relacionadas a la entrega del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora de registro o última actualización realizada al registro de eslabón', 'SCHEMA', N'Objeto', 'TABLE', N'Eslabon', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Objeto].[Eslabon] SET (LOCK_ESCALATION = TABLE)
GO

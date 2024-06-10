SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Objeto].[Ubicacion] (
		[TU_CodUbicacion]          [uniqueidentifier] NOT NULL,
		[TU_CodObjeto]             [uniqueidentifier] NOT NULL,
		[TN_CodBodega]             [smallint] NULL,
		[TN_CodSeccion]            [smallint] NULL,
		[TN_CodEstante]            [smallint] NULL,
		[TN_CodCompartimiento]     [smallint] NULL,
		[TC_Descripcion]           [varchar](500) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]            [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fecha]                 [datetime2](7) NOT NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Ubicacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodUbicacion])
	ON [PRIMARY]
) ON [ObjetoPS] ([TF_Particion])
GO
ALTER TABLE [Objeto].[Ubicacion]
	ADD
	CONSTRAINT [DF__Ubicacion__TF_Pa__324DF687]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Objeto].[Ubicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Ubicacion_Bodega]
	FOREIGN KEY ([TN_CodBodega]) REFERENCES [Catalogo].[Bodega] ([TN_CodBodega])
ALTER TABLE [Objeto].[Ubicacion]
	CHECK CONSTRAINT [FK_Ubicacion_Bodega]

GO
ALTER TABLE [Objeto].[Ubicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Ubicacion_Compartimiento]
	FOREIGN KEY ([TN_CodCompartimiento]) REFERENCES [Catalogo].[Compartimiento] ([TN_CodCompartimiento])
ALTER TABLE [Objeto].[Ubicacion]
	CHECK CONSTRAINT [FK_Ubicacion_Compartimiento]

GO
ALTER TABLE [Objeto].[Ubicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Ubicacion_Estante]
	FOREIGN KEY ([TN_CodEstante]) REFERENCES [Catalogo].[Estante] ([TN_CodEstante])
ALTER TABLE [Objeto].[Ubicacion]
	CHECK CONSTRAINT [FK_Ubicacion_Estante]

GO
ALTER TABLE [Objeto].[Ubicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Ubicacion_Objeto]
	FOREIGN KEY ([TU_CodObjeto]) REFERENCES [Objeto].[Objeto] ([TU_CodObjeto])
ALTER TABLE [Objeto].[Ubicacion]
	CHECK CONSTRAINT [FK_Ubicacion_Objeto]

GO
ALTER TABLE [Objeto].[Ubicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Ubicacion_Seccion]
	FOREIGN KEY ([TN_CodSeccion]) REFERENCES [Catalogo].[Seccion] ([TN_CodSeccion])
ALTER TABLE [Objeto].[Ubicacion]
	CHECK CONSTRAINT [FK_Ubicacion_Seccion]

GO
CREATE CLUSTERED INDEX [IX_Objeto_Ubicacion_TF_Particion]
	ON [Objeto].[Ubicacion] ([TF_Particion])
	ON [ObjetoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único de la ubicación', 'SCHEMA', N'Objeto', 'TABLE', N'Ubicacion', 'COLUMN', N'TU_CodUbicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el código del objeto que hace referencia a la tabla de Ubicacion', 'SCHEMA', N'Objeto', 'TABLE', N'Ubicacion', 'COLUMN', N'TU_CodObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo opcional que va a contener el id de la bodega en la encuentra ubibado el objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Ubicacion', 'COLUMN', N'TN_CodBodega'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo opcional que va a contener el id de la secció en la que encuentra ubibado el objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Ubicacion', 'COLUMN', N'TN_CodSeccion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo opcional que va a contener el id del estante en el que encuentra ubibado el objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Ubicacion', 'COLUMN', N'TN_CodEstante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo opcional que va a contener el id del compartimiento en el que se encuentra ubibado el objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Ubicacion', 'COLUMN', N'TN_CodCompartimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la descripción relacionada a la ubicación del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Ubicacion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el usuario de red de la persona que registra la ubicación.', 'SCHEMA', N'Objeto', 'TABLE', N'Ubicacion', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora de la entrega del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Ubicacion', 'COLUMN', N'TF_Fecha'
GO
ALTER TABLE [Objeto].[Ubicacion] SET (LOCK_ESCALATION = TABLE)
GO

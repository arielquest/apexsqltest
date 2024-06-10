SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Objeto].[Documento] (
		[TU_CodArchivo]        [uniqueidentifier] NOT NULL,
		[TU_CodObjeto]         [uniqueidentifier] NOT NULL,
		[TC_Descripcion]       [varchar](300) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]     [datetime2](7) NOT NULL,
		[TF_Particion]         [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Documento]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodArchivo])
	ON [PRIMARY]
) ON [ObjetoPS] ([TF_Particion])
GO
ALTER TABLE [Objeto].[Documento]
	ADD
	CONSTRAINT [DF__Documento__TF_Ac__1221E96E]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Objeto].[Documento]
	ADD
	CONSTRAINT [DF__Documento__TF_Pa__510787D1]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Objeto].[Documento]
	WITH CHECK
	ADD CONSTRAINT [FK_Documento_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Objeto].[Documento]
	CHECK CONSTRAINT [FK_Documento_Archivo]

GO
ALTER TABLE [Objeto].[Documento]
	WITH CHECK
	ADD CONSTRAINT [FK_Documento_Objeto]
	FOREIGN KEY ([TU_CodObjeto]) REFERENCES [Objeto].[Objeto] ([TU_CodObjeto])
ALTER TABLE [Objeto].[Documento]
	CHECK CONSTRAINT [FK_Documento_Objeto]

GO
CREATE CLUSTERED INDEX [IX_Objeto_Documento_TF_Particion]
	ON [Objeto].[Documento] ([TF_Particion])
	ON [ObjetoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el id del archivo relacionado al objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Documento', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el código del objeto que hace referencia a la tabla de Documento', 'SCHEMA', N'Objeto', 'TABLE', N'Documento', 'COLUMN', N'TU_CodObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo opcional que va a contener la descripción relacionada al documento del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Documento', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora de registro o última actualización realizada al registro de documento', 'SCHEMA', N'Objeto', 'TABLE', N'Documento', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Objeto].[Documento] SET (LOCK_ESCALATION = TABLE)
GO

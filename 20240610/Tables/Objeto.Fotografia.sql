SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Objeto].[Fotografia] (
		[TU_CodArchivo]        [uniqueidentifier] NOT NULL,
		[TU_CodObjeto]         [uniqueidentifier] NOT NULL,
		[TC_Observacion]       [varchar](300) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]     [datetime2](7) NOT NULL,
		[TF_Particion]         [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Fotografia]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodArchivo])
	ON [PRIMARY]
) ON [ObjetoPS] ([TF_Particion])
GO
ALTER TABLE [Objeto].[Fotografia]
	ADD
	CONSTRAINT [DF__Fotografi__TF_Ac__207008C5]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Objeto].[Fotografia]
	ADD
	CONSTRAINT [DF__Fotografi__TF_Pa__54D818B5]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Objeto].[Fotografia]
	WITH CHECK
	ADD CONSTRAINT [FK_Fotografia_Archivo]
	FOREIGN KEY ([TU_CodArchivo]) REFERENCES [Archivo].[Archivo] ([TU_CodArchivo])
ALTER TABLE [Objeto].[Fotografia]
	CHECK CONSTRAINT [FK_Fotografia_Archivo]

GO
ALTER TABLE [Objeto].[Fotografia]
	WITH CHECK
	ADD CONSTRAINT [FK_Fotografia_Objeto]
	FOREIGN KEY ([TU_CodObjeto]) REFERENCES [Objeto].[Objeto] ([TU_CodObjeto])
ALTER TABLE [Objeto].[Fotografia]
	CHECK CONSTRAINT [FK_Fotografia_Objeto]

GO
CREATE CLUSTERED INDEX [IX_Objeto_Fotografia_TF_Particion]
	ON [Objeto].[Fotografia] ([TF_Particion])
	ON [ObjetoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el id del archivo relacionado a la fotografía', 'SCHEMA', N'Objeto', 'TABLE', N'Fotografia', 'COLUMN', N'TU_CodArchivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener el código del objeto que hace referencia a la tabla de Fotografia', 'SCHEMA', N'Objeto', 'TABLE', N'Fotografia', 'COLUMN', N'TU_CodObjeto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo opcional que va a contener la observacióh relacionada a la fotografía del objeto', 'SCHEMA', N'Objeto', 'TABLE', N'Fotografia', 'COLUMN', N'TC_Observacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo obligatorio que va a contener la fecha y hora de registro o última actualización realizada al registro de Fotografia', 'SCHEMA', N'Objeto', 'TABLE', N'Fotografia', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Objeto].[Fotografia] SET (LOCK_ESCALATION = TABLE)
GO

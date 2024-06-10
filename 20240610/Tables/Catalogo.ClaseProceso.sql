SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Catalogo].[ClaseProceso] (
		[TN_CodClase]            [int] NOT NULL,
		[TN_CodProceso]          [smallint] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NULL,
		CONSTRAINT [PK_ClaseAsuntoProcedimiento]
		PRIMARY KEY
		CLUSTERED
		([TN_CodClase], [TN_CodProceso])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[ClaseProceso]
	WITH CHECK
	ADD CONSTRAINT [FK_ClaseProceso_Clase]
	FOREIGN KEY ([TN_CodClase]) REFERENCES [Catalogo].[Clase] ([TN_CodClase])
ALTER TABLE [Catalogo].[ClaseProceso]
	CHECK CONSTRAINT [FK_ClaseProceso_Clase]

GO
ALTER TABLE [Catalogo].[ClaseProceso]
	WITH CHECK
	ADD CONSTRAINT [FK_ClaseProceso_Proceso]
	FOREIGN KEY ([TN_CodProceso]) REFERENCES [Catalogo].[Proceso] ([TN_CodProceso])
ALTER TABLE [Catalogo].[ClaseProceso]
	CHECK CONSTRAINT [FK_ClaseProceso_Proceso]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia las clases con sus procesos.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseProceso', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la clase.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseProceso', 'COLUMN', N'TN_CodClase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del proceso.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseProceso', 'COLUMN', N'TN_CodProceso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseProceso', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[ClaseProceso] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[ClaseProcesoTipoOficinaMateria] (
		[TN_CodProceso]          [smallint] NOT NULL,
		[TN_CodTipoOficina]      [smallint] NOT NULL,
		[TN_CodClase]            [int] NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodFase]             [smallint] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ClaseProcesoTipoOficinaMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodProceso], [TN_CodTipoOficina], [TN_CodClase], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[ClaseProcesoTipoOficinaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_ClaseProcesoTipoOficinaMateria_ClaseTipoOficina]
	FOREIGN KEY ([TN_CodClase], [TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[ClaseTipoOficina] ([TN_CodClase], [TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[ClaseProcesoTipoOficinaMateria]
	CHECK CONSTRAINT [FK_ClaseProcesoTipoOficinaMateria_ClaseTipoOficina]

GO
ALTER TABLE [Catalogo].[ClaseProcesoTipoOficinaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_ClaseProcesoTipoOficinaMateria_Fase]
	FOREIGN KEY ([TN_CodFase]) REFERENCES [Catalogo].[Fase] ([TN_CodFase])
ALTER TABLE [Catalogo].[ClaseProcesoTipoOficinaMateria]
	CHECK CONSTRAINT [FK_ClaseProcesoTipoOficinaMateria_Fase]

GO
ALTER TABLE [Catalogo].[ClaseProcesoTipoOficinaMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_ClaseProcesoTipoOficinaMateria_Proceso]
	FOREIGN KEY ([TN_CodProceso]) REFERENCES [Catalogo].[Proceso] ([TN_CodProceso])
ALTER TABLE [Catalogo].[ClaseProcesoTipoOficinaMateria]
	CHECK CONSTRAINT [FK_ClaseProcesoTipoOficinaMateria_Proceso]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla pivote para vincular el proceso con la clase, el tipo de oficina y la materia', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseProcesoTipoOficinaMateria', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de proceso', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseProcesoTipoOficinaMateria', 'COLUMN', N'TN_CodProceso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseProcesoTipoOficinaMateria', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de clase de asunto', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseProcesoTipoOficinaMateria', 'COLUMN', N'TN_CodClase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de materia', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseProcesoTipoOficinaMateria', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la fase.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseProcesoTipoOficinaMateria', 'COLUMN', N'TN_CodFase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseProcesoTipoOficinaMateria', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[ClaseProcesoTipoOficinaMateria] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[FormatoJuridicoProceso] (
		[TC_CodFormatoJuridico]     [varchar](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodClase]               [int] NOT NULL,
		[TN_CodProceso]             [smallint] NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		[TN_CodTipoOficina]         [smallint] NOT NULL,
		[TC_CodMateria]             [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_FormatoJuridicoProcedimiento]
		PRIMARY KEY
		CLUSTERED
		([TC_CodFormatoJuridico], [TN_CodClase], [TN_CodProceso], [TN_CodTipoOficina], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[FormatoJuridicoProceso]
	WITH CHECK
	ADD CONSTRAINT [FK_FormatoJuridicoProcedimiento_FormatoJuridico]
	FOREIGN KEY ([TC_CodFormatoJuridico]) REFERENCES [Catalogo].[FormatoJuridico] ([TC_CodFormatoJuridico])
ALTER TABLE [Catalogo].[FormatoJuridicoProceso]
	CHECK CONSTRAINT [FK_FormatoJuridicoProcedimiento_FormatoJuridico]

GO
ALTER TABLE [Catalogo].[FormatoJuridicoProceso]
	WITH CHECK
	ADD CONSTRAINT [FK_FormatoJuridicoProceso_Clase]
	FOREIGN KEY ([TN_CodClase]) REFERENCES [Catalogo].[Clase] ([TN_CodClase])
ALTER TABLE [Catalogo].[FormatoJuridicoProceso]
	CHECK CONSTRAINT [FK_FormatoJuridicoProceso_Clase]

GO
ALTER TABLE [Catalogo].[FormatoJuridicoProceso]
	WITH CHECK
	ADD CONSTRAINT [FK_FormatoJuridicoProceso_ClaseProceso]
	FOREIGN KEY ([TN_CodClase], [TN_CodProceso]) REFERENCES [Catalogo].[ClaseProceso] ([TN_CodClase], [TN_CodProceso])
ALTER TABLE [Catalogo].[FormatoJuridicoProceso]
	CHECK CONSTRAINT [FK_FormatoJuridicoProceso_ClaseProceso]

GO
ALTER TABLE [Catalogo].[FormatoJuridicoProceso]
	WITH CHECK
	ADD CONSTRAINT [FK_FormatoJuridicoProceso_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[FormatoJuridicoProceso]
	CHECK CONSTRAINT [FK_FormatoJuridicoProceso_Materia]

GO
ALTER TABLE [Catalogo].[FormatoJuridicoProceso]
	WITH CHECK
	ADD CONSTRAINT [FK_FormatoJuridicoProceso_Proceso]
	FOREIGN KEY ([TN_CodProceso]) REFERENCES [Catalogo].[Proceso] ([TN_CodProceso])
ALTER TABLE [Catalogo].[FormatoJuridicoProceso]
	CHECK CONSTRAINT [FK_FormatoJuridicoProceso_Proceso]

GO
ALTER TABLE [Catalogo].[FormatoJuridicoProceso]
	WITH CHECK
	ADD CONSTRAINT [FK_FormatoJuridicoProceso_TipoOficina]
	FOREIGN KEY ([TN_CodTipoOficina]) REFERENCES [Catalogo].[TipoOficina] ([TN_CodTipoOficina])
ALTER TABLE [Catalogo].[FormatoJuridicoProceso]
	CHECK CONSTRAINT [FK_FormatoJuridicoProceso_TipoOficina]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que relaciona el proceso con el formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoProceso', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la plantilla de formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoProceso', 'COLUMN', N'TC_CodFormatoJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la clase relacionada al formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoProceso', 'COLUMN', N'TN_CodClase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del proceso relacionado al formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoProceso', 'COLUMN', N'TN_CodProceso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoProceso', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo oficina al cual se asocia el formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoProceso', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de materia al cual se asocia el formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoProceso', 'COLUMN', N'TC_CodMateria'
GO
ALTER TABLE [Catalogo].[FormatoJuridicoProceso] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoOficinaResultadoResolucion] (
		[TN_CodTipoOficina]             [smallint] NOT NULL,
		[TN_CodResultadoResolucion]     [smallint] NOT NULL,
		[TF_Inicio_Vigencia]            [datetime2](7) NULL,
		[TC_CodMateria]                 [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_TipoOficinaResultadoResolucion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoOficina], [TN_CodResultadoResolucion], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoOficinaResultadoResolucion]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaResultadoResolucion_ResultadoResolucion]
	FOREIGN KEY ([TN_CodResultadoResolucion]) REFERENCES [Catalogo].[ResultadoResolucion] ([TN_CodResultadoResolucion])
ALTER TABLE [Catalogo].[TipoOficinaResultadoResolucion]
	CHECK CONSTRAINT [FK_TipoOficinaResultadoResolucion_ResultadoResolucion]

GO
ALTER TABLE [Catalogo].[TipoOficinaResultadoResolucion]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaResultadoResolucion_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[TipoOficinaResultadoResolucion]
	CHECK CONSTRAINT [FK_TipoOficinaResultadoResolucion_TipoOficinaMateria]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia tipo de oficina con resultado de resolución.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaResultadoResolucion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaResultadoResolucion', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de resultado de resolución.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaResultadoResolucion', 'COLUMN', N'TN_CodResultadoResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaResultadoResolucion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Materia asociado al resultado de resolucion', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaResultadoResolucion', 'COLUMN', N'TC_CodMateria'
GO
ALTER TABLE [Catalogo].[TipoOficinaResultadoResolucion] SET (LOCK_ESCALATION = TABLE)
GO

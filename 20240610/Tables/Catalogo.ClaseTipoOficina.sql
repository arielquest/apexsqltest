SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[ClaseTipoOficina] (
		[TN_CodTipoOficina]       [smallint] NOT NULL,
		[TN_CodClase]             [int] NOT NULL,
		[TF_Inicio_Vigencia]      [datetime2](7) NULL,
		[TC_CodMateria]           [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_CostasPersonales]     [bit] NOT NULL,
		CONSTRAINT [PK_TipoOficinaClaseAsunto]
		PRIMARY KEY
		CLUSTERED
		([TN_CodClase], [TN_CodTipoOficina], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[ClaseTipoOficina]
	ADD
	CONSTRAINT [DF__ClaseTipo__TB_Co__2904836F]
	DEFAULT ((0)) FOR [TB_CostasPersonales]
GO
ALTER TABLE [Catalogo].[ClaseTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_ClaseTipoOficina_Clase]
	FOREIGN KEY ([TN_CodClase]) REFERENCES [Catalogo].[Clase] ([TN_CodClase])
ALTER TABLE [Catalogo].[ClaseTipoOficina]
	CHECK CONSTRAINT [FK_ClaseTipoOficina_Clase]

GO
ALTER TABLE [Catalogo].[ClaseTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_ClaseTipoOficina_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[ClaseTipoOficina]
	CHECK CONSTRAINT [FK_ClaseTipoOficina_TipoOficinaMateria]

GO
CREATE NONCLUSTERED INDEX [IX_TipoOficinaClaseAsunto_ConsultarFormatoJuridicoProcedimientosAsociables]
	ON [Catalogo].[ClaseTipoOficina] ([TF_Inicio_Vigencia])
	INCLUDE ([TN_CodTipoOficina], [TN_CodClase], [TC_CodMateria])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice creado para optimizar Catalogo.PA_ConsultarFormatoJuridicoProcedimientosAsociables.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseTipoOficina', 'INDEX', N'IX_TipoOficinaClaseAsunto_ConsultarFormatoJuridicoProcedimientosAsociables'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia los tipos de oficina con su clase.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseTipoOficina', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseTipoOficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de clase.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseTipoOficina', 'COLUMN', N'TN_CodClase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseTipoOficina', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseTipoOficina', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la clase de asunto en el tipo de oficina se usa para cálculo de costas personales', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseTipoOficina', 'COLUMN', N'TB_CostasPersonales'
GO
ALTER TABLE [Catalogo].[ClaseTipoOficina] SET (LOCK_ESCALATION = TABLE)
GO

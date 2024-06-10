SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Configuracion].[Catalogo] (
		[TN_CodCatalogo]        [smallint] NOT NULL,
		[TN_CodSistema]         [smallint] NOT NULL,
		[TC_Descripcion]        [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_Controlador]        [bit] NOT NULL,
		[TC_DescripcionUrl]     [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CatalogoSiagpj]     [varchar](256) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_CCatalogo]
		PRIMARY KEY
		CLUSTERED
		([TN_CodCatalogo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Configuracion].[Catalogo]
	ADD
	CONSTRAINT [DF_Catalogo_TN_CodCatalogo]
	DEFAULT (NEXT VALUE FOR [Configuracion].[SecuenciaCatalogo]) FOR [TN_CodCatalogo]
GO
ALTER TABLE [Configuracion].[Catalogo]
	ADD
	CONSTRAINT [DF__Catalogo__TB_Con__5DE32B59]
	DEFAULT ((0)) FOR [TB_Controlador]
GO
ALTER TABLE [Configuracion].[Catalogo]
	WITH CHECK
	ADD CONSTRAINT [FK_CatalogoSistema_Sistema]
	FOREIGN KEY ([TN_CodSistema]) REFERENCES [Configuracion].[Sistema] ([TN_CodSistema])
ALTER TABLE [Configuracion].[Catalogo]
	CHECK CONSTRAINT [FK_CatalogoSistema_Sistema]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene los catálogos para asociarlos a los sistemas, en las equivalencias', 'SCHEMA', N'Configuracion', 'TABLE', N'Catalogo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de catálogo', 'SCHEMA', N'Configuracion', 'TABLE', N'Catalogo', 'COLUMN', N'TN_CodCatalogo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del catálogo', 'SCHEMA', N'Configuracion', 'TABLE', N'Catalogo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Controlador/Método de consulta', 'SCHEMA', N'Configuracion', 'TABLE', N'Catalogo', 'COLUMN', N'TB_Controlador'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la direccion URL', 'SCHEMA', N'Configuracion', 'TABLE', N'Catalogo', 'COLUMN', N'TC_DescripcionUrl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la tabla catálogo del SIAGPJ asociado', 'SCHEMA', N'Configuracion', 'TABLE', N'Catalogo', 'COLUMN', N'TC_CatalogoSiagpj'
GO
ALTER TABLE [Configuracion].[Catalogo] SET (LOCK_ESCALATION = TABLE)
GO

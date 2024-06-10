SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Catalogo].[TipoOficinaTipoFuncionario] (
		[TN_CodTipoFuncionario]     [smallint] NOT NULL,
		[TN_CodTipoOficina]         [smallint] NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		CONSTRAINT [PK_TipoFuncionarioOficina]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoFuncionario], [TN_CodTipoOficina])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoOficinaTipoFuncionario]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaTipoFuncionario_TipoFuncionario]
	FOREIGN KEY ([TN_CodTipoFuncionario]) REFERENCES [Catalogo].[TipoFuncionario] ([TN_CodTipoFuncionario])
ALTER TABLE [Catalogo].[TipoOficinaTipoFuncionario]
	CHECK CONSTRAINT [FK_TipoOficinaTipoFuncionario_TipoFuncionario]

GO
ALTER TABLE [Catalogo].[TipoOficinaTipoFuncionario]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoOficinaTipoFuncionario_TipoOficina]
	FOREIGN KEY ([TN_CodTipoOficina]) REFERENCES [Catalogo].[TipoOficina] ([TN_CodTipoOficina])
ALTER TABLE [Catalogo].[TipoOficinaTipoFuncionario]
	CHECK CONSTRAINT [FK_TipoOficinaTipoFuncionario_TipoOficina]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia el tipo de funcionario a oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaTipoFuncionario', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de funcionario.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaTipoFuncionario', 'COLUMN', N'TN_CodTipoFuncionario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del Tipo de Oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaTipoFuncionario', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoOficinaTipoFuncionario', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoOficinaTipoFuncionario] SET (LOCK_ESCALATION = TABLE)
GO

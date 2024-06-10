SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoFuncionario] (
		[TN_CodTipoFuncionario]     [smallint] NOT NULL,
		[TC_Descripcion]            [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]           [datetime2](3) NULL,
		[CODCARGO]                  [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [TipoFuncionario_PK]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoFuncionario])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoFuncionario]
	ADD
	CONSTRAINT [DF_TipoFuncionario_TN_CodTipoFuncionario]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoFuncionario]) FOR [TN_CodTipoFuncionario]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de funcionario.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoFuncionario', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de funcionario.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoFuncionario', 'COLUMN', N'TN_CodTipoFuncionario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de funcionario.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoFuncionario', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoFuncionario', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoFuncionario', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoFuncionario] SET (LOCK_ESCALATION = TABLE)
GO

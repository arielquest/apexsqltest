SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoArma] (
		[TN_CodTipoArma]         [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Observacion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](3) NULL,
		CONSTRAINT [PK_Catalogo]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoArma])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoArma]
	ADD
	CONSTRAINT [DF_TipoArma_TN_CodTipoArma]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoArma]) FOR [TN_CodTipoArma]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipo: "TipoArma"', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoArma', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoArma', 'COLUMN', N'TN_CodTipoArma'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoArma', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Este campo va a contener la observación detallada de item que se encuentra guardado.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoArma', 'COLUMN', N'TC_Observacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoArma', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoArma', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoArma] SET (LOCK_ESCALATION = TABLE)
GO

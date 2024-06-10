SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoIdentificacion] (
		[TN_CodTipoIdentificacion]     [smallint] NOT NULL,
		[TC_Descripcion]               [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]           [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]              [datetime2](7) NULL,
		[TB_Nacional]                  [bit] NOT NULL,
		[TC_Formato]                   [varchar](25) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_EsJuridico]                [bit] NOT NULL,
		[TB_EsIgnorado]                [bit] NOT NULL,
		[CODTIPIDE]                    [varchar](1) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_TipoIdentificacion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoIdentificacion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoIdentificacion]
	ADD
	CONSTRAINT [DF_TipoIdentificacion_TB_EsJuridico]
	DEFAULT ((0)) FOR [TB_EsJuridico]
GO
ALTER TABLE [Catalogo].[TipoIdentificacion]
	ADD
	CONSTRAINT [DF__TipoIdent__EsIgn__5BCF2F07]
	DEFAULT ((0)) FOR [TB_EsIgnorado]
GO
ALTER TABLE [Catalogo].[TipoIdentificacion]
	ADD
	CONSTRAINT [DF_TipoIdentificacion_TN_CodTipoIdentificacion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoIdentificacion]) FOR [TN_CodTipoIdentificacion]
GO
ALTER TABLE [Catalogo].[TipoIdentificacion]
	ADD
	CONSTRAINT [DF_TipoIdentificacion_TB_Nacional]
	DEFAULT ((1)) FOR [TB_Nacional]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de identificación.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIdentificacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de identificación.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIdentificacion', 'COLUMN', N'TN_CodTipoIdentificacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de identificación.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIdentificacion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIdentificacion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIdentificacion', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el tipo de identificación es nacional.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIdentificacion', 'COLUMN', N'TB_Nacional'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Formato del tipo de identificación.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIdentificacion', 'COLUMN', N'TC_Formato'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Determina si es un tipo de identifcación juridica', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIdentificacion', 'COLUMN', N'TB_EsJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si este tipo de identificación permite que sea utilizado para personas ignoradas.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIdentificacion', 'COLUMN', N'TB_EsIgnorado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoIdentificacion', 'COLUMN', N'CODTIPIDE'
GO
ALTER TABLE [Catalogo].[TipoIdentificacion] SET (LOCK_ESCALATION = TABLE)
GO

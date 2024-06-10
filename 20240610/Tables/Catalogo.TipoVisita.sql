SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoVisita] (
		[TN_CodTipoVisita]       [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_TipoVisita]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoVisita])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoVisita]
	ADD
	CONSTRAINT [DF_TipoVisita_TN_CodTipoVisita]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoVisita]) FOR [TN_CodTipoVisita]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de visitas.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoVisita', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de visita.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoVisita', 'COLUMN', N'TN_CodTipoVisita'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de visita.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoVisita', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoVisita', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoVisita', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoVisita] SET (LOCK_ESCALATION = TABLE)
GO

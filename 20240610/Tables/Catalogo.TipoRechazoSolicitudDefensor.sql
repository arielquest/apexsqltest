SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoRechazoSolicitudDefensor] (
		[TN_CodTipoRechazoSolicitudDefensor]     [smallint] NOT NULL,
		[TC_Descripcion]                         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]                     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]                        [datetime2](7) NULL,
		CONSTRAINT [PK_Catalogo_TipoRechazoSolicitudDefensor]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoRechazoSolicitudDefensor])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoRechazoSolicitudDefensor]
	ADD
	CONSTRAINT [DF_Catalogo_TipoRechazoSolicitudDefensor_TN_CodTipoRechazoSolicitudDefensor]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoRechazoSolicitudDefensor]) FOR [TN_CodTipoRechazoSolicitudDefensor]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipo: "TipoRechazoSolicitudDefensor"', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoRechazoSolicitudDefensor', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoRechazoSolicitudDefensor', 'COLUMN', N'TN_CodTipoRechazoSolicitudDefensor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoRechazoSolicitudDefensor', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoRechazoSolicitudDefensor', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoRechazoSolicitudDefensor', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoRechazoSolicitudDefensor] SET (LOCK_ESCALATION = TABLE)
GO

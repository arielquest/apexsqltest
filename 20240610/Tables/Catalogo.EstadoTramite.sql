SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoTramite] (
		[TN_CodEstadoTramite]     [smallint] NOT NULL,
		[TC_Descripcion]          [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]      [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]         [datetime2](7) NULL,
		[CODESTACO]               [varchar](1) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_EstadoArchivo]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstadoTramite])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoTramite]
	ADD
	CONSTRAINT [DF_EstadoArchivo_TC_CodEstadoArchivo]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEstadoTramite]) FOR [TN_CodEstadoTramite]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de estados de trámites.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoTramite', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado del trámite.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoTramite', 'COLUMN', N'TN_CodEstadoTramite'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del estado del trámite.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoTramite', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoTramite', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoTramite', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[EstadoTramite] SET (LOCK_ESCALATION = TABLE)
GO

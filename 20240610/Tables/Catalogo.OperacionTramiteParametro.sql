SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[OperacionTramiteParametro] (
		[TN_CodOperacionTramiteParametro]     [smallint] NOT NULL,
		[TN_CodOperacionTramite]              [smallint] NOT NULL,
		[TC_Nombre]                           [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NombreEstructura]                 [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CampoIdentificador]               [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CampoMostrar]                     [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]                  [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]                     [datetime2](7) NULL,
		CONSTRAINT [PK_OperacionTramiteParametro]
		PRIMARY KEY
		CLUSTERED
		([TN_CodOperacionTramiteParametro])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[OperacionTramiteParametro]
	ADD
	CONSTRAINT [DF_OperacionTramiteParametro_TN_CodOperacionTramiteParametro]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaOperacionTramiteParametro]) FOR [TN_CodOperacionTramiteParametro]
GO
ALTER TABLE [Catalogo].[OperacionTramiteParametro]
	WITH CHECK
	ADD CONSTRAINT [FK_OperacionTramiteParametro_OperacionTramite]
	FOREIGN KEY ([TN_CodOperacionTramite]) REFERENCES [Catalogo].[OperacionTramite] ([TN_CodOperacionTramite])
ALTER TABLE [Catalogo].[OperacionTramiteParametro]
	CHECK CONSTRAINT [FK_OperacionTramiteParametro_OperacionTramite]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra los valores de cada parámetro relacionado a un tipo de operacion', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramiteParametro', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de parámetro de operación autogenerado.', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramiteParametro', 'COLUMN', N'TN_CodOperacionTramiteParametro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de operación a la cual pertenece el parámetro.', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramiteParametro', 'COLUMN', N'TN_CodOperacionTramite'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del parámetro.', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramiteParametro', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la estructura de catálogo (Tabla) del parámetro.', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramiteParametro', 'COLUMN', N'TC_NombreEstructura'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del campo llave de estructura de catálogo (Tabla) del parámetro.', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramiteParametro', 'COLUMN', N'TC_CampoIdentificador'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del campo de estructura de catálogo (Tabla) del parámetro que se quiere mostrar en pantalla al usuario.', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramiteParametro', 'COLUMN', N'TC_CampoMostrar'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramiteParametro', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramiteParametro', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[OperacionTramiteParametro] SET (LOCK_ESCALATION = TABLE)
GO

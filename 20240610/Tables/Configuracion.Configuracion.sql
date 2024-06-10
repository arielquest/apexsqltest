SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Configuracion].[Configuracion] (
		[TC_CodConfiguracion]       [varchar](27) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Nombre]                 [varchar](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]            [varchar](250) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_TipoConfiguracion]      [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaCreacion]          [datetime2](7) NOT NULL,
		[TB_EsValorGeneral]         [bit] NOT NULL,
		[TB_EsMultiple]             [bit] NOT NULL,
		[TC_NombreEstructura]       [varchar](256) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CampoIdentificador]     [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CampoMostrar]           [varchar](100) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Configuracion]
		PRIMARY KEY
		CLUSTERED
		([TC_CodConfiguracion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Configuracion].[Configuracion]
	ADD
	CONSTRAINT [CK_Configuracion_TipoConfiguracion]
	CHECK
	([TC_TipoConfiguracion]='U' OR [TC_TipoConfiguracion]='C')
GO
ALTER TABLE [Configuracion].[Configuracion]
CHECK CONSTRAINT [CK_Configuracion_TipoConfiguracion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla donde se definen las configuraciones.', 'SCHEMA', N'Configuracion', 'TABLE', N'Configuracion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la configuración.', 'SCHEMA', N'Configuracion', 'TABLE', N'Configuracion', 'COLUMN', N'TC_CodConfiguracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la configuración.', 'SCHEMA', N'Configuracion', 'TABLE', N'Configuracion', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la configuración.', 'SCHEMA', N'Configuracion', 'TABLE', N'Configuracion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de configuración [C]  - Catálogo,  [U] - Definido por el usuario.', 'SCHEMA', N'Configuracion', 'TABLE', N'Configuracion', 'COLUMN', N'TC_TipoConfiguracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha creación de la configuración.', 'SCHEMA', N'Configuracion', 'TABLE', N'Configuracion', 'COLUMN', N'TF_FechaCreacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Determina si la configuración es general o por oficina.', 'SCHEMA', N'Configuracion', 'TABLE', N'Configuracion', 'COLUMN', N'TB_EsValorGeneral'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Determina si la configuración permite múltiples valores.', 'SCHEMA', N'Configuracion', 'TABLE', N'Configuracion', 'COLUMN', N'TB_EsMultiple'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la estructura donde se emplea', 'SCHEMA', N'Configuracion', 'TABLE', N'Configuracion', 'COLUMN', N'TC_NombreEstructura'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de la estructura', 'SCHEMA', N'Configuracion', 'TABLE', N'Configuracion', 'COLUMN', N'TC_CampoIdentificador'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción que se mostrará en pantalla.', 'SCHEMA', N'Configuracion', 'TABLE', N'Configuracion', 'COLUMN', N'TC_CampoMostrar'
GO
ALTER TABLE [Configuracion].[Configuracion] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Configuracion].[PermisoFuncional] (
		[TC_CodPermiso]          [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NOT NULL,
		CONSTRAINT [PK_PermisoFuncional]
		PRIMARY KEY
		CLUSTERED
		([TC_CodPermiso])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de los permisos funcionales, que inicialmente se utilizara para poder mostrar y ocultar ciertos controles en las pantallas del sistema.', 'SCHEMA', N'Configuracion', 'TABLE', N'PermisoFuncional', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del permiso.', 'SCHEMA', N'Configuracion', 'TABLE', N'PermisoFuncional', 'COLUMN', N'TC_CodPermiso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del permiso.', 'SCHEMA', N'Configuracion', 'TABLE', N'PermisoFuncional', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Configuracion', 'TABLE', N'PermisoFuncional', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Configuracion', 'TABLE', N'PermisoFuncional', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Configuracion].[PermisoFuncional] SET (LOCK_ESCALATION = TABLE)
GO

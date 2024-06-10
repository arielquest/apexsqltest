SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoNotificacion] (
		[TN_CodEstadoNotificacion]     [tinyint] NOT NULL,
		[TC_Descripcion]               [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]           [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]              [datetime2](7) NULL,
		[CODESTNOT]                    [varchar](1) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_EstadoNotificacion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstadoNotificacion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoNotificacion]
	ADD
	CONSTRAINT [DF_EstadoNotificacion_TN_CodEstadoNotificacion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEstadoNotificacion]) FOR [TN_CodEstadoNotificacion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de estados notificación.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoNotificacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado de la notificación.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoNotificacion', 'COLUMN', N'TN_CodEstadoNotificacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del estado de la notificación.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoNotificacion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoNotificacion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoNotificacion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[EstadoNotificacion] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Sistema].[SesionUsuario] (
		[TC_Usuario]          [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]      [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Equipo]           [varchar](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Tramite]          [datetime2](7) NOT NULL,
		[TF_Sesion]           [datetime2](7) NOT NULL,
		[TF_CierreSesion]     [datetime2](7) NULL,
		[TB_Activo]           [bit] NOT NULL,
		CONSTRAINT [PK_SesionUsuario]
		PRIMARY KEY
		CLUSTERED
		([TC_Usuario], [TC_CodContexto], [TC_Equipo], [TF_Tramite])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Sistema].[SesionUsuario]
	ADD
	CONSTRAINT [DF_SesionUsuario_TB_Activo]
	DEFAULT ((1)) FOR [TB_Activo]
GO
ALTER TABLE [Sistema].[SesionUsuario]
	WITH CHECK
	ADD CONSTRAINT [FK_SesionUsuario_Contextos]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Sistema].[SesionUsuario]
	CHECK CONSTRAINT [FK_SesionUsuario_Contextos]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de las sesiones de usuarios.', 'SCHEMA', N'Sistema', 'TABLE', N'SesionUsuario', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario del sistema.', 'SCHEMA', N'Sistema', 'TABLE', N'SesionUsuario', 'COLUMN', N'TC_Usuario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto.', 'SCHEMA', N'Sistema', 'TABLE', N'SesionUsuario', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del equipo desde el que ingreso al sistema.', 'SCHEMA', N'Sistema', 'TABLE', N'SesionUsuario', 'COLUMN', N'TC_Equipo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que se realizó el trámite.', 'SCHEMA', N'Sistema', 'TABLE', N'SesionUsuario', 'COLUMN', N'TF_Tramite'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora de inicio de sesión.', 'SCHEMA', N'Sistema', 'TABLE', N'SesionUsuario', 'COLUMN', N'TF_Sesion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora de cierre de sesión.', 'SCHEMA', N'Sistema', 'TABLE', N'SesionUsuario', 'COLUMN', N'TF_CierreSesion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la sesión se encuentra activa.', 'SCHEMA', N'Sistema', 'TABLE', N'SesionUsuario', 'COLUMN', N'TB_Activo'
GO
ALTER TABLE [Sistema].[SesionUsuario] SET (LOCK_ESCALATION = TABLE)
GO

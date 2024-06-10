SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Configuracion].[PermisoFuncionalMateria] (
		[TC_CodPermiso]     [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodMateria]     [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_PermisoFuncionalMateria]
		PRIMARY KEY
		CLUSTERED
		([TC_CodPermiso], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Configuracion].[PermisoFuncionalMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_PermisoFuncionalMateria_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Configuracion].[PermisoFuncionalMateria]
	CHECK CONSTRAINT [FK_PermisoFuncionalMateria_Materia]

GO
ALTER TABLE [Configuracion].[PermisoFuncionalMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_PermisoFuncionalMateria_PermisoFuncional]
	FOREIGN KEY ([TC_CodPermiso]) REFERENCES [Configuracion].[PermisoFuncional] ([TC_CodPermiso])
ALTER TABLE [Configuracion].[PermisoFuncionalMateria]
	CHECK CONSTRAINT [FK_PermisoFuncionalMateria_PermisoFuncional]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo donde se pueda indicar si el permiso funcional esta activo por materia.', 'SCHEMA', N'Configuracion', 'TABLE', N'PermisoFuncionalMateria', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del permiso.', 'SCHEMA', N'Configuracion', 'TABLE', N'PermisoFuncionalMateria', 'COLUMN', N'TC_CodPermiso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Configuracion', 'TABLE', N'PermisoFuncionalMateria', 'COLUMN', N'TC_CodMateria'
GO
ALTER TABLE [Configuracion].[PermisoFuncionalMateria] SET (LOCK_ESCALATION = TABLE)
GO

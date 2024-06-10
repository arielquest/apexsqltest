CREATE ROLE [SIAGPJ_RolDeAplicacion] AUTHORIZATION [dbo]
GO

ALTER ROLE [SIAGPJ_RolDeAplicacion] ADD MEMBER [siagpj]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Rol para aplicación SIAGPJ', 'USER', N'SIAGPJ_RolDeAplicacion', NULL, NULL, NULL, NULL
GO

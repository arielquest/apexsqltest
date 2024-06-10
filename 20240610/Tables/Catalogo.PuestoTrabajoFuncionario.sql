SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[PuestoTrabajoFuncionario] (
		[TU_CodPuestoFuncionario]     [uniqueidentifier] NOT NULL,
		[TC_CodPuestoTrabajo]         [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]               [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]          [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]             [datetime2](7) NULL,
		CONSTRAINT [PK_PuestoTrabajoFuncionario]
		PRIMARY KEY
		CLUSTERED
		([TU_CodPuestoFuncionario])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[PuestoTrabajoFuncionario]
	ADD
	CONSTRAINT [CK_PuestoTrabajoFuncionario]
	CHECK
	([Catalogo].[FN_ValidarPuestoTrabajoFuncionario]([TU_CodPuestoFuncionario],[TC_CodPuestoTrabajo],[TC_UsuarioRed],[TF_Inicio_Vigencia],[TF_Fin_Vigencia])=(1))
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valida que no se encuentre asignado el puesto de trabajo en el rango de fechas.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajoFuncionario', 'CONSTRAINT', N'CK_PuestoTrabajoFuncionario'
GO
ALTER TABLE [Catalogo].[PuestoTrabajoFuncionario]
CHECK CONSTRAINT [CK_PuestoTrabajoFuncionario]
GO
ALTER TABLE [Catalogo].[PuestoTrabajoFuncionario]
	WITH CHECK
	ADD CONSTRAINT [FK_PuestoTrabajoFuncionario_Funcionario]
	FOREIGN KEY ([TC_UsuarioRed]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Catalogo].[PuestoTrabajoFuncionario]
	CHECK CONSTRAINT [FK_PuestoTrabajoFuncionario_Funcionario]

GO
ALTER TABLE [Catalogo].[PuestoTrabajoFuncionario]
	WITH CHECK
	ADD CONSTRAINT [FK_PuestoTrabajoFuncionario_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Catalogo].[PuestoTrabajoFuncionario]
	CHECK CONSTRAINT [FK_PuestoTrabajoFuncionario_PuestoTrabajo]

GO
ALTER TABLE [Catalogo].[PuestoTrabajoFuncionario]
	WITH CHECK
	ADD CONSTRAINT [FK_PuestoTrabajoFuncionario_PuestoTrabajoFuncionario]
	FOREIGN KEY ([TU_CodPuestoFuncionario]) REFERENCES [Catalogo].[PuestoTrabajoFuncionario] ([TU_CodPuestoFuncionario])
ALTER TABLE [Catalogo].[PuestoTrabajoFuncionario]
	CHECK CONSTRAINT [FK_PuestoTrabajoFuncionario_PuestoTrabajoFuncionario]

GO
CREATE NONCLUSTERED INDEX [IX_PuestoTrabajoFuncionario_CodPuestoTrabajoInicioVigenciaFinVigencia]
	ON [Catalogo].[PuestoTrabajoFuncionario] ([TC_CodPuestoTrabajo], [TF_Inicio_Vigencia], [TF_Fin_Vigencia])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PuestoTrabajoFuncionario_ConsultarFuncionarioPorPuestoTrabajo]
	ON [Catalogo].[PuestoTrabajoFuncionario] ([TF_Inicio_Vigencia], [TF_Fin_Vigencia])
	INCLUDE ([TC_CodPuestoTrabajo], [TC_UsuarioRed])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice creado para optimizar Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajoFuncionario', 'INDEX', N'IX_PuestoTrabajoFuncionario_ConsultarFuncionarioPorPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de puestos de trabajo asociados al funcionario.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajoFuncionario', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código único de la asociación de funcionario con puesto de trabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajoFuncionario', 'COLUMN', N'TU_CodPuestoFuncionario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajoFuncionario', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario de red del funcionario.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajoFuncionario', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajoFuncionario', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajoFuncionario', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[PuestoTrabajoFuncionario] SET (LOCK_ESCALATION = TABLE)
GO

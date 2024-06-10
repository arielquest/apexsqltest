SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[PuestoTrabajoAccesoBuzon] (
		[TN_CodPuestosTrabajoAccesoBuzon]     [int] IDENTITY(1, 1) NOT NULL,
		[TC_CodPuestoTrabajo]                 [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodPuestoTrabajoSecundario]       [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRedAsignaPermiso]          [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaRegistro]                    [datetime2](7) NOT NULL,
		CONSTRAINT [UNQDATOSUNICOS]
		UNIQUE
		NONCLUSTERED
		([TC_CodPuestoTrabajo], [TC_CodPuestoTrabajoSecundario])
		ON [PRIMARY],
		CONSTRAINT [PK_Catalogo_PuestoTrabajoAccesoBuzon]
		PRIMARY KEY
		CLUSTERED
		([TN_CodPuestosTrabajoAccesoBuzon])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[PuestoTrabajoAccesoBuzon]
	WITH CHECK
	ADD CONSTRAINT [FK_Catalogo_PuestoTrabajoAccesoBuzon_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Catalogo].[PuestoTrabajoAccesoBuzon]
	CHECK CONSTRAINT [FK_Catalogo_PuestoTrabajoAccesoBuzon_PuestoTrabajo]

GO
ALTER TABLE [Catalogo].[PuestoTrabajoAccesoBuzon]
	WITH CHECK
	ADD CONSTRAINT [FK_Catalogo_PuestoTrabajoAccesoBuzon_PuestoTrabajoSecundario]
	FOREIGN KEY ([TC_CodPuestoTrabajoSecundario]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Catalogo].[PuestoTrabajoAccesoBuzon]
	CHECK CONSTRAINT [FK_Catalogo_PuestoTrabajoAccesoBuzon_PuestoTrabajoSecundario]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico para la tabla de puesto de trabajo acceso al buzón.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajoAccesoBuzon', 'COLUMN', N'TN_CodPuestosTrabajoAccesoBuzon'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va a guardar el puesto de trabajo al cual se le asignan el permiso.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajoAccesoBuzon', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va contener el puesto de trabajo el cual tiene permiso.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajoAccesoBuzon', 'COLUMN', N'TC_CodPuestoTrabajoSecundario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va guardar el usuario que asigno el permiso al buzon de puesto de trabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajoAccesoBuzon', 'COLUMN', N'TC_UsuarioRedAsignaPermiso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Campo que va guardar la fecha cuando fue asignado el permiso al buzon de puesto de trabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuestoTrabajoAccesoBuzon', 'COLUMN', N'TF_FechaRegistro'
GO
ALTER TABLE [Catalogo].[PuestoTrabajoAccesoBuzon] SET (LOCK_ESCALATION = TABLE)
GO

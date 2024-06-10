SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[GrupoTrabajoPuesto] (
		[TN_CodGrupoTrabajo]      [smallint] NOT NULL,
		[TC_CodPuestoTrabajo]     [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]      [datetime2](7) NOT NULL,
		[TC_CodContexto]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_GrupoTrabajoPuesto]
		PRIMARY KEY
		CLUSTERED
		([TN_CodGrupoTrabajo], [TC_CodPuestoTrabajo], [TC_CodContexto])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[GrupoTrabajoPuesto]
	WITH CHECK
	ADD CONSTRAINT [FK_GrupoTrabajoPuesto_ContextoPuestoTrabajo]
	FOREIGN KEY ([TC_CodContexto], [TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[ContextoPuestoTrabajo] ([TC_CodContexto], [TC_CodPuestoTrabajo])
ALTER TABLE [Catalogo].[GrupoTrabajoPuesto]
	CHECK CONSTRAINT [FK_GrupoTrabajoPuesto_ContextoPuestoTrabajo]

GO
ALTER TABLE [Catalogo].[GrupoTrabajoPuesto]
	WITH CHECK
	ADD CONSTRAINT [FK_GrupoTrabajoPuesto_GrupoTrabajo]
	FOREIGN KEY ([TN_CodGrupoTrabajo]) REFERENCES [Catalogo].[GrupoTrabajo] ([TN_CodGrupoTrabajo])
ALTER TABLE [Catalogo].[GrupoTrabajoPuesto]
	CHECK CONSTRAINT [FK_GrupoTrabajoPuesto_GrupoTrabajo]

GO
ALTER TABLE [Catalogo].[GrupoTrabajoPuesto]
	WITH CHECK
	ADD CONSTRAINT [FK_GrupoTrabajoPuesto_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Catalogo].[GrupoTrabajoPuesto]
	CHECK CONSTRAINT [FK_GrupoTrabajoPuesto_PuestoTrabajo]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo donde se registran los grupos por puestos de trabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoTrabajoPuesto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del grupo de trabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoTrabajoPuesto', 'COLUMN', N'TN_CodGrupoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoTrabajoPuesto', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoTrabajoPuesto', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de contexto.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoTrabajoPuesto', 'COLUMN', N'TC_CodContexto'
GO
ALTER TABLE [Catalogo].[GrupoTrabajoPuesto] SET (LOCK_ESCALATION = TABLE)
GO

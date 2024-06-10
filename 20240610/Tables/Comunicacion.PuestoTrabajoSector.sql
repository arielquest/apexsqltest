SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Comunicacion].[PuestoTrabajoSector] (
		[TC_CodPuestoTrabajo]     [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodSector]            [smallint] NOT NULL,
		[TF_Inicio_Vigencia]      [datetime2](7) NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_PuestoTrabajoSector]
		PRIMARY KEY
		NONCLUSTERED
		([TC_CodPuestoTrabajo], [TN_CodSector])
	ON [PRIMARY]
) ON [ComunicacionPS] ([TF_Particion])
GO
ALTER TABLE [Comunicacion].[PuestoTrabajoSector]
	ADD
	CONSTRAINT [DF__PuestoTra__TF_Pa__58A8A999]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Comunicacion].[PuestoTrabajoSector]
	WITH CHECK
	ADD CONSTRAINT [FK_PuestoTrabajoSector_PuestoTrabajo]
	FOREIGN KEY ([TC_CodPuestoTrabajo]) REFERENCES [Catalogo].[PuestoTrabajo] ([TC_CodPuestoTrabajo])
ALTER TABLE [Comunicacion].[PuestoTrabajoSector]
	CHECK CONSTRAINT [FK_PuestoTrabajoSector_PuestoTrabajo]

GO
ALTER TABLE [Comunicacion].[PuestoTrabajoSector]
	WITH CHECK
	ADD CONSTRAINT [FK_PuestoTrabajoSector_Sector]
	FOREIGN KEY ([TN_CodSector]) REFERENCES [Comunicacion].[Sector] ([TN_CodSector])
ALTER TABLE [Comunicacion].[PuestoTrabajoSector]
	CHECK CONSTRAINT [FK_PuestoTrabajoSector_Sector]

GO
CREATE CLUSTERED INDEX [IX_Comunicacion_PuestoTrabajoSector_TF_Particion]
	ON [Comunicacion].[PuestoTrabajoSector] ([TF_Particion])
	ON [ComunicacionPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Asocia los oficiales de comunicación con los sectores de una OCJ', 'SCHEMA', N'Comunicacion', 'TABLE', N'PuestoTrabajoSector', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo del oficial de comunicación
 ', 'SCHEMA', N'Comunicacion', 'TABLE', N'PuestoTrabajoSector', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del sector', 'SCHEMA', N'Comunicacion', 'TABLE', N'PuestoTrabajoSector', 'COLUMN', N'TN_CodSector'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha en que inicia la vigencia de la asociación
 ', 'SCHEMA', N'Comunicacion', 'TABLE', N'PuestoTrabajoSector', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Comunicacion].[PuestoTrabajoSector] SET (LOCK_ESCALATION = TABLE)
GO

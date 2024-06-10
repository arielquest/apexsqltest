SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[CitaPuestoTrabajo] (
		[TU_CodConfiguracion]     [uniqueidentifier] NOT NULL,
		[TC_CodPuestoTrabajo]     [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Catalogo_CitaPuestoTrabajo]
		PRIMARY KEY
		NONCLUSTERED
		([TC_CodPuestoTrabajo], [TU_CodConfiguracion])
	ON [FG_SIAGPJ]
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la configuración de las citas de un despacho', 'SCHEMA', N'Catalogo', 'TABLE', N'CitaPuestoTrabajo', 'COLUMN', N'TU_CodConfiguracion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del puesto de trabajo', 'SCHEMA', N'Catalogo', 'TABLE', N'CitaPuestoTrabajo', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica la fecha de registro para particionar', 'SCHEMA', N'Catalogo', 'TABLE', N'CitaPuestoTrabajo', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Catalogo].[CitaPuestoTrabajo] SET (LOCK_ESCALATION = TABLE)
GO

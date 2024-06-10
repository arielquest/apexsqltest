SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[ContextoPuestoTrabajo] (
		[TC_CodContexto]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodPuestoTrabajo]     [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]      [datetime2](7) NULL,
		CONSTRAINT [PK_ContextoPuestoTrabajo]
		PRIMARY KEY
		CLUSTERED
		([TC_CodContexto], [TC_CodPuestoTrabajo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catalogo que asocia los puestos de trabajo asociados a un contexto', 'SCHEMA', N'Catalogo', 'TABLE', N'ContextoPuestoTrabajo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de contexto.', 'SCHEMA', N'Catalogo', 'TABLE', N'ContextoPuestoTrabajo', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de puesto de trabajo', 'SCHEMA', N'Catalogo', 'TABLE', N'ContextoPuestoTrabajo', 'COLUMN', N'TC_CodPuestoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'ContextoPuestoTrabajo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[ContextoPuestoTrabajo] SET (LOCK_ESCALATION = TABLE)
GO

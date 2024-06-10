SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[GrupoTrabajo] (
		[TN_CodGrupoTrabajo]     [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]         [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODGT]                  [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_GrupoTrabajo]
		PRIMARY KEY
		CLUSTERED
		([TN_CodGrupoTrabajo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[GrupoTrabajo]
	ADD
	CONSTRAINT [DF_GrupoTrabajo_TN_CodGrupoTrabajo]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaGrupoTrabajo]) FOR [TN_CodGrupoTrabajo]
GO
ALTER TABLE [Catalogo].[GrupoTrabajo]
	WITH CHECK
	ADD CONSTRAINT [FK_GrupoTrabajo_Contextos]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Catalogo].[GrupoTrabajo]
	CHECK CONSTRAINT [FK_GrupoTrabajo_Contextos]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de grupos de trabajo de la oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoTrabajo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del grupo de trabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoTrabajo', 'COLUMN', N'TN_CodGrupoTrabajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del grupo de trabajo.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoTrabajo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de contexto.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoTrabajo', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoTrabajo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoTrabajo', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoTrabajo', 'COLUMN', N'CODGT'
GO
ALTER TABLE [Catalogo].[GrupoTrabajo] SET (LOCK_ESCALATION = TABLE)
GO

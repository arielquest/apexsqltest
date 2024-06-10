SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[GrupoEncadenamientoTramite] (
		[TU_CodGrupoEncadenamientoTramite]          [uniqueidentifier] NOT NULL,
		[TU_CodGrupoEncadenamientoTramitePadre]     [uniqueidentifier] NULL,
		[TC_Nombre]                                 [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]                            [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]                        [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]                           [datetime2](7) NULL,
		[TF_Actualizacion]                          [datetime2](7) NOT NULL,
		CONSTRAINT [PK_GrupoEncadenamientoTramite]
		PRIMARY KEY
		CLUSTERED
		([TU_CodGrupoEncadenamientoTramite])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[GrupoEncadenamientoTramite]
	ADD
	CONSTRAINT [DF_GrupoEncadenamientoTramite_TU_CodGrupoEncadenamientoTramite]
	DEFAULT (newid()) FOR [TU_CodGrupoEncadenamientoTramite]
GO
ALTER TABLE [Catalogo].[GrupoEncadenamientoTramite]
	ADD
	CONSTRAINT [DF_GrupoEncadenamientoTramite_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo donde se definen los grupos de los encadenamietos de trámites.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoEncadenamientoTramite', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del grupo de encadenamiento (autogenerado)', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoEncadenamientoTramite', 'COLUMN', N'TU_CodGrupoEncadenamientoTramite'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del grupo de encadenamiento padre.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoEncadenamientoTramite', 'COLUMN', N'TU_CodGrupoEncadenamientoTramitePadre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del encadenamiento de tramite que se mostrará en pantalla.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoEncadenamientoTramite', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del grupo de encadenamiento de tramite que se mostrará en la autoayuda.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoEncadenamientoTramite', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoEncadenamientoTramite', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoEncadenamientoTramite', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización del grupo o subgrupo.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoEncadenamientoTramite', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Catalogo].[GrupoEncadenamientoTramite] SET (LOCK_ESCALATION = TABLE)
GO

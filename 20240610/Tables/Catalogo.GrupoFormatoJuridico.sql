SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[GrupoFormatoJuridico] (
		[TN_CodGrupoFormatoJuridico]          [smallint] NOT NULL,
		[TN_CodGrupoFormatoJuridicoPadre]     [smallint] NULL,
		[TC_Nombre]                           [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]                      [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Creado]                           [datetime2](7) NOT NULL,
		[TF_Inicio_Vigencia]                  [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]                     [datetime2](7) NULL,
		[TN_Ordenamiento]                     [smallint] NULL,
		[CODDESCR]                            [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_GrupoFormatoJuridico]
		PRIMARY KEY
		CLUSTERED
		([TN_CodGrupoFormatoJuridico])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[GrupoFormatoJuridico]
	ADD
	CONSTRAINT [DF_GrupoFormatoJuridico_TN_CodGrupoFormatoJuridico]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaGrupoFormatoJuridico]) FOR [TN_CodGrupoFormatoJuridico]
GO
ALTER TABLE [Catalogo].[GrupoFormatoJuridico]
	ADD
	CONSTRAINT [DF_GrupoFormatoJuridico_TF_Creado]
	DEFAULT (getdate()) FOR [TF_Creado]
GO
ALTER TABLE [Catalogo].[GrupoFormatoJuridico]
	WITH CHECK
	ADD CONSTRAINT [FK_GrupoFormatoJuridico_GrupoFormatoJuridico]
	FOREIGN KEY ([TN_CodGrupoFormatoJuridicoPadre]) REFERENCES [Catalogo].[GrupoFormatoJuridico] ([TN_CodGrupoFormatoJuridico])
ALTER TABLE [Catalogo].[GrupoFormatoJuridico]
	CHECK CONSTRAINT [FK_GrupoFormatoJuridico_GrupoFormatoJuridico]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo donde se definen los grupos de los formatos jurídicos.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoFormatoJuridico', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del grupo de plantilla de formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoFormatoJuridico', 'COLUMN', N'TN_CodGrupoFormatoJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del grupo de plantilla de formato jurídico al que pertenece el grupo.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoFormatoJuridico', 'COLUMN', N'TN_CodGrupoFormatoJuridicoPadre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del formato jurídico que se mostrará en pantalla.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoFormatoJuridico', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del grupo de formato jurídico que se mostrará en la autoayuda.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoFormatoJuridico', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación del grupo o subgrupo', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoFormatoJuridico', 'COLUMN', N'TF_Creado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoFormatoJuridico', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoFormatoJuridico', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Orden de visualización según el proceso judicial, esto es definido por Normalización.', 'SCHEMA', N'Catalogo', 'TABLE', N'GrupoFormatoJuridico', 'COLUMN', N'TN_Ordenamiento'
GO
ALTER TABLE [Catalogo].[GrupoFormatoJuridico] SET (LOCK_ESCALATION = TABLE)
GO

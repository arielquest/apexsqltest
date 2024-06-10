SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[FormatoJuridico] (
		[TC_CodFormatoJuridico]          [varchar](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Categorizacion]              [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]                 [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]             [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]                [datetime2](7) NULL,
		[TN_CodGrupoFormatoJuridico]     [smallint] NOT NULL,
		[TU_IDArchivoFSActual]           [uniqueidentifier] NOT NULL,
		[TU_IDArchivoFSVersionado]       [uniqueidentifier] NULL,
		[TC_Nombre]                      [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]                  [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Creado]                      [datetime2](7) NOT NULL,
		[TB_EjecucionMasiva]             [bit] NOT NULL,
		[TB_Notifica]                    [bit] NOT NULL,
		[TN_Ordenamiento]                [smallint] NULL,
		[TF_Actualizacion]               [datetime2](7) NOT NULL,
		[TB_DocumentoSinExpediente]      [bit] NOT NULL,
		[CODTRAM]                        [varchar](12) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_GenerarVotoAutomatico]       [bit] NOT NULL,
		[TB_PaseFallo]                   [bit] NOT NULL,
		CONSTRAINT [PK_Catalogo_Plantilla]
		PRIMARY KEY
		CLUSTERED
		([TC_CodFormatoJuridico])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[FormatoJuridico]
	ADD
	CONSTRAINT [CK_FormatoJuridicoCategorizacion]
	CHECK
	([TC_Categorizacion]='O' OR [TC_Categorizacion]='S' OR [TC_Categorizacion]='R')
GO
EXEC sp_addextendedproperty N'MS_Description', N'Restricción para el tipo de valor que recibe el campo TC_Categorizacion, sólo acepta valores ''O'' = Oficio, ''S'' = Sentencia, ''R'' =  Resolución.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'CONSTRAINT', N'CK_FormatoJuridicoCategorizacion'
GO
ALTER TABLE [Catalogo].[FormatoJuridico]
CHECK CONSTRAINT [CK_FormatoJuridicoCategorizacion]
GO
ALTER TABLE [Catalogo].[FormatoJuridico]
	ADD
	CONSTRAINT [DF_Catalogo.Plantilla_TN_CodPlantilla]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaPlantilla]) FOR [TC_CodFormatoJuridico]
GO
ALTER TABLE [Catalogo].[FormatoJuridico]
	ADD
	CONSTRAINT [DF_FormatoJuridico_TF_Creado]
	DEFAULT (getdate()) FOR [TF_Creado]
GO
ALTER TABLE [Catalogo].[FormatoJuridico]
	ADD
	CONSTRAINT [DF_FormatoJuridico_TB_EjecucionMasiva]
	DEFAULT ((0)) FOR [TB_EjecucionMasiva]
GO
ALTER TABLE [Catalogo].[FormatoJuridico]
	ADD
	CONSTRAINT [DF_FormatoJuridico_TB_Notifica]
	DEFAULT ((0)) FOR [TB_Notifica]
GO
ALTER TABLE [Catalogo].[FormatoJuridico]
	ADD
	CONSTRAINT [DF_FormatoJuridico_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Catalogo].[FormatoJuridico]
	ADD
	CONSTRAINT [DF__FormatoJu__TB_Do__43CD8844]
	DEFAULT ((0)) FOR [TB_DocumentoSinExpediente]
GO
ALTER TABLE [Catalogo].[FormatoJuridico]
	ADD
	CONSTRAINT [DF__FormatoJu__TB_Ge__56970F4C]
	DEFAULT ((0)) FOR [TB_GenerarVotoAutomatico]
GO
ALTER TABLE [Catalogo].[FormatoJuridico]
	ADD
	CONSTRAINT [DF_FormatoJuridico_TB_PaseFallo]
	DEFAULT ((0)) FOR [TB_PaseFallo]
GO
ALTER TABLE [Catalogo].[FormatoJuridico]
	WITH CHECK
	ADD CONSTRAINT [FK_FormatoJuridico_GrupoFormatoJuridico]
	FOREIGN KEY ([TN_CodGrupoFormatoJuridico]) REFERENCES [Catalogo].[GrupoFormatoJuridico] ([TN_CodGrupoFormatoJuridico])
ALTER TABLE [Catalogo].[FormatoJuridico]
	CHECK CONSTRAINT [FK_FormatoJuridico_GrupoFormatoJuridico]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de formatos jurídicos, también conocidos como plantillas o machotes.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la plantilla de formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TC_CodFormatoJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor que identifica la categoría del dormato jurídico, sólo acepta valores ''O'' = Oficio, ''S'' = Sentencia, ''R'' =  Resolución.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TC_Categorizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la plantilla de formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del grupo de plantilla de formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TN_CodGrupoFormatoJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del archivo en la base de datos de FileStream.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TU_IDArchivoFSActual'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del archivo en la base de datos de FileStream.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TU_IDArchivoFSVersionado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del formato jurídico', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que creó el documento jurídico', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de creación del formato jurídico', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TF_Creado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el formato es de ejecución masiva', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TB_EjecucionMasiva'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el formato jurídico se puede notificar', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TB_Notifica'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Orden de visualización según el proceso judicial, esto es definido por Normalización.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TN_Ordenamiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización para SIGMA', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Permite señalar si el formato jurídico se utiliza para generar documentos dentro de expedientes (valor False) o para crear documentos sin expediente (valor True).', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TB_DocumentoSinExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'CODTRAM'
GO
EXEC sp_addextendedproperty N'Description', N'Indicador para determinar si el voto se genera automatico o no. Entonces 1 es generado automatico y 0 no lo hace', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TB_GenerarVotoAutomatico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el formato juridico utiliza la funcionalidad de pase a fallo en los expedientes o legajos 1 = SI, 0 = NO', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridico', 'COLUMN', N'TB_PaseFallo'
GO
ALTER TABLE [Catalogo].[FormatoJuridico] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[OperacionTramite] (
		[TN_CodOperacionTramite]     [smallint] NOT NULL,
		[TC_Nombre]                  [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]             [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]         [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]            [datetime2](7) NULL,
		[TN_Pantalla]                [int] NOT NULL,
		CONSTRAINT [PK_OperacionTramite]
		PRIMARY KEY
		CLUSTERED
		([TN_CodOperacionTramite])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[OperacionTramite]
	ADD
	CONSTRAINT [CK_OperacionTramite_Pantalla]
	CHECK
	([TN_Pantalla]=(1) OR [TN_Pantalla]=(2) OR [TN_Pantalla]=(3) OR [TN_Pantalla]=(4) OR [TN_Pantalla]=(5))
GO
ALTER TABLE [Catalogo].[OperacionTramite]
CHECK CONSTRAINT [CK_OperacionTramite_Pantalla]
GO
ALTER TABLE [Catalogo].[OperacionTramite]
	ADD
	CONSTRAINT [DF_OperacionTramite_TN_CodOperacionTramite]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaOperacionTramite]) FOR [TN_CodOperacionTramite]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra los datos de los tipos de operaciones que se podrían incluir en un encadenamiento de formatos jurídicos y operaciones', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramite', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de operación autogenerado.', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramite', 'COLUMN', N'TN_CodOperacionTramite'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la operación.', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramite', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción sobre la operación.', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramite', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramite', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramite', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Pantalla la cual se ejecutará según la operación:
1=AsignarDocumentosFirmar
2=AsignarTarea
3=GenerarDatosResolucion
4=ModificarEstadoFase
5=ModificarUbicacion', 'SCHEMA', N'Catalogo', 'TABLE', N'OperacionTramite', 'COLUMN', N'TN_Pantalla'
GO
ALTER TABLE [Catalogo].[OperacionTramite] SET (LOCK_ESCALATION = TABLE)
GO

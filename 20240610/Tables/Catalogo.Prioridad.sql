SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Prioridad] (
		[TN_CodPrioridad]        [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](3) NULL,
		[TC_ColorAlerta]         [varchar](10) COLLATE Modern_Spanish_CI_AS NULL,
		[CODPRI]                 [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_PRIORIDAD]
		PRIMARY KEY
		CLUSTERED
		([TN_CodPrioridad])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Prioridad]
	ADD
	CONSTRAINT [DF_Prioridad_TC_CodPrioridad]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaPrioridad]) FOR [TN_CodPrioridad]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de prioridades de los expedientes.', 'SCHEMA', N'Catalogo', 'TABLE', N'Prioridad', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la prioridad.', 'SCHEMA', N'Catalogo', 'TABLE', N'Prioridad', 'COLUMN', N'TN_CodPrioridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la prioridad.', 'SCHEMA', N'Catalogo', 'TABLE', N'Prioridad', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Prioridad', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Prioridad', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del color de la alerta asociada a la prioridad.', 'SCHEMA', N'Catalogo', 'TABLE', N'Prioridad', 'COLUMN', N'TC_ColorAlerta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Prioridad', 'COLUMN', N'CODPRI'
GO
ALTER TABLE [Catalogo].[Prioridad] SET (LOCK_ESCALATION = TABLE)
GO

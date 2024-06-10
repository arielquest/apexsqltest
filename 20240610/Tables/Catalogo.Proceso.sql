SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Proceso] (
		[TN_CodProceso]          [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](3) NULL,
		[CODPRO]                 [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Procedimiento]
		PRIMARY KEY
		CLUSTERED
		([TN_CodProceso])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Proceso]
	ADD
	CONSTRAINT [DF_Proceso_TN_CodProceso]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaProceso]) FOR [TN_CodProceso]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de procesos.', 'SCHEMA', N'Catalogo', 'TABLE', N'Proceso', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del proceso.', 'SCHEMA', N'Catalogo', 'TABLE', N'Proceso', 'COLUMN', N'TN_CodProceso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del proceso.', 'SCHEMA', N'Catalogo', 'TABLE', N'Proceso', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Proceso', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Proceso', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Proceso', 'COLUMN', N'CODPRO'
GO
ALTER TABLE [Catalogo].[Proceso] SET (LOCK_ESCALATION = TABLE)
GO

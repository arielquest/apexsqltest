SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Clase] (
		[TN_CodClase]            [int] NOT NULL,
		[TC_Descripcion]         [varchar](200) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODCLAS]                [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_ClasesAsunto]
		PRIMARY KEY
		CLUSTERED
		([TN_CodClase])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Clase]
	ADD
	CONSTRAINT [DF_Clase_TN_CodClase]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaClase]) FOR [TN_CodClase]
GO
CREATE NONCLUSTERED INDEX [_dta_index_Clase_5_1932546664__K1_2]
	ON [Catalogo].[Clase] ([TN_CodClase])
	INCLUDE ([TC_Descripcion])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de clases.', 'SCHEMA', N'Catalogo', 'TABLE', N'Clase', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la clase.', 'SCHEMA', N'Catalogo', 'TABLE', N'Clase', 'COLUMN', N'TN_CodClase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la clase.', 'SCHEMA', N'Catalogo', 'TABLE', N'Clase', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Clase', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Clase', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Clase', 'COLUMN', N'CODCLAS'
GO
ALTER TABLE [Catalogo].[Clase] SET (LOCK_ESCALATION = TABLE)
GO

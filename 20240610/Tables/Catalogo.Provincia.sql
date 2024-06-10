SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Provincia] (
		[TN_CodProvincia]        [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODPROV]                [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Provincia]
		PRIMARY KEY
		CLUSTERED
		([TN_CodProvincia])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Provincia]
	ADD
	CONSTRAINT [DF_Provincia_TN_CodProvincia]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaProvincia]) FOR [TN_CodProvincia]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de provincias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Provincia', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la provincia.', 'SCHEMA', N'Catalogo', 'TABLE', N'Provincia', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la provincia.', 'SCHEMA', N'Catalogo', 'TABLE', N'Provincia', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Provincia', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Provincia', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Provincia', 'COLUMN', N'CODPROV'
GO
ALTER TABLE [Catalogo].[Provincia] SET (LOCK_ESCALATION = TABLE)
GO

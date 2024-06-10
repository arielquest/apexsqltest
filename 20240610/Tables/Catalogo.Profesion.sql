SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Profesion] (
		[TN_CodProfesion]        [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODPROINT]              [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Profesion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodProfesion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Profesion]
	ADD
	CONSTRAINT [DF_Profesion_TN_CodProfesion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaProfesion]) FOR [TN_CodProfesion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de profesiones.', 'SCHEMA', N'Catalogo', 'TABLE', N'Profesion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la profesión.', 'SCHEMA', N'Catalogo', 'TABLE', N'Profesion', 'COLUMN', N'TN_CodProfesion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la profesión.', 'SCHEMA', N'Catalogo', 'TABLE', N'Profesion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Profesion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Profesion', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Profesion', 'COLUMN', N'CODPROINT'
GO
ALTER TABLE [Catalogo].[Profesion] SET (LOCK_ESCALATION = TABLE)
GO

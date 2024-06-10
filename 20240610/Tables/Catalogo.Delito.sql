SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Delito] (
		[TN_CodDelito]              [int] NOT NULL,
		[TN_CodCategoriaDelito]     [int] NOT NULL,
		[TC_Descripcion]            [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]           [datetime2](7) NULL,
		[CODDEL]                    [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Delito]
		PRIMARY KEY
		CLUSTERED
		([TN_CodDelito])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Delito]
	ADD
	CONSTRAINT [DF_Delito_TN_CodDelito]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaDelito]) FOR [TN_CodDelito]
GO
ALTER TABLE [Catalogo].[Delito]
	WITH CHECK
	ADD CONSTRAINT [FK_Delito_CategoriaDelito]
	FOREIGN KEY ([TN_CodCategoriaDelito]) REFERENCES [Catalogo].[CategoriaDelito] ([TN_CodCategoriaDelito])
ALTER TABLE [Catalogo].[Delito]
	CHECK CONSTRAINT [FK_Delito_CategoriaDelito]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de delitos.', 'SCHEMA', N'Catalogo', 'TABLE', N'Delito', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del delito.', 'SCHEMA', N'Catalogo', 'TABLE', N'Delito', 'COLUMN', N'TN_CodDelito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la categoría del delito.', 'SCHEMA', N'Catalogo', 'TABLE', N'Delito', 'COLUMN', N'TN_CodCategoriaDelito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del delito.', 'SCHEMA', N'Catalogo', 'TABLE', N'Delito', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Delito', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Delito', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Delito', 'COLUMN', N'CODDEL'
GO
ALTER TABLE [Catalogo].[Delito] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[ClaseAsunto] (
		[TN_CodClaseAsunto]      [int] NOT NULL,
		[TC_Descripcion]         [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](3) NULL,
		[TN_CodAsunto]           [int] NULL,
		[CODCLAS]                [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_ClaseAsunto]
		PRIMARY KEY
		CLUSTERED
		([TN_CodClaseAsunto])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[ClaseAsunto]
	ADD
	CONSTRAINT [DF_ClaseAsunto_TN_CodClaseAsunto]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaClaseAsunto]) FOR [TN_CodClaseAsunto]
GO
ALTER TABLE [Catalogo].[ClaseAsunto]
	WITH CHECK
	ADD CONSTRAINT [FK_ClaseAsunto_Asunto]
	FOREIGN KEY ([TN_CodAsunto]) REFERENCES [Catalogo].[Asunto] ([TN_CodAsunto])
ALTER TABLE [Catalogo].[ClaseAsunto]
	CHECK CONSTRAINT [FK_ClaseAsunto_Asunto]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de clases de asunto.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsunto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la clase de asunto.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsunto', 'COLUMN', N'TN_CodClaseAsunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la clase de asunto.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsunto', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsunto', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsunto', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de asunto de la clase de asunto', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsunto', 'COLUMN', N'TN_CodAsunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'ClaseAsunto', 'COLUMN', N'CODCLAS'
GO
ALTER TABLE [Catalogo].[ClaseAsunto] SET (LOCK_ESCALATION = TABLE)
GO

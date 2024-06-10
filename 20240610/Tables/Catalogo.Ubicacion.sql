SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Ubicacion] (
		[TN_CodUbicacion]        [int] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](3) NULL,
		[TC_CodOficina]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[CODUBI]                 [varchar](11) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [KUBI$KUBI_PK]
		PRIMARY KEY
		CLUSTERED
		([TN_CodUbicacion])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[Ubicacion]
	ADD
	CONSTRAINT [DF_Ubicacion_TN_CodUbicacion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaUbicacion]) FOR [TN_CodUbicacion]
GO
ALTER TABLE [Catalogo].[Ubicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Ubicacion_Oficina]
	FOREIGN KEY ([TC_CodOficina]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Catalogo].[Ubicacion]
	CHECK CONSTRAINT [FK_Ubicacion_Oficina]

GO
ALTER TABLE [Catalogo].[Ubicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Ubicacion_Ubicacion]
	FOREIGN KEY ([TN_CodUbicacion]) REFERENCES [Catalogo].[Ubicacion] ([TN_CodUbicacion])
ALTER TABLE [Catalogo].[Ubicacion]
	CHECK CONSTRAINT [FK_Ubicacion_Ubicacion]

GO
CREATE NONCLUSTERED INDEX [IDX_por_Carga_1087]
	ON [Catalogo].[Ubicacion] ([TF_Inicio_Vigencia], [TF_Fin_Vigencia])
	INCLUDE ([TN_CodUbicacion], [TC_Descripcion], [TC_CodOficina])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de ubicaciones.', 'SCHEMA', N'Catalogo', 'TABLE', N'Ubicacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de ubicación.', 'SCHEMA', N'Catalogo', 'TABLE', N'Ubicacion', 'COLUMN', N'TN_CodUbicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la ubicación.', 'SCHEMA', N'Catalogo', 'TABLE', N'Ubicacion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Ubicacion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Ubicacion', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'Ubicacion', 'COLUMN', N'TC_CodOficina'
GO
ALTER TABLE [Catalogo].[Ubicacion] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Barrio] (
		[TN_CodProvincia]        [smallint] NOT NULL,
		[TN_CodCanton]           [smallint] NOT NULL,
		[TN_CodDistrito]         [smallint] NOT NULL,
		[TN_CodBarrio]           [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TG_UbicacionPunto]      [geography] NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODPROV]                [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		[CODCANTON]              [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		[CODDISTRITO]            [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		[CODBARRIO]              [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Barrio]
		PRIMARY KEY
		CLUSTERED
		([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito], [TN_CodBarrio])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[Barrio]
	ADD
	CONSTRAINT [DF_Barrio_TN_CodBarrio]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaBarrio]) FOR [TN_CodBarrio]
GO
ALTER TABLE [Catalogo].[Barrio]
	WITH CHECK
	ADD CONSTRAINT [FK_Barrio_Distrito]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito]) REFERENCES [Catalogo].[Distrito] ([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito])
ALTER TABLE [Catalogo].[Barrio]
	CHECK CONSTRAINT [FK_Barrio_Distrito]

GO
CREATE NONCLUSTERED INDEX [INDEX_CodBarrio_Descripcion]
	ON [Catalogo].[Barrio] ([TN_CodBarrio])
	INCLUDE ([TC_Descripcion])
	ON [FG_SIAGPJ]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de barrios.', 'SCHEMA', N'Catalogo', 'TABLE', N'Barrio', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la provincia.', 'SCHEMA', N'Catalogo', 'TABLE', N'Barrio', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cantón.', 'SCHEMA', N'Catalogo', 'TABLE', N'Barrio', 'COLUMN', N'TN_CodCanton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del distrito.', 'SCHEMA', N'Catalogo', 'TABLE', N'Barrio', 'COLUMN', N'TN_CodDistrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del barrio.', 'SCHEMA', N'Catalogo', 'TABLE', N'Barrio', 'COLUMN', N'TN_CodBarrio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del barrio.', 'SCHEMA', N'Catalogo', 'TABLE', N'Barrio', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica la ubicación central del barrio en el mapa.', 'SCHEMA', N'Catalogo', 'TABLE', N'Barrio', 'COLUMN', N'TG_UbicacionPunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Barrio', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Barrio', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Barrio] SET (LOCK_ESCALATION = TABLE)
GO

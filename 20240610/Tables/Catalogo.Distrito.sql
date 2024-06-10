SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Distrito] (
		[TN_CodProvincia]        [smallint] NOT NULL,
		[TN_CodCanton]           [smallint] NOT NULL,
		[TN_CodDistrito]         [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TG_UbicacionPunto]      [geography] NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODPROV]                [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		[CODCANTON]              [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		[CODDISTRITO]            [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Distrito]
		PRIMARY KEY
		CLUSTERED
		([TN_CodProvincia], [TN_CodCanton], [TN_CodDistrito])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[Distrito]
	ADD
	CONSTRAINT [DF_Distrito_TN_CodDistrito]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaDistrito]) FOR [TN_CodDistrito]
GO
ALTER TABLE [Catalogo].[Distrito]
	WITH CHECK
	ADD CONSTRAINT [FK_Distrito_Canton]
	FOREIGN KEY ([TN_CodProvincia], [TN_CodCanton]) REFERENCES [Catalogo].[Canton] ([TN_CodProvincia], [TN_CodCanton])
ALTER TABLE [Catalogo].[Distrito]
	CHECK CONSTRAINT [FK_Distrito_Canton]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de distritos.', 'SCHEMA', N'Catalogo', 'TABLE', N'Distrito', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la provincia.', 'SCHEMA', N'Catalogo', 'TABLE', N'Distrito', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cantón.', 'SCHEMA', N'Catalogo', 'TABLE', N'Distrito', 'COLUMN', N'TN_CodCanton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del distrito.', 'SCHEMA', N'Catalogo', 'TABLE', N'Distrito', 'COLUMN', N'TN_CodDistrito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del distrito.', 'SCHEMA', N'Catalogo', 'TABLE', N'Distrito', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica la ubicación central del distrito en el mapa.', 'SCHEMA', N'Catalogo', 'TABLE', N'Distrito', 'COLUMN', N'TG_UbicacionPunto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Distrito', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Distrito', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Distrito] SET (LOCK_ESCALATION = TABLE)
GO

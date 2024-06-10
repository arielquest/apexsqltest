SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EtiquetaPredefinida] (
		[TN_CodEtiquetaPredefinida]     [smallint] NOT NULL,
		[TC_Descripcion]                [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]            [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]               [datetime2](3) NULL,
		[IDETIQUETA]                    [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Catalogo_EtiquetaPredefinida]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEtiquetaPredefinida])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EtiquetaPredefinida]
	ADD
	CONSTRAINT [DF_Catalogo_EtiquetaPredefinida_TN_CodEtiquetaPredefinida]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEtiquetaPredefinida]) FOR [TN_CodEtiquetaPredefinida]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipo: "EtiquetaPredefinida"', 'SCHEMA', N'Catalogo', 'TABLE', N'EtiquetaPredefinida', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'EtiquetaPredefinida', 'COLUMN', N'TN_CodEtiquetaPredefinida'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'EtiquetaPredefinida', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EtiquetaPredefinida', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EtiquetaPredefinida', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[EtiquetaPredefinida] SET (LOCK_ESCALATION = TABLE)
GO

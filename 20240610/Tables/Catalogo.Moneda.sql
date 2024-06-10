SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Moneda] (
		[TN_CodMoneda]           [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODMON]                 [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_TSIAG_C_Moneda]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodMoneda])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[Moneda]
	ADD
	CONSTRAINT [DF_Moneda_TN_CodMoneda]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaMoneda]) FOR [TN_CodMoneda]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de monedas.', 'SCHEMA', N'Catalogo', 'TABLE', N'Moneda', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la moneda.', 'SCHEMA', N'Catalogo', 'TABLE', N'Moneda', 'COLUMN', N'TN_CodMoneda'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la moneda.', 'SCHEMA', N'Catalogo', 'TABLE', N'Moneda', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Moneda', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Moneda', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Moneda', 'COLUMN', N'CODMON'
GO
ALTER TABLE [Catalogo].[Moneda] SET (LOCK_ESCALATION = TABLE)
GO

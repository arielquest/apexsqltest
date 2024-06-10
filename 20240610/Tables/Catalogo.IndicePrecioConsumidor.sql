SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Catalogo].[IndicePrecioConsumidor] (
		[TN_Codigo]     [int] NOT NULL,
		[TN_Valor]      [decimal](18, 15) NOT NULL,
		[TN_Mes]        [smallint] NOT NULL,
		[TN_Anno]       [smallint] NOT NULL,
		CONSTRAINT [PK_IndicePrecioConsumidor]
		PRIMARY KEY
		CLUSTERED
		([TN_Codigo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[IndicePrecioConsumidor]
	ADD
	CONSTRAINT [DF_IndicePrecioConsumidor_TN_Codigo]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaIndicePrecioConsumidor]) FOR [TN_Codigo]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene los índices de precio al consumidor para el cálculo de indexación', 'SCHEMA', N'Catalogo', 'TABLE', N'IndicePrecioConsumidor', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del IPC', 'SCHEMA', N'Catalogo', 'TABLE', N'IndicePrecioConsumidor', 'COLUMN', N'TN_Codigo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor del IPC', 'SCHEMA', N'Catalogo', 'TABLE', N'IndicePrecioConsumidor', 'COLUMN', N'TN_Valor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Mes, comprendido entre 1 y 12', 'SCHEMA', N'Catalogo', 'TABLE', N'IndicePrecioConsumidor', 'COLUMN', N'TN_Mes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Año, 4 dígitos', 'SCHEMA', N'Catalogo', 'TABLE', N'IndicePrecioConsumidor', 'COLUMN', N'TN_Anno'
GO
ALTER TABLE [Catalogo].[IndicePrecioConsumidor] SET (LOCK_ESCALATION = TABLE)
GO

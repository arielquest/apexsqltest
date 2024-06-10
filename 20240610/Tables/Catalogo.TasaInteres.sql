SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TasaInteres] (
		[TN_CodigoTasaInteres]     [uniqueidentifier] NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](7) NULL,
		[TF_Fin_Vigencia]          [datetime2](7) NOT NULL,
		[TN_Valor]                 [decimal](8, 5) NOT NULL,
		[TC_CodigoBanco]           [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodMoneda]             [smallint] NOT NULL,
		CONSTRAINT [PK_TasaInteres]
		PRIMARY KEY
		CLUSTERED
		([TN_CodigoTasaInteres])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TasaInteres]
	WITH CHECK
	ADD CONSTRAINT [FK_TasaInteres_Banco]
	FOREIGN KEY ([TC_CodigoBanco]) REFERENCES [Catalogo].[Banco] ([TC_CodigoBanco])
ALTER TABLE [Catalogo].[TasaInteres]
	CHECK CONSTRAINT [FK_TasaInteres_Banco]

GO
ALTER TABLE [Catalogo].[TasaInteres]
	WITH CHECK
	ADD CONSTRAINT [FK_TasaInteres_Moneda]
	FOREIGN KEY ([TN_CodMoneda]) REFERENCES [Catalogo].[Moneda] ([TN_CodMoneda])
ALTER TABLE [Catalogo].[TasaInteres]
	CHECK CONSTRAINT [FK_TasaInteres_Moneda]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene las tasas de interés', 'SCHEMA', N'Catalogo', 'TABLE', N'TasaInteres', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tasa de interés', 'SCHEMA', N'Catalogo', 'TABLE', N'TasaInteres', 'COLUMN', N'TN_CodigoTasaInteres'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha inicio de vigencia Tasa de Interés', 'SCHEMA', N'Catalogo', 'TABLE', N'TasaInteres', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha fin de vigencia Tasa de Interés', 'SCHEMA', N'Catalogo', 'TABLE', N'TasaInteres', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor de la tasa de interés', 'SCHEMA', N'Catalogo', 'TABLE', N'TasaInteres', 'COLUMN', N'TN_Valor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de banco de la tasa de interés', 'SCHEMA', N'Catalogo', 'TABLE', N'TasaInteres', 'COLUMN', N'TC_CodigoBanco'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de moneda para la tasa de interés', 'SCHEMA', N'Catalogo', 'TABLE', N'TasaInteres', 'COLUMN', N'TN_CodMoneda'
GO
ALTER TABLE [Catalogo].[TasaInteres] SET (LOCK_ESCALATION = TABLE)
GO

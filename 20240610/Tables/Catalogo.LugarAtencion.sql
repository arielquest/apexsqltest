SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[LugarAtencion] (
		[TN_CodLugarAtencion]     [smallint] NOT NULL,
		[TC_Descripcion]          [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodProvincia]         [smallint] NOT NULL,
		[TF_Inicio_Vigencia]      [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]         [datetime2](7) NULL,
		[CODATEN]                 [varchar](12) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_LugarAtencion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodLugarAtencion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[LugarAtencion]
	ADD
	CONSTRAINT [DF_LugarAtencion_TN_CodLugarAtencion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaLugarAtencion]) FOR [TN_CodLugarAtencion]
GO
ALTER TABLE [Catalogo].[LugarAtencion]
	WITH CHECK
	ADD CONSTRAINT [FK_LugarAtencion_Provincia]
	FOREIGN KEY ([TN_CodProvincia]) REFERENCES [Catalogo].[Provincia] ([TN_CodProvincia])
ALTER TABLE [Catalogo].[LugarAtencion]
	CHECK CONSTRAINT [FK_LugarAtencion_Provincia]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de los lugares de atención a la victima.', 'SCHEMA', N'Catalogo', 'TABLE', N'LugarAtencion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del lugar de atención de la victima.', 'SCHEMA', N'Catalogo', 'TABLE', N'LugarAtencion', 'COLUMN', N'TN_CodLugarAtencion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del lugar de atención a la victima.', 'SCHEMA', N'Catalogo', 'TABLE', N'LugarAtencion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la provincia.', 'SCHEMA', N'Catalogo', 'TABLE', N'LugarAtencion', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'LugarAtencion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'LugarAtencion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[LugarAtencion] SET (LOCK_ESCALATION = TABLE)
GO

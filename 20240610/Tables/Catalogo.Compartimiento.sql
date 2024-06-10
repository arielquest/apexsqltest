SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Compartimiento] (
		[TN_CodCompartimiento]     [smallint] NOT NULL,
		[TC_Descripcion]           [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodEstante]            [smallint] NOT NULL,
		[TC_Observacion]           [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]          [datetime2](3) NULL,
		CONSTRAINT [PK_Catalogo_Compartimiento]
		PRIMARY KEY
		CLUSTERED
		([TN_CodCompartimiento])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Compartimiento]
	ADD
	CONSTRAINT [DF_Compartimiento_TN_CodCompartimiento]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaCompartimiento]) FOR [TN_CodCompartimiento]
GO
ALTER TABLE [Catalogo].[Compartimiento]
	WITH CHECK
	ADD CONSTRAINT [FK_Compartimiento_Estante]
	FOREIGN KEY ([TN_CodEstante]) REFERENCES [Catalogo].[Estante] ([TN_CodEstante])
ALTER TABLE [Catalogo].[Compartimiento]
	CHECK CONSTRAINT [FK_Compartimiento_Estante]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipo: "Compartimiento"', 'SCHEMA', N'Catalogo', 'TABLE', N'Compartimiento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'Compartimiento', 'COLUMN', N'TN_CodCompartimiento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'Compartimiento', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de Estante asociado.', 'SCHEMA', N'Catalogo', 'TABLE', N'Compartimiento', 'COLUMN', N'TN_CodEstante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Este campo va a contener la observación detallada de item que se encuentra guardado', 'SCHEMA', N'Catalogo', 'TABLE', N'Compartimiento', 'COLUMN', N'TC_Observacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Compartimiento', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Compartimiento', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Compartimiento] SET (LOCK_ESCALATION = TABLE)
GO

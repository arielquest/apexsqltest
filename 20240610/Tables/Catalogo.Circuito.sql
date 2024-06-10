SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Circuito] (
		[TN_CodCircuito]         [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodProvincia]        [smallint] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODCIRC]                [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Circuito]
		PRIMARY KEY
		CLUSTERED
		([TN_CodCircuito])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Circuito]
	ADD
	CONSTRAINT [DF_Circuito_TN_CodCircuito]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaCircuito]) FOR [TN_CodCircuito]
GO
ALTER TABLE [Catalogo].[Circuito]
	WITH CHECK
	ADD CONSTRAINT [FK_Circuito_Provincia]
	FOREIGN KEY ([TN_CodProvincia]) REFERENCES [Catalogo].[Provincia] ([TN_CodProvincia])
ALTER TABLE [Catalogo].[Circuito]
	CHECK CONSTRAINT [FK_Circuito_Provincia]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de circuitos judiciales.', 'SCHEMA', N'Catalogo', 'TABLE', N'Circuito', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del circuito.', 'SCHEMA', N'Catalogo', 'TABLE', N'Circuito', 'COLUMN', N'TN_CodCircuito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del circuito.', 'SCHEMA', N'Catalogo', 'TABLE', N'Circuito', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la provincia a la que pertenece el circuito.', 'SCHEMA', N'Catalogo', 'TABLE', N'Circuito', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Circuito', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Circuito', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Circuito] SET (LOCK_ESCALATION = TABLE)
GO

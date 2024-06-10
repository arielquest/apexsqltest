SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Canton] (
		[TN_CodProvincia]        [smallint] NOT NULL,
		[TN_CodCanton]           [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODPROV]                [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		[CODCANTON]              [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Canton]
		PRIMARY KEY
		CLUSTERED
		([TN_CodProvincia], [TN_CodCanton])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Canton]
	ADD
	CONSTRAINT [DF_Canton_TN_CodCanton]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaCanton]) FOR [TN_CodCanton]
GO
ALTER TABLE [Catalogo].[Canton]
	WITH CHECK
	ADD CONSTRAINT [FK_Canton_Provincia]
	FOREIGN KEY ([TN_CodProvincia]) REFERENCES [Catalogo].[Provincia] ([TN_CodProvincia])
ALTER TABLE [Catalogo].[Canton]
	CHECK CONSTRAINT [FK_Canton_Provincia]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de cantones.', 'SCHEMA', N'Catalogo', 'TABLE', N'Canton', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la provincia.', 'SCHEMA', N'Catalogo', 'TABLE', N'Canton', 'COLUMN', N'TN_CodProvincia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del cantón.', 'SCHEMA', N'Catalogo', 'TABLE', N'Canton', 'COLUMN', N'TN_CodCanton'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del cantón.', 'SCHEMA', N'Catalogo', 'TABLE', N'Canton', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Canton', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Canton', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Canton] SET (LOCK_ESCALATION = TABLE)
GO

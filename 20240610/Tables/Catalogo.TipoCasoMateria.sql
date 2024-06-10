SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoCasoMateria] (
		[TN_CodTipoCaso]         [smallint] NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_TipoCasoMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoCaso], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoCasoMateria]
	WITH NOCHECK
	ADD CONSTRAINT [FK_TipoCasoMateria_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[TipoCasoMateria]
	CHECK CONSTRAINT [FK_TipoCasoMateria_Materia]

GO
ALTER TABLE [Catalogo].[TipoCasoMateria]
	WITH NOCHECK
	ADD CONSTRAINT [FK_TipoCasoMateria_TipoCaso]
	FOREIGN KEY ([TN_CodTipoCaso]) REFERENCES [Catalogo].[TipoCaso] ([TN_CodTipoCaso])
ALTER TABLE [Catalogo].[TipoCasoMateria]
	CHECK CONSTRAINT [FK_TipoCasoMateria_TipoCaso]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico del tipo de caso', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoCasoMateria', 'COLUMN', N'TN_CodTipoCaso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la materia', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoCasoMateria', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoCasoMateria', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoCasoMateria] SET (LOCK_ESCALATION = TABLE)
GO

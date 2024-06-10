SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MotivoDevolucionPaseFalloMateria] (
		[TN_CodMotivoDevolucion]     [smallint] NOT NULL,
		[TC_CodMateria]              [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]         [datetime2](7) NOT NULL,
		CONSTRAINT [PK_MotivoDevolucionPaseFalloMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodMotivoDevolucion], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MotivoDevolucionPaseFalloMateria]
	WITH NOCHECK
	ADD CONSTRAINT [FK_MotivoDevolucionPaseFalloMateria_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[MotivoDevolucionPaseFalloMateria]
	CHECK CONSTRAINT [FK_MotivoDevolucionPaseFalloMateria_Materia]

GO
ALTER TABLE [Catalogo].[MotivoDevolucionPaseFalloMateria]
	WITH NOCHECK
	ADD CONSTRAINT [FK_MotivoDevolucionPaseFalloMateria_MotivoDevolucionPaseFallo]
	FOREIGN KEY ([TN_CodMotivoDevolucion]) REFERENCES [Catalogo].[MotivoDevolucionPaseFallo] ([TN_CodMotivoDevolucion])
ALTER TABLE [Catalogo].[MotivoDevolucionPaseFalloMateria]
	CHECK CONSTRAINT [FK_MotivoDevolucionPaseFalloMateria_MotivoDevolucionPaseFallo]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico del motivo devolución pase fallo', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDevolucionPaseFalloMateria', 'COLUMN', N'TN_CodMotivoDevolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la materia', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDevolucionPaseFalloMateria', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoDevolucionPaseFalloMateria', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[MotivoDevolucionPaseFalloMateria] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[FormatoJuriComunicacionContexto] (
		[TC_CodFormatoJuridico]     [varchar](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]            [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		CONSTRAINT [PK_FormatoJuriComunicacionContexto]
		PRIMARY KEY
		CLUSTERED
		([TC_CodFormatoJuridico], [TC_CodContexto])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[FormatoJuriComunicacionContexto]
	WITH CHECK
	ADD CONSTRAINT [FK_FormatoJuriComunicacionContexto_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Catalogo].[FormatoJuriComunicacionContexto]
	CHECK CONSTRAINT [FK_FormatoJuriComunicacionContexto_Contexto]

GO
ALTER TABLE [Catalogo].[FormatoJuriComunicacionContexto]
	WITH CHECK
	ADD CONSTRAINT [FK_FormatoJuriComunicacionContexto_FormatoJuridico]
	FOREIGN KEY ([TC_CodFormatoJuridico]) REFERENCES [Catalogo].[FormatoJuridico] ([TC_CodFormatoJuridico])
ALTER TABLE [Catalogo].[FormatoJuriComunicacionContexto]
	CHECK CONSTRAINT [FK_FormatoJuriComunicacionContexto_FormatoJuridico]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que relaciona el formato jurídico con un contexto en donde tendra registro automatico de notificaciones..', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuriComunicacionContexto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la plantilla de formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuriComunicacionContexto', 'COLUMN', N'TC_CodFormatoJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto donde el formato tiene registro de notificacion automatico.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuriComunicacionContexto', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuriComunicacionContexto', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[FormatoJuriComunicacionContexto] SET (LOCK_ESCALATION = TABLE)
GO

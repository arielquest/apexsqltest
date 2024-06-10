SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoRepresentacionMateria] (
		[TN_CodEstadoRepresentacion]     [smallint] NOT NULL,
		[TC_CodMateria]                  [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]             [datetime2](7) NOT NULL,
		[TB_IniciaTramitacion]           [bit] NOT NULL,
		CONSTRAINT [PK_EstadoRepresentacionMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstadoRepresentacion], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoRepresentacionMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_EstadoRepresentacionMateria_EstadoRepresentacion]
	FOREIGN KEY ([TN_CodEstadoRepresentacion]) REFERENCES [Catalogo].[EstadoRepresentacion] ([TN_CodEstadoRepresentacion])
ALTER TABLE [Catalogo].[EstadoRepresentacionMateria]
	CHECK CONSTRAINT [FK_EstadoRepresentacionMateria_EstadoRepresentacion]

GO
ALTER TABLE [Catalogo].[EstadoRepresentacionMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_EstadoRepresentacionMateria_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[EstadoRepresentacionMateria]
	CHECK CONSTRAINT [FK_EstadoRepresentacionMateria_Materia]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico del estado de la representacion', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoRepresentacionMateria', 'COLUMN', N'TN_CodEstadoRepresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico de la materia relacionada.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoRepresentacionMateria', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de asociacion', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoRepresentacionMateria', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador para establecer cuando un estado inicia una representacion', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoRepresentacionMateria', 'COLUMN', N'TB_IniciaTramitacion'
GO
ALTER TABLE [Catalogo].[EstadoRepresentacionMateria] SET (LOCK_ESCALATION = TABLE)
GO

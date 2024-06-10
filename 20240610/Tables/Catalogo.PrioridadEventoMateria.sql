SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[PrioridadEventoMateria] (
		[TN_CodPrioridadEvento]     [smallint] NOT NULL,
		[TC_CodMateria]             [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		CONSTRAINT [PK_PrioridadEventoMateria_1]
		PRIMARY KEY
		CLUSTERED
		([TN_CodPrioridadEvento], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[PrioridadEventoMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_PrioridadEventoMateria_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[PrioridadEventoMateria]
	CHECK CONSTRAINT [FK_PrioridadEventoMateria_Materia]

GO
ALTER TABLE [Catalogo].[PrioridadEventoMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_PrioridadEventoMateria_PrioridadEvento]
	FOREIGN KEY ([TN_CodPrioridadEvento]) REFERENCES [Catalogo].[PrioridadEvento] ([TN_CodPrioridadEvento])
ALTER TABLE [Catalogo].[PrioridadEventoMateria]
	CHECK CONSTRAINT [FK_PrioridadEventoMateria_PrioridadEvento]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo para asociar la prioridad de los eventos de la agenda con las materias.', 'SCHEMA', N'Catalogo', 'TABLE', N'PrioridadEventoMateria', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la prioridad del evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'PrioridadEventoMateria', 'COLUMN', N'TN_CodPrioridadEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'PrioridadEventoMateria', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PrioridadEventoMateria', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[PrioridadEventoMateria] SET (LOCK_ESCALATION = TABLE)
GO

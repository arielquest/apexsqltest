SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MotivoEstadoEventoMateria] (
		[TN_CodMotivoEstado]     [smallint] NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_MotivoEstadoEventoMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodMotivoEstado], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MotivoEstadoEventoMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_MotivoEstadoEventoMateria_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[MotivoEstadoEventoMateria]
	CHECK CONSTRAINT [FK_MotivoEstadoEventoMateria_Materia]

GO
ALTER TABLE [Catalogo].[MotivoEstadoEventoMateria]
	WITH CHECK
	ADD CONSTRAINT [FK_MotivoEstadoEventoMateria_MotivoEstadoEvento]
	FOREIGN KEY ([TN_CodMotivoEstado]) REFERENCES [Catalogo].[MotivoEstadoEvento] ([TN_CodMotivoEstado])
ALTER TABLE [Catalogo].[MotivoEstadoEventoMateria]
	CHECK CONSTRAINT [FK_MotivoEstadoEventoMateria_MotivoEstadoEvento]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo para asociar motivo de estado de evento a materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEventoMateria', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de estado de evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEventoMateria', 'COLUMN', N'TN_CodMotivoEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEventoMateria', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEventoMateria', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[MotivoEstadoEventoMateria] SET (LOCK_ESCALATION = TABLE)
GO

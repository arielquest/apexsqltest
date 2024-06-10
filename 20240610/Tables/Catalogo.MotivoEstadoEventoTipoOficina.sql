SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MotivoEstadoEventoTipoOficina] (
		[TN_CodMotivoEstado]     [smallint] NOT NULL,
		[TN_CodEstadoEvento]     [smallint] NOT NULL,
		[TN_CodTipoOficina]      [smallint] NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_MotivoEstadoEventoTipoOficinaMateria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodMotivoEstado], [TN_CodEstadoEvento], [TN_CodTipoOficina], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MotivoEstadoEventoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_MotivoEstadoEventoTipoOficinaMateria_EstadoEvento]
	FOREIGN KEY ([TN_CodEstadoEvento]) REFERENCES [Catalogo].[EstadoEvento] ([TN_CodEstadoEvento])
ALTER TABLE [Catalogo].[MotivoEstadoEventoTipoOficina]
	CHECK CONSTRAINT [FK_MotivoEstadoEventoTipoOficinaMateria_EstadoEvento]

GO
ALTER TABLE [Catalogo].[MotivoEstadoEventoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_MotivoEstadoEventoTipoOficinaMateria_MotivoEstadoEvento]
	FOREIGN KEY ([TN_CodMotivoEstado]) REFERENCES [Catalogo].[MotivoEstadoEvento] ([TN_CodMotivoEstado])
ALTER TABLE [Catalogo].[MotivoEstadoEventoTipoOficina]
	CHECK CONSTRAINT [FK_MotivoEstadoEventoTipoOficinaMateria_MotivoEstadoEvento]

GO
ALTER TABLE [Catalogo].[MotivoEstadoEventoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_MotivoEstadoEventoTipoOficinaMateria_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[MotivoEstadoEventoTipoOficina]
	CHECK CONSTRAINT [FK_MotivoEstadoEventoTipoOficinaMateria_TipoOficinaMateria]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia los motivos de  estados de evento según el tipo de oficina y materia', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEventoTipoOficina', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de estado de evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEventoTipoOficina', 'COLUMN', N'TN_CodMotivoEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del estado de evento', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEventoTipoOficina', 'COLUMN', N'TN_CodEstadoEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del tipo de oficina', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEventoTipoOficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEventoTipoOficina', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEventoTipoOficina', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[MotivoEstadoEventoTipoOficina] SET (LOCK_ESCALATION = TABLE)
GO

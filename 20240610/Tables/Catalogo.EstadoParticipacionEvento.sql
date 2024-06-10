SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoParticipacionEvento] (
		[TN_CodEstadoParticipacion]     [smallint] NOT NULL,
		[TC_Descripcion]                [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]            [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]               [datetime2](7) NULL,
		CONSTRAINT [PK_EstadoTarea]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstadoParticipacion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoParticipacionEvento]
	ADD
	CONSTRAINT [DF_EstadoParticipacionEvento_TN_CodEstadoParticipacion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEstadoParticipacionEvento]) FOR [TN_CodEstadoParticipacion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de estados que un participante puede tener en un evento de la agenda.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoParticipacionEvento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado de la participación de evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoParticipacionEvento', 'COLUMN', N'TN_CodEstadoParticipacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del estado de la participación de evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoParticipacionEvento', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoParticipacionEvento', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoParticipacionEvento', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[EstadoParticipacionEvento] SET (LOCK_ESCALATION = TABLE)
GO

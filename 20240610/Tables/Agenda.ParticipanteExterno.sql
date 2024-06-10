SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Agenda].[ParticipanteExterno] (
		[TU_CodEvento]            [uniqueidentifier] NOT NULL,
		[UsuarioExterno]          [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[NumeroBoleta]            [varchar](20) COLLATE Modern_Spanish_CI_AS NULL,
		[PlacaVehiculo]           [varchar](10) COLLATE Modern_Spanish_CI_AS NULL,
		[AportaFotografias]       [bit] NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		[TU_CodParticipacion]     [uniqueidentifier] NOT NULL,
		CONSTRAINT [PK_ParticipanteExterno]
		PRIMARY KEY
		CLUSTERED
		([TU_CodParticipacion])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Agenda].[ParticipanteExterno]
	ADD
	CONSTRAINT [DF_Agenda.ParticipanteExterno_NumeroBoleta]
	DEFAULT ('Número de boleta de tránsito') FOR [NumeroBoleta]
GO
ALTER TABLE [Agenda].[ParticipanteExterno]
	ADD
	CONSTRAINT [DF_ParticipanteExterno_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Agenda].[ParticipanteExterno]
	WITH CHECK
	ADD CONSTRAINT [FK_ParticipanteExterno_Evento]
	FOREIGN KEY ([TU_CodEvento]) REFERENCES [Agenda].[Evento] ([TU_CodEvento])
ALTER TABLE [Agenda].[ParticipanteExterno]
	CHECK CONSTRAINT [FK_ParticipanteExterno_Evento]

GO
CREATE NONCLUSTERED INDEX [IX_ParticipanteExterno_TF_FechaParticion]
	ON [Agenda].[ParticipanteExterno] ([TU_CodEvento])
	ON [FG_Agenda]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del evento generado para la cita', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteExterno', 'COLUMN', N'TU_CodEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de identificación del usuario que solicita la cita', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteExterno', 'COLUMN', N'UsuarioExterno'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de boleta indicado al momento de solicitar la cita', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteExterno', 'COLUMN', N'NumeroBoleta'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de placa indicado al momento de solicitar la cita', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteExterno', 'COLUMN', N'PlacaVehiculo'
GO
EXEC sp_addextendedproperty N'MS_Description', N' Se almacena un 1 si la persona indica que aporta fotografías al momento de solicitar la cita, en caso contrario se almacena un 0', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteExterno', 'COLUMN', N'AportaFotografias'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de particionamiento', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteExterno', 'COLUMN', N'TF_Particion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador de la tabla', 'SCHEMA', N'Agenda', 'TABLE', N'ParticipanteExterno', 'COLUMN', N'TU_CodParticipacion'
GO
ALTER TABLE [Agenda].[ParticipanteExterno] SET (LOCK_ESCALATION = TABLE)
GO

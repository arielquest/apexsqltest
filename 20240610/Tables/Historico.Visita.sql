SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[Visita] (
		[TU_CodVisita]            [uniqueidentifier] NOT NULL,
		[TU_CodInterviniente]     [uniqueidentifier] NULL,
		[TC_UsuarioRed]           [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoVisita]        [smallint] NOT NULL,
		[TC_Lugar]                [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_InicioVisita]         [datetime2](7) NOT NULL,
		[TF_FinalizaVisita]       [datetime2](7) NOT NULL,
		[TN_CodMotivoVisita]      [smallint] NOT NULL,
		[TN_CodMotivo]            [smallint] NOT NULL,
		[TC_CodContexto]          [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Observaciones]        [varchar](max) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]            [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Visita]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodVisita])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[Visita]
	ADD
	CONSTRAINT [DF__Visita__TF_Parti__26DC43DB]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[Visita]
	WITH CHECK
	ADD CONSTRAINT [FK_Visita_Contextos]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[Visita]
	CHECK CONSTRAINT [FK_Visita_Contextos]

GO
ALTER TABLE [Historico].[Visita]
	WITH CHECK
	ADD CONSTRAINT [FK_Visita_Funcionario]
	FOREIGN KEY ([TC_UsuarioRed]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Historico].[Visita]
	CHECK CONSTRAINT [FK_Visita_Funcionario]

GO
ALTER TABLE [Historico].[Visita]
	WITH CHECK
	ADD CONSTRAINT [FK_Visita_Interviniente]
	FOREIGN KEY ([TU_CodInterviniente]) REFERENCES [Expediente].[Intervencion] ([TU_CodInterviniente])
ALTER TABLE [Historico].[Visita]
	CHECK CONSTRAINT [FK_Visita_Interviniente]

GO
ALTER TABLE [Historico].[Visita]
	WITH CHECK
	ADD CONSTRAINT [FK_Visita_MotivoSuspencionVisita]
	FOREIGN KEY ([TN_CodMotivo]) REFERENCES [Catalogo].[MotivoSuspensionVisita] ([TN_CodMotivo])
ALTER TABLE [Historico].[Visita]
	CHECK CONSTRAINT [FK_Visita_MotivoSuspencionVisita]

GO
ALTER TABLE [Historico].[Visita]
	WITH CHECK
	ADD CONSTRAINT [FK_Visita_MotivoVisita]
	FOREIGN KEY ([TN_CodMotivoVisita]) REFERENCES [Catalogo].[MotivoVisita] ([TN_CodMotivoVisita])
ALTER TABLE [Historico].[Visita]
	CHECK CONSTRAINT [FK_Visita_MotivoVisita]

GO
ALTER TABLE [Historico].[Visita]
	WITH CHECK
	ADD CONSTRAINT [FK_Visita_TipoVisita]
	FOREIGN KEY ([TN_CodTipoVisita]) REFERENCES [Catalogo].[TipoVisita] ([TN_CodTipoVisita])
ALTER TABLE [Historico].[Visita]
	CHECK CONSTRAINT [FK_Visita_TipoVisita]

GO
CREATE CLUSTERED INDEX [IX_Historico_Visita_TF_Particion]
	ON [Historico].[Visita] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Historico de visitas carcelarias realizadas a los intervinientes.', 'SCHEMA', N'Historico', 'TABLE', N'Visita', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la visita carcelaria o de celdas.', 'SCHEMA', N'Historico', 'TABLE', N'Visita', 'COLUMN', N'TU_CodVisita'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codígo del interviniente involucrado.', 'SCHEMA', N'Historico', 'TABLE', N'Visita', 'COLUMN', N'TU_CodInterviniente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del funcionario que realiza la visita.', 'SCHEMA', N'Historico', 'TABLE', N'Visita', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de visita que se realiza.', 'SCHEMA', N'Historico', 'TABLE', N'Visita', 'COLUMN', N'TN_CodTipoVisita'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lugar donde se realiza la visita.', 'SCHEMA', N'Historico', 'TABLE', N'Visita', 'COLUMN', N'TC_Lugar'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora que inicia la visita.', 'SCHEMA', N'Historico', 'TABLE', N'Visita', 'COLUMN', N'TF_InicioVisita'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha que finaliza la visita.', 'SCHEMA', N'Historico', 'TABLE', N'Visita', 'COLUMN', N'TF_FinalizaVisita'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de visita.', 'SCHEMA', N'Historico', 'TABLE', N'Visita', 'COLUMN', N'TN_CodMotivoVisita'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de suspención.', 'SCHEMA', N'Historico', 'TABLE', N'Visita', 'COLUMN', N'TN_CodMotivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto.', 'SCHEMA', N'Historico', 'TABLE', N'Visita', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones de la visita.', 'SCHEMA', N'Historico', 'TABLE', N'Visita', 'COLUMN', N'TC_Observaciones'
GO
ALTER TABLE [Historico].[Visita] SET (LOCK_ESCALATION = TABLE)
GO

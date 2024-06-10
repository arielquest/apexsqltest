SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[ExpedienteFase] (
		[TU_CodExpedienteFase]     [uniqueidentifier] NOT NULL,
		[TN_CodFase]               [smallint] NOT NULL,
		[TC_NumeroExpediente]      [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]           [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fase]                  [datetime2](7) NOT NULL,
		[TC_UsuarioRed]            [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Actualizacion]         [datetime2](7) NOT NULL,
		[TF_Particion]             [datetime2](7) NOT NULL,
		[IDFEP]                    [bigint] NULL,
		CONSTRAINT [PK_ExpedienteFase]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodExpedienteFase])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[ExpedienteFase]
	ADD
	CONSTRAINT [DF_ExpedienteFase_TU_CodExpedienteFase]
	DEFAULT (newid()) FOR [TU_CodExpedienteFase]
GO
ALTER TABLE [Historico].[ExpedienteFase]
	ADD
	CONSTRAINT [DF_ExpedienteFase_TF_Inicio_Vigencia]
	DEFAULT (getdate()) FOR [TF_Fase]
GO
ALTER TABLE [Historico].[ExpedienteFase]
	ADD
	CONSTRAINT [DF_ExpedienteFase_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Historico].[ExpedienteFase]
	ADD
	CONSTRAINT [DF__Expedient__TF_Pa__7CE60A0F]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[ExpedienteFase]
	ADD
	CONSTRAINT [DF_ExpedienteFase_IDFEP]
	DEFAULT ((1)) FOR [IDFEP]
GO
ALTER TABLE [Historico].[ExpedienteFase]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteFase_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[ExpedienteFase]
	CHECK CONSTRAINT [FK_ExpedienteFase_Contexto]

GO
ALTER TABLE [Historico].[ExpedienteFase]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteFase_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[ExpedienteFase]
	CHECK CONSTRAINT [FK_ExpedienteFase_Expediente]

GO
ALTER TABLE [Historico].[ExpedienteFase]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteFase_Fase]
	FOREIGN KEY ([TN_CodFase]) REFERENCES [Catalogo].[Fase] ([TN_CodFase])
ALTER TABLE [Historico].[ExpedienteFase]
	CHECK CONSTRAINT [FK_ExpedienteFase_Fase]

GO
CREATE CLUSTERED INDEX [IX_Historico_ExpedienteFase_TF_Particion]
	ON [Historico].[ExpedienteFase] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [Contexto]
	ON [Historico].[ExpedienteFase] ([TC_CodContexto])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_ExpedienteFase_Migracion]
	ON [Historico].[ExpedienteFase] ([TC_NumeroExpediente], [TN_CodFase], [TC_CodContexto], [TF_Fase])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Historico de fases del expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteFase', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del registro de expediente fase.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteFase', 'COLUMN', N'TU_CodExpedienteFase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la fase.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteFase', 'COLUMN', N'TN_CodFase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteFase', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la contexto.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteFase', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de la fase en el expediente.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteFase', 'COLUMN', N'TF_Fase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que realizó el trámite.', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteFase', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización del registro (SIGMA).', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteFase', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Historico].[ExpedienteFase] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[LegajoFase] (
		[TU_CodLegajoFase]     [uniqueidentifier] NOT NULL,
		[TN_CodFase]           [smallint] NOT NULL,
		[TU_CodLegajo]         [uniqueidentifier] NOT NULL,
		[TC_CodContexto]       [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fase]              [datetime2](3) NOT NULL,
		[TC_UsuarioRed]        [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Actualizacion]     [datetime2](7) NOT NULL,
		[TF_Particion]         [datetime2](7) NOT NULL,
		[IDFEP]                [bigint] NULL,
		CONSTRAINT [PK_LegajoFase]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodLegajoFase])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Historico].[LegajoFase]
	ADD
	CONSTRAINT [DF_LegajoFase_TU_CodLegajoFase]
	DEFAULT (newid()) FOR [TU_CodLegajoFase]
GO
ALTER TABLE [Historico].[LegajoFase]
	ADD
	CONSTRAINT [DF_LegajoFase_TF_Inicio_Vigencia]
	DEFAULT (getdate()) FOR [TF_Fase]
GO
ALTER TABLE [Historico].[LegajoFase]
	ADD
	CONSTRAINT [DF_LegajoFase_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Historico].[LegajoFase]
	ADD
	CONSTRAINT [DF_LegajoFase_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[LegajoFase]
	ADD
	CONSTRAINT [DF_LegajoFase_IDFEP]
	DEFAULT ((1)) FOR [IDFEP]
GO
ALTER TABLE [Historico].[LegajoFase]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoFase_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[LegajoFase]
	CHECK CONSTRAINT [FK_LegajoFase_Contexto]

GO
ALTER TABLE [Historico].[LegajoFase]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoFase_Fase]
	FOREIGN KEY ([TN_CodFase]) REFERENCES [Catalogo].[Fase] ([TN_CodFase])
ALTER TABLE [Historico].[LegajoFase]
	CHECK CONSTRAINT [FK_LegajoFase_Fase]

GO
ALTER TABLE [Historico].[LegajoFase]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoFase_Funcionario]
	FOREIGN KEY ([TC_UsuarioRed]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Historico].[LegajoFase]
	CHECK CONSTRAINT [FK_LegajoFase_Funcionario]

GO
ALTER TABLE [Historico].[LegajoFase]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoFase_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Historico].[LegajoFase]
	CHECK CONSTRAINT [FK_LegajoFase_Legajo]

GO
CREATE NONCLUSTERED INDEX [IX_Historico_LegajoFase]
	ON [Historico].[LegajoFase] ([TN_CodFase], [TC_CodContexto], [TF_Fase], [TU_CodLegajo])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Historico de las fases asinadas a los legajos.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoFase', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador único del registro de legajo fase.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoFase', 'COLUMN', N'TU_CodLegajoFase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la fase.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoFase', 'COLUMN', N'TN_CodFase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoFase', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoFase', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de la fase en el legajo.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoFase', 'COLUMN', N'TF_Fase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario que realizó el trámite.', 'SCHEMA', N'Historico', 'TABLE', N'LegajoFase', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización del registro (SIGMA).', 'SCHEMA', N'Historico', 'TABLE', N'LegajoFase', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Historico].[LegajoFase] SET (LOCK_ESCALATION = TABLE)
GO

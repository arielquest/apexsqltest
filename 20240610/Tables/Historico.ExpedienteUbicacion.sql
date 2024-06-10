SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[ExpedienteUbicacion] (
		[TU_CodExpedienteUbicacion]     [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]           [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaUbicacion]             [datetime2](3) NOT NULL,
		[TN_CodUbicacion]               [int] NOT NULL,
		[TC_Descripcion]                [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]                 [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]                [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]                  [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ExpedienteUbicacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodExpedienteUbicacion])
	ON [PRIMARY]
) ON [HistoricoPS] ([TF_Particion])
GO
ALTER TABLE [Historico].[ExpedienteUbicacion]
	ADD
	CONSTRAINT [DF_ExpedienteUbicacion_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[ExpedienteUbicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedieneUbicacion_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[ExpedienteUbicacion]
	CHECK CONSTRAINT [FK_ExpedieneUbicacion_Expediente]

GO
ALTER TABLE [Historico].[ExpedienteUbicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteUbicacion_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[ExpedienteUbicacion]
	CHECK CONSTRAINT [FK_ExpedienteUbicacion_Contexto]

GO
ALTER TABLE [Historico].[ExpedienteUbicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteUbicacion_Funcionario]
	FOREIGN KEY ([TC_UsuarioRed]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Historico].[ExpedienteUbicacion]
	CHECK CONSTRAINT [FK_ExpedienteUbicacion_Funcionario]

GO
ALTER TABLE [Historico].[ExpedienteUbicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteUbicacion_Ubicacion]
	FOREIGN KEY ([TN_CodUbicacion]) REFERENCES [Catalogo].[Ubicacion] ([TN_CodUbicacion])
ALTER TABLE [Historico].[ExpedienteUbicacion]
	CHECK CONSTRAINT [FK_ExpedienteUbicacion_Ubicacion]

GO
CREATE CLUSTERED INDEX [IX_Historico_ExpedienteUbicacion]
	ON [Historico].[ExpedienteUbicacion] ([TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [_dta_index_ExpedienteUbicacion_5_1396212770__K4_2_7]
	ON [Historico].[ExpedienteUbicacion] ([TC_NumeroExpediente], [TC_CodContexto], [TN_CodUbicacion], [TF_Particion])
	ON [HistoricoPS] ([TF_Particion])
GO
CREATE NONCLUSTERED INDEX [IX_Historico_ExpedienteUbicacion_Migracion]
	ON [Historico].[ExpedienteUbicacion] ([TC_NumeroExpediente], [TC_CodContexto], [TF_FechaUbicacion], [TN_CodUbicacion], [TC_Descripcion])
	ON [HistoricoPS] ([TF_Particion])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene las diferentes ubicaciones de un exediente', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteUbicacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico de la ubicacion', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteUbicacion', 'COLUMN', N'TU_CodExpedienteUbicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de expediente asociado a la ubicacion', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteUbicacion', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la ubicacion', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteUbicacion', 'COLUMN', N'TF_FechaUbicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la ubiacion establecida', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteUbicacion', 'COLUMN', N'TN_CodUbicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion de la ubicacion', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteUbicacion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario de red asociado a la ubicacion', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteUbicacion', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contexto asociado a la ubicacion', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteUbicacion', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de particion de la tabla', 'SCHEMA', N'Historico', 'TABLE', N'ExpedienteUbicacion', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Historico].[ExpedienteUbicacion] SET (LOCK_ESCALATION = TABLE)
GO

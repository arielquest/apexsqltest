SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[LegajoUbicacion] (
		[TU_CodLegajoUbicacion]     [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]       [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodLegajo]              [uniqueidentifier] NOT NULL,
		[TF_FechaUbicacion]         [datetime2](3) NOT NULL,
		[TN_CodUbicacion]           [int] NOT NULL,
		[TC_Descripcion]            [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]             [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]            [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Particion]              [datetime2](7) NOT NULL,
		CONSTRAINT [PK_LegajoUbicacion]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodLegajoUbicacion])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Historico].[LegajoUbicacion]
	ADD
	CONSTRAINT [DF_LegajoUbicacion_TF_Particion]
	DEFAULT (sysdatetime()) FOR [TF_Particion]
GO
ALTER TABLE [Historico].[LegajoUbicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_ExpedienteUbicacion_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Historico].[LegajoUbicacion]
	CHECK CONSTRAINT [FK_ExpedienteUbicacion_Expediente]

GO
ALTER TABLE [Historico].[LegajoUbicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoUbicacion_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Historico].[LegajoUbicacion]
	CHECK CONSTRAINT [FK_LegajoUbicacion_Contexto]

GO
ALTER TABLE [Historico].[LegajoUbicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoUbicacion_Funcionario]
	FOREIGN KEY ([TC_UsuarioRed]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Historico].[LegajoUbicacion]
	CHECK CONSTRAINT [FK_LegajoUbicacion_Funcionario]

GO
ALTER TABLE [Historico].[LegajoUbicacion]
	WITH CHECK
	ADD CONSTRAINT [FK_LegajoUbicacion_Ubicacion]
	FOREIGN KEY ([TN_CodUbicacion]) REFERENCES [Catalogo].[Ubicacion] ([TN_CodUbicacion])
ALTER TABLE [Historico].[LegajoUbicacion]
	CHECK CONSTRAINT [FK_LegajoUbicacion_Ubicacion]

GO
CREATE NONCLUSTERED INDEX [_dta_index_LegajoUbicacion_5_1316212485__K5_2_3_8]
	ON [Historico].[LegajoUbicacion] ([TN_CodUbicacion])
	INCLUDE ([TC_NumeroExpediente], [TU_CodLegajo], [TC_CodContexto])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_UNQ_LEGAJOUBICACION_CODLEGAJO]
	ON [Historico].[LegajoUbicacion] ([TU_CodLegajo])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Historico_LegajoUbicacion_Migracion]
	ON [Historico].[LegajoUbicacion] ([TC_NumeroExpediente], [TU_CodLegajo], [TC_CodContexto], [TF_FechaUbicacion], [TN_CodUbicacion], [TC_Descripcion])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_20_19]
	ON [Historico].[LegajoUbicacion] ([TU_CodLegajo], [TC_CodContexto])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene las diferentes ubicaciones de un exediente', 'SCHEMA', N'Historico', 'TABLE', N'LegajoUbicacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador unico de la ubicacion', 'SCHEMA', N'Historico', 'TABLE', N'LegajoUbicacion', 'COLUMN', N'TU_CodLegajoUbicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Numero de expediente asociado a la ubicacion', 'SCHEMA', N'Historico', 'TABLE', N'LegajoUbicacion', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del legajo', 'SCHEMA', N'Historico', 'TABLE', N'LegajoUbicacion', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la ubicacion', 'SCHEMA', N'Historico', 'TABLE', N'LegajoUbicacion', 'COLUMN', N'TF_FechaUbicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo de la ubiacion establecida', 'SCHEMA', N'Historico', 'TABLE', N'LegajoUbicacion', 'COLUMN', N'TN_CodUbicacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion de la ubicacion', 'SCHEMA', N'Historico', 'TABLE', N'LegajoUbicacion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario de red asociado a la ubicacion', 'SCHEMA', N'Historico', 'TABLE', N'LegajoUbicacion', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contexto asociado a la ubicacion', 'SCHEMA', N'Historico', 'TABLE', N'LegajoUbicacion', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de particion de la tabla', 'SCHEMA', N'Historico', 'TABLE', N'LegajoUbicacion', 'COLUMN', N'TF_Particion'
GO
ALTER TABLE [Historico].[LegajoUbicacion] SET (LOCK_ESCALATION = TABLE)
GO

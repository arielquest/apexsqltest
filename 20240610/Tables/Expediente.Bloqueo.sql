SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[Bloqueo] (
		[TU_CodBloqueo]           [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]     [char](14) COLLATE Modern_Spanish_CI_AS NULL,
		[TU_CodLegajo]            [uniqueidentifier] NULL,
		[TC_CodContexto]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_UsuarioRed]           [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaBloqueo]         [datetime2](3) NOT NULL,
		CONSTRAINT [PK_Bloqueo]
		PRIMARY KEY
		CLUSTERED
		([TU_CodBloqueo])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Expediente].[Bloqueo]
	ADD
	CONSTRAINT [CK_Bloqueo]
	CHECK
	([TC_NumeroExpediente] IS NULL AND [TU_CodLegajo] IS NOT NULL OR [TU_CodLegajo] IS NULL AND [TC_NumeroExpediente] IS NOT NULL)
GO
EXEC sp_addextendedproperty N'MS_Description', N'Verifica que solo se pueda ingresar expediente o legajo', 'SCHEMA', N'Expediente', 'TABLE', N'Bloqueo', 'CONSTRAINT', N'CK_Bloqueo'
GO
ALTER TABLE [Expediente].[Bloqueo]
CHECK CONSTRAINT [CK_Bloqueo]
GO
ALTER TABLE [Expediente].[Bloqueo]
	WITH CHECK
	ADD CONSTRAINT [FK_Bloqueo_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Expediente].[Bloqueo]
	CHECK CONSTRAINT [FK_Bloqueo_Contexto]

GO
ALTER TABLE [Expediente].[Bloqueo]
	WITH CHECK
	ADD CONSTRAINT [FK_Bloqueo_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[Bloqueo]
	CHECK CONSTRAINT [FK_Bloqueo_Expediente]

GO
ALTER TABLE [Expediente].[Bloqueo]
	WITH CHECK
	ADD CONSTRAINT [FK_Bloqueo_Funcionario]
	FOREIGN KEY ([TC_UsuarioRed]) REFERENCES [Catalogo].[Funcionario] ([TC_UsuarioRed])
ALTER TABLE [Expediente].[Bloqueo]
	CHECK CONSTRAINT [FK_Bloqueo_Funcionario]

GO
ALTER TABLE [Expediente].[Bloqueo]
	WITH CHECK
	ADD CONSTRAINT [FK_Bloqueo_Legajo]
	FOREIGN KEY ([TU_CodLegajo]) REFERENCES [Expediente].[Legajo] ([TU_CodLegajo])
ALTER TABLE [Expediente].[Bloqueo]
	CHECK CONSTRAINT [FK_Bloqueo_Legajo]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra los expedientes y legajos bloqueados', 'SCHEMA', N'Expediente', 'TABLE', N'Bloqueo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de consecutivo para el bloqueo', 'SCHEMA', N'Expediente', 'TABLE', N'Bloqueo', 'COLUMN', N'TU_CodBloqueo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Número de expediente', 'SCHEMA', N'Expediente', 'TABLE', N'Bloqueo', 'COLUMN', N'TC_NumeroExpediente'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de legajo', 'SCHEMA', N'Expediente', 'TABLE', N'Bloqueo', 'COLUMN', N'TU_CodLegajo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del contexto donde se encuentra el expediente.', 'SCHEMA', N'Expediente', 'TABLE', N'Bloqueo', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Usuario de red del funcionario que bloquea el expediente', 'SCHEMA', N'Expediente', 'TABLE', N'Bloqueo', 'COLUMN', N'TC_UsuarioRed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha y hora en que se bloquea el expediente', 'SCHEMA', N'Expediente', 'TABLE', N'Bloqueo', 'COLUMN', N'TF_FechaBloqueo'
GO
ALTER TABLE [Expediente].[Bloqueo] SET (LOCK_ESCALATION = TABLE)
GO

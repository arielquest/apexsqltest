SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[ContextoPrioridad] (
		[TC_CodContexto]         [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodPrioridad]        [smallint] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NULL,
		CONSTRAINT [PK_ContextoPrioridad]
		PRIMARY KEY
		CLUSTERED
		([TC_CodContexto], [TN_CodPrioridad])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[ContextoPrioridad]
	WITH CHECK
	ADD CONSTRAINT [FK_ContextoPrioridad_Contextos]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Catalogo].[ContextoPrioridad]
	CHECK CONSTRAINT [FK_ContextoPrioridad_Contextos]

GO
ALTER TABLE [Catalogo].[ContextoPrioridad]
	WITH CHECK
	ADD CONSTRAINT [FK_ContextoPrioridad_Prioridad]
	FOREIGN KEY ([TN_CodPrioridad]) REFERENCES [Catalogo].[Prioridad] ([TN_CodPrioridad])
ALTER TABLE [Catalogo].[ContextoPrioridad]
	CHECK CONSTRAINT [FK_ContextoPrioridad_Prioridad]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia un contxto a la prioridad.', 'SCHEMA', N'Catalogo', 'TABLE', N'ContextoPrioridad', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo del contexto.', 'SCHEMA', N'Catalogo', 'TABLE', N'ContextoPrioridad', 'COLUMN', N'TC_CodContexto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la prioridad.', 'SCHEMA', N'Catalogo', 'TABLE', N'ContextoPrioridad', 'COLUMN', N'TN_CodPrioridad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'ContextoPrioridad', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[ContextoPrioridad] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Catalogo].[TipoEventoTipoFuncionario] (
		[TN_CodTipoEvento]          [smallint] NOT NULL,
		[TN_CodTipoFuncionario]     [smallint] NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		CONSTRAINT [PK_TipoEventoTipoFuncionario]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoEvento], [TN_CodTipoFuncionario])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoEventoTipoFuncionario]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoEventoTipoFuncionario_TipoEvento]
	FOREIGN KEY ([TN_CodTipoEvento]) REFERENCES [Catalogo].[TipoEvento] ([TN_CodTipoEvento])
ALTER TABLE [Catalogo].[TipoEventoTipoFuncionario]
	CHECK CONSTRAINT [FK_TipoEventoTipoFuncionario_TipoEvento]

GO
ALTER TABLE [Catalogo].[TipoEventoTipoFuncionario]
	WITH CHECK
	ADD CONSTRAINT [FK_TipoEventoTipoFuncionario_TipoFuncionario]
	FOREIGN KEY ([TN_CodTipoFuncionario]) REFERENCES [Catalogo].[TipoFuncionario] ([TN_CodTipoFuncionario])
ALTER TABLE [Catalogo].[TipoEventoTipoFuncionario]
	CHECK CONSTRAINT [FK_TipoEventoTipoFuncionario_TipoFuncionario]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de evento', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEventoTipoFuncionario', 'COLUMN', N'TN_CodTipoEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de funcionario', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEventoTipoFuncionario', 'COLUMN', N'TN_CodTipoFuncionario'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEventoTipoFuncionario', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoEventoTipoFuncionario] SET (LOCK_ESCALATION = TABLE)
GO

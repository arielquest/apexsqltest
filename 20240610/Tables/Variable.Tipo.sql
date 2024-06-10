SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Variable].[Tipo] (
		[var_id_tipo]     [int] NOT NULL,
		[var_nombre]      [char](100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los tipos de variables de los machotes.', 'SCHEMA', N'Variable', 'TABLE', N'Tipo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de variable.', 'SCHEMA', N'Variable', 'TABLE', N'Tipo', 'COLUMN', N'var_id_tipo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del tipo.', 'SCHEMA', N'Variable', 'TABLE', N'Tipo', 'COLUMN', N'var_nombre'
GO
ALTER TABLE [Variable].[Tipo] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Variable].[Variable] (
		[var_variable]           [int] NOT NULL,
		[var_nombre]             [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[var_tipo]               [smallint] NOT NULL,
		[var_multiple]           [bit] NOT NULL,
		[var_formato]            [char](30) COLLATE Modern_Spanish_CI_AS NULL,
		[var_dato1]              [text] COLLATE Modern_Spanish_CI_AS NULL,
		[var_dato2]              [char](150) COLLATE Modern_Spanish_CI_AS NULL,
		[var_observacion]        [char](100) COLLATE Modern_Spanish_CI_AS NULL,
		[nombreConexion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NULL,
		[var_dato1_original]     [text] COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [VAR_VARIABLE$PK_VAR_VARIABLE]
		PRIMARY KEY
		CLUSTERED
		([var_variable])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ] TEXTIMAGE_ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de las variables de los machotes.', 'SCHEMA', N'Variable', 'TABLE', N'Variable', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la variable.', 'SCHEMA', N'Variable', 'TABLE', N'Variable', 'COLUMN', N'var_variable'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la variable.', 'SCHEMA', N'Variable', 'TABLE', N'Variable', 'COLUMN', N'var_nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de la variable.', 'SCHEMA', N'Variable', 'TABLE', N'Variable', 'COLUMN', N'var_tipo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la varialbe devuelve multiples valores.', 'SCHEMA', N'Variable', 'TABLE', N'Variable', 'COLUMN', N'var_multiple'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del formato de la variable.', 'SCHEMA', N'Variable', 'TABLE', N'Variable', 'COLUMN', N'var_formato'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primer dato de la variable.', 'SCHEMA', N'Variable', 'TABLE', N'Variable', 'COLUMN', N'var_dato1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Segundo dato de la variable.', 'SCHEMA', N'Variable', 'TABLE', N'Variable', 'COLUMN', N'var_dato2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones adicionales de la variable.', 'SCHEMA', N'Variable', 'TABLE', N'Variable', 'COLUMN', N'var_observacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la conexión.', 'SCHEMA', N'Variable', 'TABLE', N'Variable', 'COLUMN', N'nombreConexion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dato original de la variable antes de realizar la migración.', 'SCHEMA', N'Variable', 'TABLE', N'Variable', 'COLUMN', N'var_dato1_original'
GO
ALTER TABLE [Variable].[Variable] SET (LOCK_ESCALATION = TABLE)
GO

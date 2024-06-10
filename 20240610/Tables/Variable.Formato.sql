SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Variable].[Formato] (
		[var_id_formato]     [int] NOT NULL,
		[var_nombre]         [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[var_formato]        [char](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [VAR_FORMATO$PK_VAR_FORMATO]
		PRIMARY KEY
		CLUSTERED
		([var_id_formato])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Variable].[Formato]
	ADD
	CONSTRAINT [DF_Formato_var_id_formato]
	DEFAULT (NEXT VALUE FOR [Variable].[SecuenciaFormatoVariable]) FOR [var_id_formato]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena la información de los formatos de texto de las variables de los machotes.', 'SCHEMA', N'Variable', 'TABLE', N'Formato', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del formato.', 'SCHEMA', N'Variable', 'TABLE', N'Formato', 'COLUMN', N'var_id_formato'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del formato.', 'SCHEMA', N'Variable', 'TABLE', N'Formato', 'COLUMN', N'var_nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Formato de texto.', 'SCHEMA', N'Variable', 'TABLE', N'Formato', 'COLUMN', N'var_formato'
GO
ALTER TABLE [Variable].[Formato] SET (LOCK_ESCALATION = TABLE)
GO

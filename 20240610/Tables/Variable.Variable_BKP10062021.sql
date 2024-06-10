SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Variable].[Variable_BKP10062021] (
		[var_variable]           [int] NOT NULL,
		[var_nombre]             [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[var_tipo]               [smallint] NOT NULL,
		[var_multiple]           [bit] NOT NULL,
		[var_formato]            [char](30) COLLATE Modern_Spanish_CI_AS NULL,
		[var_dato1]              [text] COLLATE Modern_Spanish_CI_AS NULL,
		[var_dato2]              [char](150) COLLATE Modern_Spanish_CI_AS NULL,
		[var_observacion]        [char](100) COLLATE Modern_Spanish_CI_AS NULL,
		[nombreConexion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NULL,
		[var_dato1_original]     [text] COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Variable].[Variable_BKP10062021] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Migracion].[ValoresDefecto] (
		[TC_NombreCampo]         [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_ValoresActuales]     [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_ValorPorDefecto]     [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_ValoresDefecto]
		PRIMARY KEY
		CLUSTERED
		([TC_NombreCampo], [TC_ValoresActuales])
	ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla utilizada para configurar valores por defecto a campos que se migrarán.', 'SCHEMA', N'Migracion', 'TABLE', N'ValoresDefecto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el nombre del campo en el SIAGPJ que tomará el valor.', 'SCHEMA', N'Migracion', 'TABLE', N'ValoresDefecto', 'COLUMN', N'TC_NombreCampo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica los valores que puede poseer en el origen.', 'SCHEMA', N'Migracion', 'TABLE', N'ValoresDefecto', 'COLUMN', N'TC_ValoresActuales'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el valor que se pondrá en el SIAGPJ al momento de la migración.', 'SCHEMA', N'Migracion', 'TABLE', N'ValoresDefecto', 'COLUMN', N'TC_ValorPorDefecto'
GO
ALTER TABLE [Migracion].[ValoresDefecto] SET (LOCK_ESCALATION = TABLE)
GO

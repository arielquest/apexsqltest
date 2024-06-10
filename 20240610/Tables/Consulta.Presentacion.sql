SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Consulta].[Presentacion] (
		[TN_CodPresentacion]     [smallint] NOT NULL,
		[TN_CodModulo]           [smallint] NOT NULL,
		[TC_NombreColumna]       [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Nombre]              [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_Predeterminada]      [bit] NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_Presentacion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodPresentacion])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Consulta].[Presentacion]
	ADD
	CONSTRAINT [DF_Presentacion_TC_CodPresentacion]
	DEFAULT (NEXT VALUE FOR [Consulta].[SecuenciaColumnaPresentacion]) FOR [TN_CodPresentacion]
GO
ALTER TABLE [Consulta].[Presentacion]
	WITH CHECK
	ADD CONSTRAINT [FK_Presentacion_Modulo]
	FOREIGN KEY ([TN_CodModulo]) REFERENCES [Consulta].[Modulo] ([TN_CodModulo])
ALTER TABLE [Consulta].[Presentacion]
	CHECK CONSTRAINT [FK_Presentacion_Modulo]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena las columnas que se pueden presentar por módulo.', 'SCHEMA', N'Consulta', 'TABLE', N'Presentacion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la presentación.', 'SCHEMA', N'Consulta', 'TABLE', N'Presentacion', 'COLUMN', N'TN_CodPresentacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del modulo al cual pertenece la presentación.', 'SCHEMA', N'Consulta', 'TABLE', N'Presentacion', 'COLUMN', N'TN_CodModulo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de columna.', 'SCHEMA', N'Consulta', 'TABLE', N'Presentacion', 'COLUMN', N'TC_NombreColumna'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre o alias para la columna.', 'SCHEMA', N'Consulta', 'TABLE', N'Presentacion', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la columna se muestra de forma predeterminada.', 'SCHEMA', N'Consulta', 'TABLE', N'Presentacion', 'COLUMN', N'TB_Predeterminada'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Consulta', 'TABLE', N'Presentacion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Consulta', 'TABLE', N'Presentacion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Consulta].[Presentacion] SET (LOCK_ESCALATION = TABLE)
GO

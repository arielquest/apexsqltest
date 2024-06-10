SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Consulta].[Modulo] (
		[TN_CodModulo]           [smallint] NOT NULL,
		[TC_Nombre]              [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodSeccion]          [smallint] NOT NULL,
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_Modulo]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodModulo])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Consulta].[Modulo]
	ADD
	CONSTRAINT [CK_Modulo_ValidaFechas]
	CHECK
	([TF_Inicio_Vigencia]<=[TF_Fin_Vigencia])
GO
ALTER TABLE [Consulta].[Modulo]
CHECK CONSTRAINT [CK_Modulo_ValidaFechas]
GO
ALTER TABLE [Consulta].[Modulo]
	ADD
	CONSTRAINT [DF_Modulo_TC_CodModulo]
	DEFAULT (NEXT VALUE FOR [Consulta].[SecuenciaModulo]) FOR [TN_CodModulo]
GO
ALTER TABLE [Consulta].[Modulo]
	WITH CHECK
	ADD CONSTRAINT [FK_Modulo_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Consulta].[Modulo]
	CHECK CONSTRAINT [FK_Modulo_Materia]

GO
ALTER TABLE [Consulta].[Modulo]
	WITH CHECK
	ADD CONSTRAINT [FK_Modulo_Seccion]
	FOREIGN KEY ([TN_CodSeccion]) REFERENCES [Consulta].[Seccion] ([TN_CodSeccion])
ALTER TABLE [Consulta].[Modulo]
	CHECK CONSTRAINT [FK_Modulo_Seccion]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los módulos de consulta.', 'SCHEMA', N'Consulta', 'TABLE', N'Modulo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del módulo de consulta.', 'SCHEMA', N'Consulta', 'TABLE', N'Modulo', 'COLUMN', N'TN_CodModulo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del módulo de consulta.', 'SCHEMA', N'Consulta', 'TABLE', N'Modulo', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la sección.', 'SCHEMA', N'Consulta', 'TABLE', N'Modulo', 'COLUMN', N'TN_CodSeccion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Consulta', 'TABLE', N'Modulo', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Consulta', 'TABLE', N'Modulo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Consulta', 'TABLE', N'Modulo', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Consulta].[Modulo] SET (LOCK_ESCALATION = TABLE)
GO

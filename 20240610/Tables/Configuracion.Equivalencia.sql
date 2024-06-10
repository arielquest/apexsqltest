SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Configuracion].[Equivalencia] (
		[TU_Codigo]                 [uniqueidentifier] NOT NULL,
		[TN_CodSistema]             [smallint] NOT NULL,
		[TN_CodCatalogo]            [smallint] NOT NULL,
		[TC_ValorExterno]           [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_DescripcionExterno]     [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_ValorSIAGPJ]            [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_DescripcionSIAGPJ]      [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoOficina]         [smallint] NULL,
		[TC_CodMateria]             [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodContexto]            [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Equivalencia]
		PRIMARY KEY
		CLUSTERED
		([TU_Codigo])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Configuracion].[Equivalencia]
	WITH CHECK
	ADD CONSTRAINT [FK_Equivalencia_Catalogo]
	FOREIGN KEY ([TN_CodCatalogo]) REFERENCES [Configuracion].[Catalogo] ([TN_CodCatalogo])
ALTER TABLE [Configuracion].[Equivalencia]
	CHECK CONSTRAINT [FK_Equivalencia_Catalogo]

GO
ALTER TABLE [Configuracion].[Equivalencia]
	WITH CHECK
	ADD CONSTRAINT [FK_Equivalencia_Contexto]
	FOREIGN KEY ([TC_CodContexto]) REFERENCES [Catalogo].[Contexto] ([TC_CodContexto])
ALTER TABLE [Configuracion].[Equivalencia]
	CHECK CONSTRAINT [FK_Equivalencia_Contexto]

GO
ALTER TABLE [Configuracion].[Equivalencia]
	WITH CHECK
	ADD CONSTRAINT [FK_Equivalencia_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Configuracion].[Equivalencia]
	CHECK CONSTRAINT [FK_Equivalencia_Materia]

GO
ALTER TABLE [Configuracion].[Equivalencia]
	WITH CHECK
	ADD CONSTRAINT [FK_Equivalencia_Sistema]
	FOREIGN KEY ([TN_CodSistema]) REFERENCES [Configuracion].[Sistema] ([TN_CodSistema])
ALTER TABLE [Configuracion].[Equivalencia]
	CHECK CONSTRAINT [FK_Equivalencia_Sistema]

GO
ALTER TABLE [Configuracion].[Equivalencia]
	WITH CHECK
	ADD CONSTRAINT [FK_Equivalencia_TipoOficina]
	FOREIGN KEY ([TN_CodTipoOficina]) REFERENCES [Catalogo].[TipoOficina] ([TN_CodTipoOficina])
ALTER TABLE [Configuracion].[Equivalencia]
	CHECK CONSTRAINT [FK_Equivalencia_TipoOficina]

GO
CREATE NONCLUSTERED INDEX [IX_Configuracion_EquivalenciaConsultaExternoaSIAGPJ]
	ON [Configuracion].[Equivalencia] ([TN_CodCatalogo], [TC_ValorExterno], [TC_CodContexto], [TN_CodTipoOficina], [TC_CodMateria])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice para optimizar la consulta de equivalencias de un catálogo de un sistema externo, hacia un catálogo de SIAGPJ.', 'SCHEMA', N'Configuracion', 'TABLE', N'Equivalencia', 'INDEX', N'IX_Configuracion_EquivalenciaConsultaExternoaSIAGPJ'
GO
CREATE NONCLUSTERED INDEX [IX_Configuracion_EquivalenciaConsultaSIAGPJaExterno]
	ON [Configuracion].[Equivalencia] ([TN_CodCatalogo], [TC_ValorSIAGPJ], [TC_CodContexto], [TN_CodTipoOficina], [TC_CodMateria])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice para optimizar la consulta de equivalencias de un catálogo de SIAGPJ, hacia un catálogo de un sistema externo.', 'SCHEMA', N'Configuracion', 'TABLE', N'Equivalencia', 'INDEX', N'IX_Configuracion_EquivalenciaConsultaSIAGPJaExterno'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tabla donde se definen las equivalencias entre los catálogos de SIAGPJ y los sistemas externos.', 'SCHEMA', N'Configuracion', 'TABLE', N'Equivalencia', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código unico de la equivalencia.', 'SCHEMA', N'Configuracion', 'TABLE', N'Equivalencia', 'COLUMN', N'TU_Codigo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del sistema externo definido en la tabla Configuracion.Sistema.', 'SCHEMA', N'Configuracion', 'TABLE', N'Equivalencia', 'COLUMN', N'TN_CodSistema'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo externo definido en la tabla Configuracion.Catalogo.', 'SCHEMA', N'Configuracion', 'TABLE', N'Equivalencia', 'COLUMN', N'TN_CodCatalogo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del valor externo ingresado en la equivalencia.', 'SCHEMA', N'Configuracion', 'TABLE', N'Equivalencia', 'COLUMN', N'TC_ValorExterno'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del valor externo ingresado en la equivalencia.', 'SCHEMA', N'Configuracion', 'TABLE', N'Equivalencia', 'COLUMN', N'TC_DescripcionExterno'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificador del valor equivalente en el catálogo de SIAGPJ.', 'SCHEMA', N'Configuracion', 'TABLE', N'Equivalencia', 'COLUMN', N'TC_ValorSIAGPJ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del valor del catálogo del SIAGPJ ingresado en la equivalencia.', 'SCHEMA', N'Configuracion', 'TABLE', N'Equivalencia', 'COLUMN', N'TC_DescripcionSIAGPJ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de oficina asociada a la equivalencia', 'SCHEMA', N'Configuracion', 'TABLE', N'Equivalencia', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia asociada a la equivalencia', 'SCHEMA', N'Configuracion', 'TABLE', N'Equivalencia', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de contexto asociado a la equivalencia', 'SCHEMA', N'Configuracion', 'TABLE', N'Equivalencia', 'COLUMN', N'TC_CodContexto'
GO
ALTER TABLE [Configuracion].[Equivalencia] SET (LOCK_ESCALATION = TABLE)
GO

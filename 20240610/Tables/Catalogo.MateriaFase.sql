SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MateriaFase] (
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodFase]             [smallint] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NULL,
		[TB_PorDefecto]          [bit] NOT NULL,
		[TN_CodTipoOficina]      [smallint] NOT NULL,
		CONSTRAINT [PK_MateriaFase]
		PRIMARY KEY
		CLUSTERED
		([TC_CodMateria], [TN_CodFase], [TN_CodTipoOficina])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MateriaFase]
	ADD
	CONSTRAINT [DF_MateriaFase_TB_PorDefecto]
	DEFAULT ((0)) FOR [TB_PorDefecto]
GO
ALTER TABLE [Catalogo].[MateriaFase]
	WITH CHECK
	ADD CONSTRAINT [FK_MateriaFase_Fase]
	FOREIGN KEY ([TN_CodFase]) REFERENCES [Catalogo].[Fase] ([TN_CodFase])
ALTER TABLE [Catalogo].[MateriaFase]
	CHECK CONSTRAINT [FK_MateriaFase_Fase]

GO
ALTER TABLE [Catalogo].[MateriaFase]
	WITH CHECK
	ADD CONSTRAINT [FK_MateriaFase_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[MateriaFase]
	CHECK CONSTRAINT [FK_MateriaFase_Materia]

GO
ALTER TABLE [Catalogo].[MateriaFase]
	WITH CHECK
	ADD CONSTRAINT [FK_MateriaFase_TipoOficina]
	FOREIGN KEY ([TN_CodTipoOficina]) REFERENCES [Catalogo].[TipoOficina] ([TN_CodTipoOficina])
ALTER TABLE [Catalogo].[MateriaFase]
	CHECK CONSTRAINT [FK_MateriaFase_TipoOficina]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia las materias con sus fases.', 'SCHEMA', N'Catalogo', 'TABLE', N'MateriaFase', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'MateriaFase', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la fase.', 'SCHEMA', N'Catalogo', 'TABLE', N'MateriaFase', 'COLUMN', N'TN_CodFase'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MateriaFase', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si este es el valor por defecto.', 'SCHEMA', N'Catalogo', 'TABLE', N'MateriaFase', 'COLUMN', N'TB_PorDefecto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo de Oficina ', 'SCHEMA', N'Catalogo', 'TABLE', N'MateriaFase', 'COLUMN', N'TN_CodTipoOficina'
GO
ALTER TABLE [Catalogo].[MateriaFase] SET (LOCK_ESCALATION = TABLE)
GO

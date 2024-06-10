SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Materia] (
		[TC_CodMateria]          [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]         [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_EjecutaRemate]       [bit] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_Materia]
		PRIMARY KEY
		CLUSTERED
		([TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Materia]
	ADD
	CONSTRAINT [DF_Materia_TB_EjecutaRemate]
	DEFAULT ((0)) FOR [TB_EjecutaRemate]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de las materias judiciales.', 'SCHEMA', N'Catalogo', 'TABLE', N'Materia', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'Materia', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'Materia', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si en esta materia se ejecutan remates judiciales.', 'SCHEMA', N'Catalogo', 'TABLE', N'Materia', 'COLUMN', N'TB_EjecutaRemate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Materia', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Materia', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Materia] SET (LOCK_ESCALATION = TABLE)
GO

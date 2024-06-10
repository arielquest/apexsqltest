SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Sexo] (
		[TC_CodSexo]             [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]         [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_Sexo]
		PRIMARY KEY
		CLUSTERED
		([TC_CodSexo])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo para almacenar los tipos de sexo.', 'SCHEMA', N'Catalogo', 'TABLE', N'Sexo', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del sexo.', 'SCHEMA', N'Catalogo', 'TABLE', N'Sexo', 'COLUMN', N'TC_CodSexo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del sexo.', 'SCHEMA', N'Catalogo', 'TABLE', N'Sexo', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Sexo', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Sexo', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Sexo] SET (LOCK_ESCALATION = TABLE)
GO

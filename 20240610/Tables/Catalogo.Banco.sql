SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Banco] (
		[TC_CodigoBanco]         [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_Banco]
		PRIMARY KEY
		CLUSTERED
		([TC_CodigoBanco])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene los bancos para cálculos de tasas de interés', 'SCHEMA', N'Catalogo', 'TABLE', N'Banco', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de banco', 'SCHEMA', N'Catalogo', 'TABLE', N'Banco', 'COLUMN', N'TC_CodigoBanco'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del banco', 'SCHEMA', N'Catalogo', 'TABLE', N'Banco', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha inicio de vigencia del banco', 'SCHEMA', N'Catalogo', 'TABLE', N'Banco', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha fin de vigencia del banco', 'SCHEMA', N'Catalogo', 'TABLE', N'Banco', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Banco] SET (LOCK_ESCALATION = TABLE)
GO

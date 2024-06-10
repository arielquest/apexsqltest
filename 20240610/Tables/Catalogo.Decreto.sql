SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Decreto] (
		[TC_CodigoDecreto]        [varchar](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]          [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]      [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]         [datetime2](7) NULL,
		[TF_FechaPublicacion]     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Decreto]
		PRIMARY KEY
		CLUSTERED
		([TC_CodigoDecreto])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene los decretos para cálculo de costas personales', 'SCHEMA', N'Catalogo', 'TABLE', N'Decreto', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de decreto', 'SCHEMA', N'Catalogo', 'TABLE', N'Decreto', 'COLUMN', N'TC_CodigoDecreto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del decreto', 'SCHEMA', N'Catalogo', 'TABLE', N'Decreto', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha inicio vigencia del decreto', 'SCHEMA', N'Catalogo', 'TABLE', N'Decreto', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha fin vigencia del decreto', 'SCHEMA', N'Catalogo', 'TABLE', N'Decreto', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de publicación del decreto', 'SCHEMA', N'Catalogo', 'TABLE', N'Decreto', 'COLUMN', N'TF_FechaPublicacion'
GO
ALTER TABLE [Catalogo].[Decreto] SET (LOCK_ESCALATION = TABLE)
GO

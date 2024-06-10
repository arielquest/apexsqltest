SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoCaso] (
		[TN_CodTipoCaso]         [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[TCL_CLASE]              [varchar](13) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_TipoCaso]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoCaso])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoCaso]
	ADD
	CONSTRAINT [DF_TipoCaso_TN_CodTipoCaso]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoCaso]) FOR [TN_CodTipoCaso]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico del tipo de caso', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoCaso', 'COLUMN', N'TN_CodTipoCaso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion del tipo de caso', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoCaso', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoCaso', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de finalizacion', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoCaso', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoCaso] SET (LOCK_ESCALATION = TABLE)
GO

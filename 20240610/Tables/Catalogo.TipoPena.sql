SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoPena] (
		[TN_CodTipoPena]         [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[TPT_TIPO]               [varchar](3) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_TipoPena]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoPena])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoPena]
	ADD
	CONSTRAINT [DF_TipoPena_TN_CodTipoPena]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoPena]) FOR [TN_CodTipoPena]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de pena.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPena', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de pena.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPena', 'COLUMN', N'TN_CodTipoPena'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de pena.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPena', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPena', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoPena', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoPena] SET (LOCK_ESCALATION = TABLE)
GO

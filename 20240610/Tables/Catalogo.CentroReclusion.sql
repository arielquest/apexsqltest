SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[CentroReclusion] (
		[TN_CodCentroReclusion]     [tinyint] NOT NULL,
		[TC_Descripcion]            [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]           [datetime2](7) NULL,
		[CODCENREC]                 [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_CentroReclusion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodCentroReclusion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[CentroReclusion]
	ADD
	CONSTRAINT [DF_CentroReclusion_TN_CodCentroReclusion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaCentroReclusion]) FOR [TN_CodCentroReclusion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de centros de reclusión.', 'SCHEMA', N'Catalogo', 'TABLE', N'CentroReclusion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del centro de reclusión.', 'SCHEMA', N'Catalogo', 'TABLE', N'CentroReclusion', 'COLUMN', N'TN_CodCentroReclusion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del centro de reclusión.', 'SCHEMA', N'Catalogo', 'TABLE', N'CentroReclusion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'CentroReclusion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'CentroReclusion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[CentroReclusion] SET (LOCK_ESCALATION = TABLE)
GO

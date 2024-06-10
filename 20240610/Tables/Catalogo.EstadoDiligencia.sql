SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoDiligencia] (
		[TN_CodEstadoDiligencia]     [smallint] NOT NULL,
		[TC_Descripcion]             [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]         [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]            [datetime2](7) NULL,
		[TDR_RESULTADO]              [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_EstadoDiligencia]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstadoDiligencia])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoDiligencia]
	ADD
	CONSTRAINT [DF_EstadoDiligencia_TN_CodEstadoDiligencia]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEstadoDiligencia]) FOR [TN_CodEstadoDiligencia]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de estados de diligencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoDiligencia', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado de diligencia.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoDiligencia', 'COLUMN', N'TN_CodEstadoDiligencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del estado de diligencia.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoDiligencia', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoDiligencia', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoDiligencia', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[EstadoDiligencia] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoProfesional] (
		[TN_CodTipoProfesional]     [smallint] NOT NULL,
		[TC_Descripcion]            [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]           [datetime2](7) NULL,
		CONSTRAINT [PK_TipoProfesional]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoProfesional])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoProfesional]
	ADD
	CONSTRAINT [DF_TipoProfesional_TN_CodTipoProfesional]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoProfesional]) FOR [TN_CodTipoProfesional]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de profesional.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoProfesional', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de profesional.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoProfesional', 'COLUMN', N'TN_CodTipoProfesional'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de profesional.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoProfesional', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoProfesional', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoProfesional', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoProfesional] SET (LOCK_ESCALATION = TABLE)
GO

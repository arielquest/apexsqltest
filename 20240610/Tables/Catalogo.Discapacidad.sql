SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Discapacidad] (
		[TN_CodDiscapacidad]     [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_Discapacidad]
		PRIMARY KEY
		CLUSTERED
		([TN_CodDiscapacidad])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Discapacidad]
	ADD
	CONSTRAINT [DF_Discapacidad_TN_CodDiscapacidad]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaDiscapacidad]) FOR [TN_CodDiscapacidad]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de discapacidades del interviniente.', 'SCHEMA', N'Catalogo', 'TABLE', N'Discapacidad', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la discapacidad.', 'SCHEMA', N'Catalogo', 'TABLE', N'Discapacidad', 'COLUMN', N'TN_CodDiscapacidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la discapacidad.', 'SCHEMA', N'Catalogo', 'TABLE', N'Discapacidad', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Discapacidad', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Discapacidad', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Discapacidad] SET (LOCK_ESCALATION = TABLE)
GO

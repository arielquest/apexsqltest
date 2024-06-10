SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MotivoVisita] (
		[TN_CodMotivoVisita]     [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_MotivoVisita]
		PRIMARY KEY
		CLUSTERED
		([TN_CodMotivoVisita])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MotivoVisita]
	ADD
	CONSTRAINT [DF_MotivoVisita_TN_CodMotivoVisita]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaMotivoVisita]) FOR [TN_CodMotivoVisita]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de motivos de visita carcelaria o celdas.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoVisita', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de visita.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoVisita', 'COLUMN', N'TN_CodMotivoVisita'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del motivo de visita.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoVisita', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoVisita', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoVisita', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[MotivoVisita] SET (LOCK_ESCALATION = TABLE)
GO

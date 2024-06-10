SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MotivoAbsolutoria] (
		[TN_CodMotivoAbsolutoria]     [smallint] NOT NULL,
		[TC_Descripcion]              [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]          [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]             [datetime2](7) NULL,
		[TAA_ABSOLUTORIA]             [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_MotivoAbsolutoria]
		PRIMARY KEY
		CLUSTERED
		([TN_CodMotivoAbsolutoria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MotivoAbsolutoria]
	ADD
	CONSTRAINT [DF_MotivoAbsolutoria_TN_CodMotivoAbsolutoria]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaMotivoAbsolutoria]) FOR [TN_CodMotivoAbsolutoria]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de motivos de absolutoria.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoAbsolutoria', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de absolutoria.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoAbsolutoria', 'COLUMN', N'TN_CodMotivoAbsolutoria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del motivo de absolutoria.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoAbsolutoria', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoAbsolutoria', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoAbsolutoria', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[MotivoAbsolutoria] SET (LOCK_ESCALATION = TABLE)
GO

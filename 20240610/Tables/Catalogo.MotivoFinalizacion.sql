SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MotivoFinalizacion] (
		[TN_CodMotivoFinalizacion]     [smallint] NOT NULL,
		[TC_Descripcion]               [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]           [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]              [datetime2](7) NULL,
		CONSTRAINT [PK_MotivoFinalizacion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodMotivoFinalizacion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MotivoFinalizacion]
	ADD
	CONSTRAINT [DF_MotivoFinalizacion_TN_CodMotivoFinalizacion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaMotivoFinalizacion]) FOR [TN_CodMotivoFinalizacion]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo unico del motivo de finalizcion', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoFinalizacion', 'COLUMN', N'TN_CodMotivoFinalizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripcion del motivo', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoFinalizacion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoFinalizacion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoFinalizacion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[MotivoFinalizacion] SET (LOCK_ESCALATION = TABLE)
GO

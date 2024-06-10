SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MotivoEstadoEvento] (
		[TN_CodMotivoEstado]     [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[intIDMotivo]            [int] NULL,
		CONSTRAINT [PK_MotivoEstadoEvento]
		PRIMARY KEY
		CLUSTERED
		([TN_CodMotivoEstado])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MotivoEstadoEvento]
	ADD
	CONSTRAINT [DF_MotivoEstadoEvento_TN_CodMotivoEstado]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaMotivoEstadoEvento]) FOR [TN_CodMotivoEstado]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de motivo de estado de evento de la agenda.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEvento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de estado de evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEvento', 'COLUMN', N'TN_CodMotivoEstado'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del motivo de estado de evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEvento', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEvento', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoEstadoEvento', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[MotivoEstadoEvento] SET (LOCK_ESCALATION = TABLE)
GO

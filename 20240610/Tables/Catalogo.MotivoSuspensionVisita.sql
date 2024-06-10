SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MotivoSuspensionVisita] (
		[TN_CodMotivo]           [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](200) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[TVCS_SUSPENSION]        [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_MotivoSuspencionVisita]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodMotivo])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[MotivoSuspensionVisita]
	ADD
	CONSTRAINT [DF_MotivoSuspencionVisita_TN_CodMotivo]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaMotivoSuspensionVisita]) FOR [TN_CodMotivo]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de motivos de suspencion de visita carcelaria.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoSuspensionVisita', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del motivo de la suspención de la visita.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoSuspensionVisita', 'COLUMN', N'TN_CodMotivo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del motivo de la suspención de la visita.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoSuspensionVisita', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoSuspensionVisita', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MotivoSuspensionVisita', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[MotivoSuspensionVisita] SET (LOCK_ESCALATION = TABLE)
GO

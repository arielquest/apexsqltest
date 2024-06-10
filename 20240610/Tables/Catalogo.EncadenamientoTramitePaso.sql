SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Catalogo].[EncadenamientoTramitePaso] (
		[TU_CodEncadenamientoTramitePaso]     [uniqueidentifier] NOT NULL,
		[TU_CodEncadenamientoTramite]         [uniqueidentifier] NOT NULL,
		[TN_CodOperacionTramite]              [smallint] NOT NULL,
		[TN_Orden]                            [tinyint] NOT NULL,
		[TF_Actualizacion]                    [datetime2](7) NOT NULL,
		CONSTRAINT [PK_EncadenamientoTramitePaso]
		PRIMARY KEY
		CLUSTERED
		([TU_CodEncadenamientoTramitePaso])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[EncadenamientoTramitePaso]
	ADD
	CONSTRAINT [DF_EncadenamientoTramitePaso_TU_CodEncadenamientoTramitePaso]
	DEFAULT (newid()) FOR [TU_CodEncadenamientoTramitePaso]
GO
ALTER TABLE [Catalogo].[EncadenamientoTramitePaso]
	ADD
	CONSTRAINT [DF_EncadenamientoTramitePaso_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Catalogo].[EncadenamientoTramitePaso]
	WITH CHECK
	ADD CONSTRAINT [FK_EncadenamientoTramitePaso_EncadenamientoTramite]
	FOREIGN KEY ([TU_CodEncadenamientoTramite]) REFERENCES [Catalogo].[EncadenamientoTramite] ([TU_CodEncadenamientoTramite])
ALTER TABLE [Catalogo].[EncadenamientoTramitePaso]
	CHECK CONSTRAINT [FK_EncadenamientoTramitePaso_EncadenamientoTramite]

GO
ALTER TABLE [Catalogo].[EncadenamientoTramitePaso]
	WITH CHECK
	ADD CONSTRAINT [FK_EncadenamientoTramitePaso_OperacionTramite]
	FOREIGN KEY ([TN_CodOperacionTramite]) REFERENCES [Catalogo].[OperacionTramite] ([TN_CodOperacionTramite])
ALTER TABLE [Catalogo].[EncadenamientoTramitePaso]
	CHECK CONSTRAINT [FK_EncadenamientoTramitePaso_OperacionTramite]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra los pasos de un encadenamiento trámite.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePaso', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del paso del trámite del encadenamiento (autogenerado).', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePaso', 'COLUMN', N'TU_CodEncadenamientoTramitePaso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del trámite del encadenamiento al cual pertenece el paso.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePaso', 'COLUMN', N'TU_CodEncadenamientoTramite'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de operación al cual pertenece el trámite de encadenamiento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePaso', 'COLUMN', N'TN_CodOperacionTramite'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Orden del paso en el trámite de encadenamiento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePaso', 'COLUMN', N'TN_Orden'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePaso', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Catalogo].[EncadenamientoTramitePaso] SET (LOCK_ESCALATION = TABLE)
GO

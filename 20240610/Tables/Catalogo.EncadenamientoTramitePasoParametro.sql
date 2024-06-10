SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EncadenamientoTramitePasoParametro] (
		[TU_CodEncadenamientoTramitePasoParametro]     [uniqueidentifier] NOT NULL,
		[TN_CodOperacionTramiteParametro]              [smallint] NOT NULL,
		[TU_CodEncadenamientoTramitePaso]              [uniqueidentifier] NOT NULL,
		[TC_CodMateria]                                [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoOficina]                            [smallint] NOT NULL,
		[TC_Valor]                                     [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]                             [datetime2](7) NOT NULL,
		CONSTRAINT [PK_EncadenamientoTramitePasoParametro]
		PRIMARY KEY
		CLUSTERED
		([TU_CodEncadenamientoTramitePasoParametro])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[EncadenamientoTramitePasoParametro]
	ADD
	CONSTRAINT [DF_EncadenamientoTramitePasoParametro_TU_CodEncadenamientoTramitePasoParametro]
	DEFAULT (newid()) FOR [TU_CodEncadenamientoTramitePasoParametro]
GO
ALTER TABLE [Catalogo].[EncadenamientoTramitePasoParametro]
	ADD
	CONSTRAINT [DF_EncadenamientoTramitePasoParametro_TF_Actualizacion]
	DEFAULT (getdate()) FOR [TF_Actualizacion]
GO
ALTER TABLE [Catalogo].[EncadenamientoTramitePasoParametro]
	WITH CHECK
	ADD CONSTRAINT [FK_EncadenamientoTramitePasoParametro_EncadenamientoTramitePaso]
	FOREIGN KEY ([TU_CodEncadenamientoTramitePaso]) REFERENCES [Catalogo].[EncadenamientoTramitePaso] ([TU_CodEncadenamientoTramitePaso])
ALTER TABLE [Catalogo].[EncadenamientoTramitePasoParametro]
	CHECK CONSTRAINT [FK_EncadenamientoTramitePasoParametro_EncadenamientoTramitePaso]

GO
ALTER TABLE [Catalogo].[EncadenamientoTramitePasoParametro]
	WITH CHECK
	ADD CONSTRAINT [FK_EncadenamientoTramitePasoParametro_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[EncadenamientoTramitePasoParametro]
	CHECK CONSTRAINT [FK_EncadenamientoTramitePasoParametro_Materia]

GO
ALTER TABLE [Catalogo].[EncadenamientoTramitePasoParametro]
	WITH CHECK
	ADD CONSTRAINT [FK_EncadenamientoTramitePasoParametro_OperacionTramiteParametro]
	FOREIGN KEY ([TN_CodOperacionTramiteParametro]) REFERENCES [Catalogo].[OperacionTramiteParametro] ([TN_CodOperacionTramiteParametro])
ALTER TABLE [Catalogo].[EncadenamientoTramitePasoParametro]
	CHECK CONSTRAINT [FK_EncadenamientoTramitePasoParametro_OperacionTramiteParametro]

GO
ALTER TABLE [Catalogo].[EncadenamientoTramitePasoParametro]
	WITH CHECK
	ADD CONSTRAINT [FK_EncadenamientoTramitePasoParametro_PasoEncadenamiento]
	FOREIGN KEY ([TU_CodEncadenamientoTramitePasoParametro]) REFERENCES [Catalogo].[EncadenamientoTramitePasoParametro] ([TU_CodEncadenamientoTramitePasoParametro])
ALTER TABLE [Catalogo].[EncadenamientoTramitePasoParametro]
	CHECK CONSTRAINT [FK_EncadenamientoTramitePasoParametro_PasoEncadenamiento]

GO
ALTER TABLE [Catalogo].[EncadenamientoTramitePasoParametro]
	WITH CHECK
	ADD CONSTRAINT [FK_EncadenamientoTramitePasoParametro_TipoOficina]
	FOREIGN KEY ([TN_CodTipoOficina]) REFERENCES [Catalogo].[TipoOficina] ([TN_CodTipoOficina])
ALTER TABLE [Catalogo].[EncadenamientoTramitePasoParametro]
	CHECK CONSTRAINT [FK_EncadenamientoTramitePasoParametro_TipoOficina]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra los parámetros que tienen valor en un paso de encadenamiento trámite.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePasoParametro', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del parámetro de la operación en el paso dentro del trámite de encadenamiento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePasoParametro', 'COLUMN', N'TU_CodEncadenamientoTramitePasoParametro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de parámetro de operación.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePasoParametro', 'COLUMN', N'TN_CodOperacionTramiteParametro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del paso al que está relacionado el parámetro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePasoParametro', 'COLUMN', N'TU_CodEncadenamientoTramitePaso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePasoParametro', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePasoParametro', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor del parámetro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePasoParametro', 'COLUMN', N'TC_Valor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de actualización del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoTramitePasoParametro', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Catalogo].[EncadenamientoTramitePasoParametro] SET (LOCK_ESCALATION = TABLE)
GO

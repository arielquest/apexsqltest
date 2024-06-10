SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[PasoEncadenamientoOperacionParametro] (
		[TN_CodPasoEncadenamientoOperacionParametro]     [smallint] NOT NULL,
		[TN_CodOperacionTramiteParametro]                [smallint] NOT NULL,
		[TN_CodEncadenamientoFormatoJuridico]            [int] NOT NULL,
		[TN_Orden]                                       [tinyint] NOT NULL,
		[TC_Valor]                                       [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		CONSTRAINT [PK_PasoEncadenamientoOperacionParametro]
		PRIMARY KEY
		CLUSTERED
		([TN_CodPasoEncadenamientoOperacionParametro])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[PasoEncadenamientoOperacionParametro]
	ADD
	CONSTRAINT [DF_PasoEncadenamientoOperacionParametro_TN_CodPasoEncadenamientoOperacionParametro]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaPasoEncadenamientoOperacionParametro]) FOR [TN_CodPasoEncadenamientoOperacionParametro]
GO
ALTER TABLE [Catalogo].[PasoEncadenamientoOperacionParametro]
	WITH CHECK
	ADD CONSTRAINT [FK_PasoEncadenamientoOperacionParametro_OperacionTramiteParametro]
	FOREIGN KEY ([TN_CodOperacionTramiteParametro]) REFERENCES [Catalogo].[OperacionTramiteParametro] ([TN_CodOperacionTramiteParametro])
ALTER TABLE [Catalogo].[PasoEncadenamientoOperacionParametro]
	CHECK CONSTRAINT [FK_PasoEncadenamientoOperacionParametro_OperacionTramiteParametro]

GO
ALTER TABLE [Catalogo].[PasoEncadenamientoOperacionParametro]
	WITH CHECK
	ADD CONSTRAINT [FK_PasoEncadenamientoOperacionParametro_PasoEncadenamientoFormatoJuridico]
	FOREIGN KEY ([TN_CodEncadenamientoFormatoJuridico], [TN_Orden]) REFERENCES [Catalogo].[PasoEncadenamientoFormatoJuridico] ([TN_CodEncadenamientoFormatoJuridico], [TN_Orden])
ALTER TABLE [Catalogo].[PasoEncadenamientoOperacionParametro]
	CHECK CONSTRAINT [FK_PasoEncadenamientoOperacionParametro_PasoEncadenamientoFormatoJuridico]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra los pasos de un encadenamiento de operaciones, cuando corresponde a un paso tipo operación', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoOperacionParametro', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del paso dentro del encadenamiento de formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoOperacionParametro', 'COLUMN', N'TN_CodPasoEncadenamientoOperacionParametro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de parámetro de operación.', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoOperacionParametro', 'COLUMN', N'TN_CodOperacionTramiteParametro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador del encadenamiento de tipo formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoOperacionParametro', 'COLUMN', N'TN_CodEncadenamientoFormatoJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Orden del paso en el encadenamiento de formato jurídico  al que está relacionado el parámtetro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoOperacionParametro', 'COLUMN', N'TN_Orden'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor del parámetro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoOperacionParametro', 'COLUMN', N'TC_Valor'
GO
ALTER TABLE [Catalogo].[PasoEncadenamientoOperacionParametro] SET (LOCK_ESCALATION = TABLE)
GO

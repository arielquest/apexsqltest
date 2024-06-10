SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[PasoEncadenamientoFormatoJuridico] (
		[TN_CodEncadenamientoFormatoJuridico]     [int] NOT NULL,
		[TN_CodTipoOficina]                       [smallint] NULL,
		[TC_CodMateria]                           [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodFormatoJuridico]                   [varchar](8) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_Orden]                                [tinyint] NOT NULL,
		[TF_Actualizacion]                        [datetime2](7) NOT NULL,
		[TN_CodOperacionTramite]                  [smallint] NULL,
		CONSTRAINT [PK_PasoEncadenamientoFormatoJuridico]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEncadenamientoFormatoJuridico], [TN_Orden])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[PasoEncadenamientoFormatoJuridico]
	WITH CHECK
	ADD CONSTRAINT [FK_PasoEncadenamientoFormatoJuridico_EncadenamientoFormatoJuridico]
	FOREIGN KEY ([TN_CodEncadenamientoFormatoJuridico]) REFERENCES [Catalogo].[EncadenamientoFormatoJuridico] ([TN_CodEncadenamientoFormatoJuridico])
ALTER TABLE [Catalogo].[PasoEncadenamientoFormatoJuridico]
	CHECK CONSTRAINT [FK_PasoEncadenamientoFormatoJuridico_EncadenamientoFormatoJuridico]

GO
ALTER TABLE [Catalogo].[PasoEncadenamientoFormatoJuridico]
	WITH CHECK
	ADD CONSTRAINT [FK_PasoEncadenamientoFormatoJuridico_FormatoJuridicoTipoOficina]
	FOREIGN KEY ([TC_CodFormatoJuridico], [TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[FormatoJuridicoTipoOficina] ([TC_CodFormatoJuridico], [TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[PasoEncadenamientoFormatoJuridico]
	CHECK CONSTRAINT [FK_PasoEncadenamientoFormatoJuridico_FormatoJuridicoTipoOficina]

GO
ALTER TABLE [Catalogo].[PasoEncadenamientoFormatoJuridico]
	WITH CHECK
	ADD CONSTRAINT [FK_PasoEncadenamientoFormatoJuridico_OperacionTramite]
	FOREIGN KEY ([TN_CodOperacionTramite]) REFERENCES [Catalogo].[OperacionTramite] ([TN_CodOperacionTramite])
ALTER TABLE [Catalogo].[PasoEncadenamientoFormatoJuridico]
	CHECK CONSTRAINT [FK_PasoEncadenamientoFormatoJuridico_OperacionTramite]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra los pasos de un encadenamiento de formato jurídico, siendo cada paso un formato jurídico o una operación.', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoFormatoJuridico', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador del encadenamiento.', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoFormatoJuridico', 'COLUMN', N'TN_CodEncadenamientoFormatoJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de oficina asociado al formato jurídico del paso.', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoFormatoJuridico', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia asociada al formato jurídico del paso.', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoFormatoJuridico', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del formato jurídico del paso.', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoFormatoJuridico', 'COLUMN', N'TC_CodFormatoJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Orden o paso del formato en el encadenamiento.', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoFormatoJuridico', 'COLUMN', N'TN_Orden'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la última actualización del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoFormatoJuridico', 'COLUMN', N'TF_Actualizacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del trámite relacionado al paso.', 'SCHEMA', N'Catalogo', 'TABLE', N'PasoEncadenamientoFormatoJuridico', 'COLUMN', N'TN_CodOperacionTramite'
GO
ALTER TABLE [Catalogo].[PasoEncadenamientoFormatoJuridico] SET (LOCK_ESCALATION = TABLE)
GO

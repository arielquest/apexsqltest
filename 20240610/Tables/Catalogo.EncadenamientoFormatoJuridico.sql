SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EncadenamientoFormatoJuridico] (
		[TN_CodEncadenamientoFormatoJuridico]     [int] NOT NULL,
		[TN_CodTipoOficina]                       [smallint] NOT NULL,
		[TC_CodMateria]                           [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodFormatoJuridico]                   [varchar](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Actualizacion]                        [datetime2](7) NOT NULL,
		CONSTRAINT [PK_EncadenamientoFormatoJuridico]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEncadenamientoFormatoJuridico])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[EncadenamientoFormatoJuridico]
	ADD
	CONSTRAINT [DF_EncadenamientoFormatoJuridico_TN_CodEncadenamientoFormatoJuridico]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEncadenamientoFormatoJuridico]) FOR [TN_CodEncadenamientoFormatoJuridico]
GO
ALTER TABLE [Catalogo].[EncadenamientoFormatoJuridico]
	WITH CHECK
	ADD CONSTRAINT [FK_EncadenamientoFormatoJuridico_FormatoJuridicoTipoOficina]
	FOREIGN KEY ([TC_CodFormatoJuridico], [TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[FormatoJuridicoTipoOficina] ([TC_CodFormatoJuridico], [TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[EncadenamientoFormatoJuridico]
	CHECK CONSTRAINT [FK_EncadenamientoFormatoJuridico_FormatoJuridicoTipoOficina]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Registra asociaciones de formatos jurídicos para poder generar documentos en secuencia', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoFormatoJuridico', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código identificador del encadenamiento', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoFormatoJuridico', 'COLUMN', N'TN_CodEncadenamientoFormatoJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de oficina asociado al formato jurídico', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoFormatoJuridico', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia asociada al formato jurídico', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoFormatoJuridico', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del formato jurídico que inicia el encadenamiento', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoFormatoJuridico', 'COLUMN', N'TC_CodFormatoJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de la última actualización del registro', 'SCHEMA', N'Catalogo', 'TABLE', N'EncadenamientoFormatoJuridico', 'COLUMN', N'TF_Actualizacion'
GO
ALTER TABLE [Catalogo].[EncadenamientoFormatoJuridico] SET (LOCK_ESCALATION = TABLE)
GO

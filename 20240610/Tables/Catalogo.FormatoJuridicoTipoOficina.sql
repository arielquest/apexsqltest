SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[FormatoJuridicoTipoOficina] (
		[TC_CodFormatoJuridico]     [varchar](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoOficina]         [smallint] NOT NULL,
		[TC_CodMateria]             [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]        [datetime2](7) NOT NULL,
		[TB_EsResolucion]           [bit] NOT NULL,
		[TN_CodTipoResolucion]      [smallint] NULL,
		[TB_CalculoIntereses]       [bit] NOT NULL,
		CONSTRAINT [PK_FormatoJuridicoTipoOficina]
		PRIMARY KEY
		CLUSTERED
		([TC_CodFormatoJuridico], [TN_CodTipoOficina], [TC_CodMateria])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[FormatoJuridicoTipoOficina]
	ADD
	CONSTRAINT [DF__FormatoJu__TB_Es__1097FD01]
	DEFAULT ((0)) FOR [TB_EsResolucion]
GO
ALTER TABLE [Catalogo].[FormatoJuridicoTipoOficina]
	ADD
	CONSTRAINT [DF__FormatoJu__TB_Ca__29F8A7A8]
	DEFAULT ((0)) FOR [TB_CalculoIntereses]
GO
ALTER TABLE [Catalogo].[FormatoJuridicoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_FormatoJuridicoTipoOficina_FormatoJuridico]
	FOREIGN KEY ([TC_CodFormatoJuridico]) REFERENCES [Catalogo].[FormatoJuridico] ([TC_CodFormatoJuridico])
ALTER TABLE [Catalogo].[FormatoJuridicoTipoOficina]
	CHECK CONSTRAINT [FK_FormatoJuridicoTipoOficina_FormatoJuridico]

GO
ALTER TABLE [Catalogo].[FormatoJuridicoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_FormatoJuridicoTipoOficina_TipoOficinaMateria]
	FOREIGN KEY ([TN_CodTipoOficina], [TC_CodMateria]) REFERENCES [Catalogo].[TipoOficinaMateria] ([TN_CodTipoOficina], [TC_CodMateria])
ALTER TABLE [Catalogo].[FormatoJuridicoTipoOficina]
	CHECK CONSTRAINT [FK_FormatoJuridicoTipoOficina_TipoOficinaMateria]

GO
ALTER TABLE [Catalogo].[FormatoJuridicoTipoOficina]
	WITH CHECK
	ADD CONSTRAINT [FK_FormatoJuridicoTipoOficina_TipoResolucion]
	FOREIGN KEY ([TN_CodTipoResolucion]) REFERENCES [Catalogo].[TipoResolucion] ([TN_CodTipoResolucion])
ALTER TABLE [Catalogo].[FormatoJuridicoTipoOficina]
	CHECK CONSTRAINT [FK_FormatoJuridicoTipoOficina_TipoResolucion]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que relaciona el formato jurídico con el tipo de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoTipoOficina', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la plantilla de formato jurídico.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoTipoOficina', 'COLUMN', N'TC_CodFormatoJuridico'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoTipoOficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoTipoOficina', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoTipoOficina', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el documento es de tipo resolucion', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoTipoOficina', 'COLUMN', N'TB_EsResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el tipo de resoluciòn ', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoTipoOficina', 'COLUMN', N'TN_CodTipoResolucion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el formato jurídico en el tipo de oficina se usa para cálculo de intereses', 'SCHEMA', N'Catalogo', 'TABLE', N'FormatoJuridicoTipoOficina', 'COLUMN', N'TB_CalculoIntereses'
GO
ALTER TABLE [Catalogo].[FormatoJuridicoTipoOficina] SET (LOCK_ESCALATION = TABLE)
GO

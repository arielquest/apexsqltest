SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[MateriaTipoIntervencion] (
		[TC_CodMateria]                 [varchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodTipoIntervencion]        [smallint] NOT NULL,
		[TF_Inicio_Vigencia]            [datetime2](7) NULL,
		[TB_PuedeSolicitarDefensor]     [bit] NOT NULL,
		[TB_VinculoAgresor]             [bit] NULL,
		CONSTRAINT [PK_MateriaTipoIntervencion]
		PRIMARY KEY
		CLUSTERED
		([TC_CodMateria], [TN_CodTipoIntervencion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[MateriaTipoIntervencion]
	ADD
	CONSTRAINT [DF__MateriaTi__TB_Pu__7C3111A1]
	DEFAULT ((0)) FOR [TB_PuedeSolicitarDefensor]
GO
ALTER TABLE [Catalogo].[MateriaTipoIntervencion]
	ADD
	CONSTRAINT [DF__MateriaTi__TB_Vi__1F9027CE]
	DEFAULT ((0)) FOR [TB_VinculoAgresor]
GO
ALTER TABLE [Catalogo].[MateriaTipoIntervencion]
	WITH CHECK
	ADD CONSTRAINT [FK_MateriaTipoIntervencion_Materia]
	FOREIGN KEY ([TC_CodMateria]) REFERENCES [Catalogo].[Materia] ([TC_CodMateria])
ALTER TABLE [Catalogo].[MateriaTipoIntervencion]
	CHECK CONSTRAINT [FK_MateriaTipoIntervencion_Materia]

GO
ALTER TABLE [Catalogo].[MateriaTipoIntervencion]
	WITH CHECK
	ADD CONSTRAINT [FK_MateriaTipoIntervencion_TipoIntervencion]
	FOREIGN KEY ([TN_CodTipoIntervencion]) REFERENCES [Catalogo].[TipoIntervencion] ([TN_CodTipoIntervencion])
ALTER TABLE [Catalogo].[MateriaTipoIntervencion]
	CHECK CONSTRAINT [FK_MateriaTipoIntervencion_TipoIntervencion]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia las materias con sus tipos de intervención.', 'SCHEMA', N'Catalogo', 'TABLE', N'MateriaTipoIntervencion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la materia.', 'SCHEMA', N'Catalogo', 'TABLE', N'MateriaTipoIntervencion', 'COLUMN', N'TC_CodMateria'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de intervención.', 'SCHEMA', N'Catalogo', 'TABLE', N'MateriaTipoIntervencion', 'COLUMN', N'TN_CodTipoIntervencion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'MateriaTipoIntervencion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si para el tipo de intervención en la materia se le puede asignar una representeación pública.', 'SCHEMA', N'Catalogo', 'TABLE', N'MateriaTipoIntervencion', 'COLUMN', N'TB_PuedeSolicitarDefensor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si este tipo de intervención en esta materia presenta una relación con el tipo de intervención de la persona acusada.', 'SCHEMA', N'Catalogo', 'TABLE', N'MateriaTipoIntervencion', 'COLUMN', N'TB_VinculoAgresor'
GO
ALTER TABLE [Catalogo].[MateriaTipoIntervencion] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Oficina] (
		[TC_CodOficina]               [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodCategoriaOficina]      [char](1) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Nombre]                   [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodCircuito]              [smallint] NOT NULL,
		[TN_CodTipoOficina]           [smallint] NOT NULL,
		[TC_DescripcionAbreviada]     [varchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Domicilio]                [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Inicio_Vigencia]          [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]             [datetime2](3) NULL,
		[TC_CodOficinaOCJ]            [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_CodOficinaDefensa]        [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Oficina]
		PRIMARY KEY
		CLUSTERED
		([TC_CodOficina])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Oficina]
	ADD
	CONSTRAINT [CK_CategoriaOficina]
	CHECK
	([TC_CodCategoriaOficina]='C' OR [TC_CodCategoriaOficina]='E' OR [TC_CodCategoriaOficina]='F' OR [TC_CodCategoriaOficina]='I' OR [TC_CodCategoriaOficina]='J' OR [TC_CodCategoriaOficina]='P' OR [TC_CodCategoriaOficina]='R' OR [TC_CodCategoriaOficina]='O' OR [TC_CodCategoriaOficina]='D')
GO
ALTER TABLE [Catalogo].[Oficina]
CHECK CONSTRAINT [CK_CategoriaOficina]
GO
ALTER TABLE [Catalogo].[Oficina]
	ADD
	CONSTRAINT [CK_Oficina_CategoriaOficina]
	CHECK
	([TC_CodCategoriaOficina]='C' OR [TC_CodCategoriaOficina]='E' OR [TC_CodCategoriaOficina]='F' OR [TC_CodCategoriaOficina]='I' OR [TC_CodCategoriaOficina]='J' OR [TC_CodCategoriaOficina]='P' OR [TC_CodCategoriaOficina]='R' OR [TC_CodCategoriaOficina]='O' OR [TC_CodCategoriaOficina]='D')
GO
ALTER TABLE [Catalogo].[Oficina]
CHECK CONSTRAINT [CK_Oficina_CategoriaOficina]
GO
ALTER TABLE [Catalogo].[Oficina]
	WITH CHECK
	ADD CONSTRAINT [FK_Oficina_Circuito]
	FOREIGN KEY ([TN_CodCircuito]) REFERENCES [Catalogo].[Circuito] ([TN_CodCircuito])
ALTER TABLE [Catalogo].[Oficina]
	CHECK CONSTRAINT [FK_Oficina_Circuito]

GO
ALTER TABLE [Catalogo].[Oficina]
	WITH CHECK
	ADD CONSTRAINT [FK_Oficina_Oficina]
	FOREIGN KEY ([TC_CodOficinaOCJ]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Catalogo].[Oficina]
	CHECK CONSTRAINT [FK_Oficina_Oficina]

GO
ALTER TABLE [Catalogo].[Oficina]
	WITH CHECK
	ADD CONSTRAINT [FK_Oficina_OficinaDefensa]
	FOREIGN KEY ([TC_CodOficinaDefensa]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Catalogo].[Oficina]
	CHECK CONSTRAINT [FK_Oficina_OficinaDefensa]

GO
ALTER TABLE [Catalogo].[Oficina]
	WITH CHECK
	ADD CONSTRAINT [FK_Oficina_TipoOficina]
	FOREIGN KEY ([TN_CodTipoOficina]) REFERENCES [Catalogo].[TipoOficina] ([TN_CodTipoOficina])
ALTER TABLE [Catalogo].[Oficina]
	CHECK CONSTRAINT [FK_Oficina_TipoOficina]

GO
CREATE NONCLUSTERED INDEX [IX_Oficina_ConsultarOficina]
	ON [Catalogo].[Oficina] ([TC_Nombre], [TF_Inicio_Vigencia], [TF_Fin_Vigencia])
	INCLUDE ([TC_CodOficina], [TN_CodCircuito], [TN_CodTipoOficina], [TC_DescripcionAbreviada], [TC_Domicilio], [TC_CodCategoriaOficina], [TC_CodOficinaDefensa])
	ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Índice para optimizar Catalogo.PA_ConsultarOficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'Oficina', 'INDEX', N'IX_Oficina_ConsultarOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de oficinas del Poder Judicial.', 'SCHEMA', N'Catalogo', 'TABLE', N'Oficina', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la oficina dado por planificación.', 'SCHEMA', N'Catalogo', 'TABLE', N'Oficina', 'COLUMN', N'TC_CodOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de categoría de la oficina el cual es un check constraint para que acepte solo los definidos en el enumerador: Centros Penitenciarios = ''C'', Colegios Profesionales = ''E'', Funcional u operativa = ''F'', Orgánica Judicial Invisible = ''I'', Orgánica Judicial = ''J'', Orgánica Judicial de representación y parte (fiscalías del estado) = ''P'', Externa Relacionada = ''R'', Oficinas de Comunicaciones Judiciales (OCJ) = ''O'', Oficinas de la Defensa Pública = ''D''', 'SCHEMA', N'Catalogo', 'TABLE', N'Oficina', 'COLUMN', N'TC_CodCategoriaOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre del despacho judicial o oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'Oficina', 'COLUMN', N'TC_Nombre'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del circuito al que pertenece la oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'Oficina', 'COLUMN', N'TN_CodCircuito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del tipo de oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'Oficina', 'COLUMN', N'TN_CodTipoOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción abreviada de la oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'Oficina', 'COLUMN', N'TC_DescripcionAbreviada'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dirección de la oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'Oficina', 'COLUMN', N'TC_Domicilio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Oficina', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Oficina', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la oficina OCJ a la cual deben enviarse las comunicaciones judiciales.', 'SCHEMA', N'Catalogo', 'TABLE', N'Oficina', 'COLUMN', N'TC_CodOficinaOCJ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de oficina de defensa', 'SCHEMA', N'Catalogo', 'TABLE', N'Oficina', 'COLUMN', N'TC_CodOficinaDefensa'
GO
ALTER TABLE [Catalogo].[Oficina] SET (LOCK_ESCALATION = TABLE)
GO

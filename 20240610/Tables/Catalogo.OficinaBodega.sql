SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[OficinaBodega] (
		[TC_CodOficina]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodBodega]           [smallint] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Catalogo_OficinaBodega]
		PRIMARY KEY
		CLUSTERED
		([TC_CodOficina], [TN_CodBodega])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[OficinaBodega]
	WITH CHECK
	ADD CONSTRAINT [FK_Bodega]
	FOREIGN KEY ([TN_CodBodega]) REFERENCES [Catalogo].[Bodega] ([TN_CodBodega])
ALTER TABLE [Catalogo].[OficinaBodega]
	CHECK CONSTRAINT [FK_Bodega]

GO
ALTER TABLE [Catalogo].[OficinaBodega]
	WITH CHECK
	ADD CONSTRAINT [FK_Oficina]
	FOREIGN KEY ([TC_CodOficina]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Catalogo].[OficinaBodega]
	CHECK CONSTRAINT [FK_Oficina]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que asocia a la oficina a las Bodegas.', 'SCHEMA', N'Catalogo', 'TABLE', N'OficinaBodega', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo Oficina.', 'SCHEMA', N'Catalogo', 'TABLE', N'OficinaBodega', 'COLUMN', N'TC_CodOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo Bodega.', 'SCHEMA', N'Catalogo', 'TABLE', N'OficinaBodega', 'COLUMN', N'TN_CodBodega'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'OficinaBodega', 'COLUMN', N'TF_Inicio_Vigencia'
GO
ALTER TABLE [Catalogo].[OficinaBodega] SET (LOCK_ESCALATION = TABLE)
GO

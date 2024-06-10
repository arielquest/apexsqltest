SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Seccion] (
		[TN_CodSeccion]          [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodOficina]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodBodega]           [smallint] NOT NULL,
		[TC_Observacion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](3) NULL,
		CONSTRAINT [PK_Catalogo_Seccion]
		PRIMARY KEY
		CLUSTERED
		([TN_CodSeccion])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Seccion]
	ADD
	CONSTRAINT [DF_Seccion_TN_CodSeccion]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaSeccion]) FOR [TN_CodSeccion]
GO
ALTER TABLE [Catalogo].[Seccion]
	WITH CHECK
	ADD CONSTRAINT [FK_Seccion_OficinaBodega]
	FOREIGN KEY ([TC_CodOficina], [TN_CodBodega]) REFERENCES [Catalogo].[OficinaBodega] ([TC_CodOficina], [TN_CodBodega])
ALTER TABLE [Catalogo].[Seccion]
	CHECK CONSTRAINT [FK_Seccion_OficinaBodega]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipo: "Seccion"', 'SCHEMA', N'Catalogo', 'TABLE', N'Seccion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'Seccion', 'COLUMN', N'TN_CodSeccion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'Seccion', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la Oficina asociada.', 'SCHEMA', N'Catalogo', 'TABLE', N'Seccion', 'COLUMN', N'TC_CodOficina'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la Bodega asociada.', 'SCHEMA', N'Catalogo', 'TABLE', N'Seccion', 'COLUMN', N'TN_CodBodega'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Este campo va a contener la observación detallada de item que se encuentra guardado.', 'SCHEMA', N'Catalogo', 'TABLE', N'Seccion', 'COLUMN', N'TC_Observacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Seccion', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Seccion', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Seccion] SET (LOCK_ESCALATION = TABLE)
GO

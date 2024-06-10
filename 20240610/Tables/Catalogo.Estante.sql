SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Estante] (
		[TN_CodEstante]          [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodSeccion]          [smallint] NOT NULL,
		[TC_Observacion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](3) NULL,
		CONSTRAINT [PK_Catalogo_Estante]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstante])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Estante]
	ADD
	CONSTRAINT [DF_Estante_TN_CodEstante]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEstante]) FOR [TN_CodEstante]
GO
ALTER TABLE [Catalogo].[Estante]
	WITH CHECK
	ADD CONSTRAINT [FK_Estante_Seccion]
	FOREIGN KEY ([TN_CodSeccion]) REFERENCES [Catalogo].[Seccion] ([TN_CodSeccion])
ALTER TABLE [Catalogo].[Estante]
	CHECK CONSTRAINT [FK_Estante_Seccion]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipo: "Estante"', 'SCHEMA', N'Catalogo', 'TABLE', N'Estante', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estante', 'COLUMN', N'TN_CodEstante'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del catálogo.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estante', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la Sección asociada.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estante', 'COLUMN', N'TN_CodSeccion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Este campo va a contener la observación detallada de item que se encuentra guardado.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estante', 'COLUMN', N'TC_Observacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estante', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Estante', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[Estante] SET (LOCK_ESCALATION = TABLE)
GO

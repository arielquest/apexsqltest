SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Comunicacion].[Perimetro] (
		[TN_CodPerimetro]        [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodOficinaOCJ]       [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[id_sector]              [int] NULL,
		CONSTRAINT [PK_Perimetro_1]
		PRIMARY KEY
		CLUSTERED
		([TN_CodPerimetro])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Comunicacion].[Perimetro]
	ADD
	CONSTRAINT [DF_Perimetro_TN_CodPerimetro]
	DEFAULT (NEXT VALUE FOR [Comunicacion].[SecuenciaPerimetro]) FOR [TN_CodPerimetro]
GO
ALTER TABLE [Comunicacion].[Perimetro]
	WITH CHECK
	ADD CONSTRAINT [FK_Perimetro_Oficina]
	FOREIGN KEY ([TC_CodOficinaOCJ]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Comunicacion].[Perimetro]
	CHECK CONSTRAINT [FK_Perimetro_Oficina]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los perímetros  de una OCJ ya que el perímetro puede variar según la materia.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Perimetro', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del perimetro', 'SCHEMA', N'Comunicacion', 'TABLE', N'Perimetro', 'COLUMN', N'TN_CodPerimetro'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del perimetro', 'SCHEMA', N'Comunicacion', 'TABLE', N'Perimetro', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la oficina OCJ', 'SCHEMA', N'Comunicacion', 'TABLE', N'Perimetro', 'COLUMN', N'TC_CodOficinaOCJ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Inicio de vigencia', 'SCHEMA', N'Comunicacion', 'TABLE', N'Perimetro', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fin de vigencia', 'SCHEMA', N'Comunicacion', 'TABLE', N'Perimetro', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Comunicacion].[Perimetro] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[PuebloIndigena] (
		[TN_CodPuebloIndigena]     [smallint] NOT NULL,
		[TC_Descripcion]           [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]       [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]          [datetime2](7) NULL,
		[CODRESERVA]               [varchar](12) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_PuebloIndigena]
		PRIMARY KEY
		CLUSTERED
		([TN_CodPuebloIndigena])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[PuebloIndigena]
	ADD
	CONSTRAINT [DF_PuebloIndigena_TN_CodPuebloIndigena]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaPuebloIndigena]) FOR [TN_CodPuebloIndigena]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de pueblos indigenas.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuebloIndigena', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de pueblo indigena.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuebloIndigena', 'COLUMN', N'TN_CodPuebloIndigena'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del pueblo indigena.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuebloIndigena', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuebloIndigena', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'PuebloIndigena', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[PuebloIndigena] SET (LOCK_ESCALATION = TABLE)
GO

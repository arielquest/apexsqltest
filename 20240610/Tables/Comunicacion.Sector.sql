SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Comunicacion].[Sector] (
		[TN_CodSector]           [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodOficinaOCJ]       [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[TB_UtilizaAppMovil]     [bit] NOT NULL,
		CONSTRAINT [PK_Sector]
		PRIMARY KEY
		CLUSTERED
		([TN_CodSector])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Comunicacion].[Sector]
	ADD
	CONSTRAINT [DF_Sector_TN_CodSector]
	DEFAULT (NEXT VALUE FOR [Comunicacion].[SecuenciaSector]) FOR [TN_CodSector]
GO
ALTER TABLE [Comunicacion].[Sector]
	ADD
	CONSTRAINT [DF__Sector__TB_Utili__39987BE6]
	DEFAULT ((0)) FOR [TB_UtilizaAppMovil]
GO
ALTER TABLE [Comunicacion].[Sector]
	WITH CHECK
	ADD CONSTRAINT [FK_Sector_Oficina]
	FOREIGN KEY ([TC_CodOficinaOCJ]) REFERENCES [Catalogo].[Oficina] ([TC_CodOficina])
ALTER TABLE [Comunicacion].[Sector]
	CHECK CONSTRAINT [FK_Sector_Oficina]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Almacena los sectores de la OCJ.', 'SCHEMA', N'Comunicacion', 'TABLE', N'Sector', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del sector', 'SCHEMA', N'Comunicacion', 'TABLE', N'Sector', 'COLUMN', N'TN_CodSector'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del sector', 'SCHEMA', N'Comunicacion', 'TABLE', N'Sector', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la oficina OCJ', 'SCHEMA', N'Comunicacion', 'TABLE', N'Sector', 'COLUMN', N'TC_CodOficinaOCJ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Inicio de vigencia', 'SCHEMA', N'Comunicacion', 'TABLE', N'Sector', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fin de vigencia', 'SCHEMA', N'Comunicacion', 'TABLE', N'Sector', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Comunicacion].[Sector] SET (LOCK_ESCALATION = TABLE)
GO

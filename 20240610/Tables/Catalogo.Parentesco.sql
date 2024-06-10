SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Parentesco] (
		[TC_CodParentesco]       [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_Nivel]               [smallint] NOT NULL,
		[TC_TipoParentesco]      [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[CODRELACION]            [varchar](9) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_TipoParentesco]
		PRIMARY KEY
		CLUSTERED
		([TC_CodParentesco])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Parentesco]
	ADD
	CONSTRAINT [CK_TipoParentesco]
	CHECK
	([TC_TipoParentesco]='S' OR [TC_TipoParentesco]='A')
GO
ALTER TABLE [Catalogo].[Parentesco]
CHECK CONSTRAINT [CK_TipoParentesco]
GO
ALTER TABLE [Catalogo].[Parentesco]
	ADD
	CONSTRAINT [DF_Parentesco_TC_CodParentesco]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaParentesco]) FOR [TC_CodParentesco]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo para ingresar relacion familiar existente entre dos o mas personas en virtud de la naturaleza, ley o religion.', 'SCHEMA', N'Catalogo', 'TABLE', N'Parentesco', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del parentesco.', 'SCHEMA', N'Catalogo', 'TABLE', N'Parentesco', 'COLUMN', N'TC_CodParentesco'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del parentesco.', 'SCHEMA', N'Catalogo', 'TABLE', N'Parentesco', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el nivel del parentesco.', 'SCHEMA', N'Catalogo', 'TABLE', N'Parentesco', 'COLUMN', N'TN_Nivel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica el tipo de parentesco, S = Consanguinidad, A = Afinidad.', 'SCHEMA', N'Catalogo', 'TABLE', N'Parentesco', 'COLUMN', N'TC_TipoParentesco'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Parentesco', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'Parentesco', 'COLUMN', N'TF_Fin_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Esta columna no se debe utilizar ni para migración ni itineraciones de Gestión, favor utilizar módulo de equivalencias.', 'SCHEMA', N'Catalogo', 'TABLE', N'Parentesco', 'COLUMN', N'CODRELACION'
GO
ALTER TABLE [Catalogo].[Parentesco] SET (LOCK_ESCALATION = TABLE)
GO

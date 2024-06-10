SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Institucion] (
		[TU_CodInstitucion]      [uniqueidentifier] NOT NULL,
		[TC_Cedula_Juridica]     [varchar](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Siglas]              [varchar](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_Institucion]
		PRIMARY KEY
		CLUSTERED
		([TU_CodInstitucion])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[Institucion] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EntidadJuridica] (
		[TC_Identificacion]      [varchar](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Siglas]              [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_Catalogo.EntidadJuridica]
		PRIMARY KEY
		CLUSTERED
		([TC_Identificacion])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[EntidadJuridica]
	ADD
	CONSTRAINT [DF_EntidadJuridica_TF_Inicio_Vigencia]
	DEFAULT (getdate()) FOR [TF_Inicio_Vigencia]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identificación de la identidad jurídica, consta de 10 caracteres numéricos', 'SCHEMA', N'Catalogo', 'TABLE', N'EntidadJuridica', 'COLUMN', N'TC_Identificacion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre de la entidad jurídica', 'SCHEMA', N'Catalogo', 'TABLE', N'EntidadJuridica', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Siglas con las que se conoce la entidad jurídica', 'SCHEMA', N'Catalogo', 'TABLE', N'EntidadJuridica', 'COLUMN', N'TC_Siglas'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro', 'SCHEMA', N'Catalogo', 'TABLE', N'EntidadJuridica', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro', 'SCHEMA', N'Catalogo', 'TABLE', N'EntidadJuridica', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[EntidadJuridica] SET (LOCK_ESCALATION = TABLE)
GO

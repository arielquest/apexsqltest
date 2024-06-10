SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoEntidadJuridica] (
		[TN_CodTipoEntidad]      [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](3) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](3) NULL,
		CONSTRAINT [PK_TipoEntidadJuridica]
		PRIMARY KEY
		NONCLUSTERED
		([TN_CodTipoEntidad])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Catalogo].[TipoEntidadJuridica]
	ADD
	CONSTRAINT [DF_TipoEntidadJuridica_TN_CodTipoEntidad]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoEntidadJuridica]) FOR [TN_CodTipoEntidad]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo que almacena los diferentes tipos de entidades o personas jurídicas (pública, privada, etc).', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEntidadJuridica', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de entidad.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEntidadJuridica', 'COLUMN', N'TN_CodTipoEntidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de entidad.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEntidadJuridica', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEntidadJuridica', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEntidadJuridica', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoEntidadJuridica] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoTelefono] (
		[TN_CodTipoTelefono]     [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](150) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		CONSTRAINT [PK_TipoTelefono]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoTelefono])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoTelefono]
	ADD
	CONSTRAINT [DF_TipoTelefono_TC_CodTipoTelefono]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoTelefono]) FOR [TN_CodTipoTelefono]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de tipos de telefono.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoTelefono', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo teléfono.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoTelefono', 'COLUMN', N'TN_CodTipoTelefono'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del tipo de teléfono.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoTelefono', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoTelefono', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoTelefono', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoTelefono] SET (LOCK_ESCALATION = TABLE)
GO

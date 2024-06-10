SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[TipoEvento] (
		[TN_CodTipoEvento]       [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_ColorEvento]         [nvarchar](50) COLLATE Modern_Spanish_CI_AS NULL,
		[TB_EsRemate]            [bit] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[intTipoApunteID]        [int] NULL,
		CONSTRAINT [PK_TipoEvento]
		PRIMARY KEY
		CLUSTERED
		([TN_CodTipoEvento])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[TipoEvento]
	ADD
	CONSTRAINT [DF_TipoEvento_TN_CodTipoEvento]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaTipoEvento]) FOR [TN_CodTipoEvento]
GO
ALTER TABLE [Catalogo].[TipoEvento]
	ADD
	CONSTRAINT [DF_TipoEvento_TB_EsRemate]
	DEFAULT ((0)) FOR [TB_EsRemate]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo donde se registran los tipos de los eventos.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEvento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de tipo de evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEvento', 'COLUMN', N'TN_CodTipoEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de tipo de evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEvento', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Color asignado al tipo de evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEvento', 'COLUMN', N'TC_ColorEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el tipo de evento es remate judicial, aplica únicamente para materias de cobro judicial.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEvento', 'COLUMN', N'TB_EsRemate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEvento', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'TipoEvento', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[TipoEvento] SET (LOCK_ESCALATION = TABLE)
GO

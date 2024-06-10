SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[Aviso] (
		[TN_CodAviso]        [bigint] NOT NULL,
		[TC_Descripcion]     [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Sistema]         [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FecInicio]       [datetime2](7) NOT NULL,
		[TF_FecFin]          [datetime2](7) NOT NULL,
		CONSTRAINT [PK_Aviso]
		PRIMARY KEY
		CLUSTERED
		([TN_CodAviso])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[Aviso]
	ADD
	CONSTRAINT [DF_Aviso_TN_CodAviso]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaAviso]) FOR [TN_CodAviso]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene el identificador del cátalogo de avisos', 'SCHEMA', N'Catalogo', 'TABLE', N'Aviso', 'COLUMN', N'TN_CodAviso'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contiene el texto del aviso', 'SCHEMA', N'Catalogo', 'TABLE', N'Aviso', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del sistema en el que aparecerá el aviso', 'SCHEMA', N'Catalogo', 'TABLE', N'Aviso', 'COLUMN', N'TC_Sistema'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha cuando aparecerá el aviso', 'SCHEMA', N'Catalogo', 'TABLE', N'Aviso', 'COLUMN', N'TF_FecInicio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha cuando termina el aviso', 'SCHEMA', N'Catalogo', 'TABLE', N'Aviso', 'COLUMN', N'TF_FecFin'
GO
ALTER TABLE [Catalogo].[Aviso] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[EstadoEvento] (
		[TN_CodEstadoEvento]     [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TB_FinalizaEvento]      [bit] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[intIDEstado]            [int] NULL,
		CONSTRAINT [PK_EstadoEvento]
		PRIMARY KEY
		CLUSTERED
		([TN_CodEstadoEvento])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[EstadoEvento]
	ADD
	CONSTRAINT [DF_EstadoEvento_TN_CodEstadoEvento]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaEstadoEvento]) FOR [TN_CodEstadoEvento]
GO
ALTER TABLE [Catalogo].[EstadoEvento]
	ADD
	CONSTRAINT [DF_EstadoEvento_TB_FinalizaEvento]
	DEFAULT ((0)) FOR [TB_FinalizaEvento]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de estados de los eventos.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoEvento', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del estado del evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoEvento', 'COLUMN', N'TN_CodEstadoEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción del estado de evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoEvento', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si el estado finaliza el evento.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoEvento', 'COLUMN', N'TB_FinalizaEvento'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoEvento', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'EstadoEvento', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[EstadoEvento] SET (LOCK_ESCALATION = TABLE)
GO

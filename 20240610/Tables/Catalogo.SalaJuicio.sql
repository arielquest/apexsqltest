SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Catalogo].[SalaJuicio] (
		[TN_CodSala]             [smallint] NOT NULL,
		[TN_CodCircuito]         [smallint] NOT NULL,
		[TC_Descripcion]         [varchar](255) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_Observaciones]       [varchar](200) COLLATE Modern_Spanish_CI_AS NULL,
		[TN_Capacidad]           [smallint] NOT NULL,
		[TB_Habilitada]          [bit] NOT NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NOT NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL,
		[intIDSala]              [int] NULL,
		CONSTRAINT [PK_SalaJuicio]
		PRIMARY KEY
		CLUSTERED
		([TN_CodSala])
	ON [FG_SIAGPJ]
) ON [FG_SIAGPJ]
GO
ALTER TABLE [Catalogo].[SalaJuicio]
	ADD
	CONSTRAINT [DF_SalaJuicio_TN_CodSala]
	DEFAULT (NEXT VALUE FOR [Catalogo].[SecuenciaSalaJuicio]) FOR [TN_CodSala]
GO
ALTER TABLE [Catalogo].[SalaJuicio]
	ADD
	CONSTRAINT [DF_SalaJuicio_TB_Habilitada]
	DEFAULT ((0)) FOR [TB_Habilitada]
GO
ALTER TABLE [Catalogo].[SalaJuicio]
	WITH CHECK
	ADD CONSTRAINT [FK_SalaJuicio_Circuito]
	FOREIGN KEY ([TN_CodCircuito]) REFERENCES [Catalogo].[Circuito] ([TN_CodCircuito])
ALTER TABLE [Catalogo].[SalaJuicio]
	CHECK CONSTRAINT [FK_SalaJuicio_Circuito]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Catálogo de salas de juicio por circuito.', 'SCHEMA', N'Catalogo', 'TABLE', N'SalaJuicio', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código de la sala de juicio.', 'SCHEMA', N'Catalogo', 'TABLE', N'SalaJuicio', 'COLUMN', N'TN_CodSala'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Código del circutio al que pertenece la sala.', 'SCHEMA', N'Catalogo', 'TABLE', N'SalaJuicio', 'COLUMN', N'TN_CodCircuito'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Descripción de la sala de juicio.', 'SCHEMA', N'Catalogo', 'TABLE', N'SalaJuicio', 'COLUMN', N'TC_Descripcion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Observaciones sobre el estado de la sala.', 'SCHEMA', N'Catalogo', 'TABLE', N'SalaJuicio', 'COLUMN', N'TC_Observaciones'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Capacidad máxima de personas que pueden estar en la sala.', 'SCHEMA', N'Catalogo', 'TABLE', N'SalaJuicio', 'COLUMN', N'TN_Capacidad'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indica si la sala está habilitada, si está en buen estado para usarse.', 'SCHEMA', N'Catalogo', 'TABLE', N'SalaJuicio', 'COLUMN', N'TB_Habilitada'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de inicio de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'SalaJuicio', 'COLUMN', N'TF_Inicio_Vigencia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha de fin de vigencia del registro.', 'SCHEMA', N'Catalogo', 'TABLE', N'SalaJuicio', 'COLUMN', N'TF_Fin_Vigencia'
GO
ALTER TABLE [Catalogo].[SalaJuicio] SET (LOCK_ESCALATION = TABLE)
GO

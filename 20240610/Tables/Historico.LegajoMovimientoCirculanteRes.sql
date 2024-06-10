SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[LegajoMovimientoCirculanteRes] (
		[TU_CodLegajo]                [uniqueidentifier] NOT NULL,
		[TF_Fecha]                    [datetime2](7) NOT NULL,
		[TC_NumeroExpediente]         [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]              [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodEstado]                [smallint] NOT NULL,
		[TC_Movimiento]               [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodArchivo]               [uniqueidentifier] NULL,
		[TU_CodPuestoFuncionario]     [uniqueidentifier] NOT NULL,
		[TC_Descripcion]              [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                [datetime2](7) NOT NULL,
		CONSTRAINT [PK_LegajoMovimientoCirculanteRes]
		PRIMARY KEY
		NONCLUSTERED
		([TU_CodLegajo], [TF_Fecha])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Historico].[LegajoMovimientoCirculanteRes] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Historico].[ExpedienteMovimientoCirculanteRespaldo] (
		[TC_NumeroExpediente]         [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_Fecha]                    [datetime2](7) NOT NULL,
		[TC_CodContexto]              [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_CodEstado]                [smallint] NOT NULL,
		[TC_Movimiento]               [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodArchivo]               [uniqueidentifier] NULL,
		[TU_CodPuestoFuncionario]     [uniqueidentifier] NOT NULL,
		[TC_Descripcion]              [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Particion]                [datetime2](7) NOT NULL,
		CONSTRAINT [PK_ExpedienteMovimientoCirculanteRespaldo]
		PRIMARY KEY
		NONCLUSTERED
		([TC_NumeroExpediente], [TF_Fecha])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Historico].[ExpedienteMovimientoCirculanteRespaldo] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[SeguimientoArchivo] (
		[TU_CodArchivo]           [uniqueidentifier] NOT NULL,
		[TU_CodSeguimiento]       [uniqueidentifier] NOT NULL,
		[TC_NumeroExpediente]     [char](14) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_SeguimientoArchivo]
		PRIMARY KEY
		CLUSTERED
		([TU_CodArchivo], [TU_CodSeguimiento])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Expediente].[SeguimientoArchivo]
	WITH CHECK
	ADD CONSTRAINT [FK_SeguimientoArchivo_Seguimiento]
	FOREIGN KEY ([TU_CodSeguimiento]) REFERENCES [Expediente].[Seguimiento] ([TU_CodSeguimiento])
ALTER TABLE [Expediente].[SeguimientoArchivo]
	CHECK CONSTRAINT [FK_SeguimientoArchivo_Seguimiento]

GO
ALTER TABLE [Expediente].[SeguimientoArchivo] SET (LOCK_ESCALATION = TABLE)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [Expediente].[Seguimiento] (
		[TU_CodSeguimiento]                       [uniqueidentifier] NOT NULL,
		[TU_CodInstitucion]                       [uniqueidentifier] NULL,
		[TC_NumeroExpediente]                     [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodPuestoTrabajo]                     [uniqueidentifier] NOT NULL,
		[TC_UsuarioRed]                           [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaRegistro]                        [datetime2](2) NOT NULL,
		[TN_Plazo]                                [int] NOT NULL,
		[TF_FechaVencimiento]                     [datetime2](2) NOT NULL,
		[TC_TipoEnvio]                            [char](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TN_Estado]                               [int] NULL,
		[TU_CodComunicacion]                      [uniqueidentifier] NULL,
		[TN_CodTipoOficina]                       [smallint] NULL,
		[TC_CodContexto]                          [varchar](4) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Resultado]                            [varchar](15) COLLATE Modern_Spanish_CI_AS NULL,
		[TC_Obsercaciones]                        [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
		[TU_CodPuestoTrabajoUsuarioActualiza]     [uniqueidentifier] NULL,
		[TC_UsuarioRedActualiza]                  [varchar](30) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_FechaActualizacion]                   [datetime2](2) NULL,
		[TC_CodMateria]                           [varchar](5) COLLATE Modern_Spanish_CI_AS NULL,
		CONSTRAINT [PK_Seguimiento]
		PRIMARY KEY
		CLUSTERED
		([TU_CodSeguimiento])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Expediente].[Seguimiento]
	WITH CHECK
	ADD CONSTRAINT [FK_Seguimiento_Expediente]
	FOREIGN KEY ([TC_NumeroExpediente]) REFERENCES [Expediente].[Expediente] ([TC_NumeroExpediente])
ALTER TABLE [Expediente].[Seguimiento]
	CHECK CONSTRAINT [FK_Seguimiento_Expediente]

GO
ALTER TABLE [Expediente].[Seguimiento] SET (LOCK_ESCALATION = TABLE)
GO

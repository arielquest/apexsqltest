SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TEMP] (
		[TC_AnnoSentencia]          [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodContexto]            [varchar](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_CodPuestoTrabajo]       [varchar](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TC_NumeroResolucion]       [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TF_FechaAsignacion]        [datetime2](7) NOT NULL,
		[TC_Estado]                 [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[TU_CodResolucion]          [uniqueidentifier] NULL,
		[TU_UsuarioCrea]            [uniqueidentifier] NOT NULL,
		[TU_UsuarioConfirma]        [uniqueidentifier] NULL,
		[TC_JustificacionNoUso]     [varchar](150) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Actualizacion]          [datetime2](7) NOT NULL,
		[TF_Particion]              [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TEMP]
	ADD
	CONSTRAINT [DF__TEMP__TF_Actuali__4321E620]
	DEFAULT (sysdatetime()) FOR [TF_Actualizacion]
GO
ALTER TABLE [dbo].[TEMP] SET (LOCK_ESCALATION = TABLE)
GO

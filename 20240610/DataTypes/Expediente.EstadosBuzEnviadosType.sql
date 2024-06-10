CREATE TYPE [Expediente].[EstadosBuzEnviadosType]
AS TABLE (
		[Codigo]                 [smallint] NULL,
		[Descripcion]            [varchar](21) COLLATE Modern_Spanish_CI_AS NULL,
		[TF_Inicio_Vigencia]     [datetime2](7) NULL,
		[TF_Fin_Vigencia]        [datetime2](7) NULL
)
GO

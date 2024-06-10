CREATE TYPE [dbo].[WHERECONSULTA]
AS TABLE (
		[NombreCampo]     [varchar](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
		[ValorCampo]      [varchar](255) COLLATE Modern_Spanish_CI_AS NULL,
	PRIMARY KEY CLUSTERED 
(
	[NombreCampo]
)
WITH (IGNORE_DUP_KEY = OFF)
)
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================================================================================================================
-- Versi¢n:					<1.0>
-- Creado por:				<Richard Z£ñiga Segura>
-- Fecha de creaci¢n:		<08/06/2021>
-- Descripci¢n :			<Permite consultar los datos adicionales de un expediente/legajo proveniente de Gestion>
-- =============================================================================================================================================================================
-- Modificaci¢n:			<23/07/2021> <Ronny Ram¡rez R.> <Se aplica correcci¢n en mapeo de campos FECHECHO y FEHECHO>
-- Modificaci¢n:			<14/09/2021> <Jonathan Aguilar Navarro> <Se aplica formato a los campos fechas PERINTPOS,PERINTPOS,FECFINSOB>
-- Modificaci¢n:			<29/10/2021> <Luis Alonso Leiva Tames> <Se aplica la funcion para los montos de aguinaldo y monto salario escolar>

-- =============================================================================================================================================================================

CREATE PROCEDURE [Itineracion].[PA_ConsultarDatosAdicionalesExpedienteLegajoGestion]
	@CodItineracion	UNIQUEIDENTIFIER
AS

BEGIN
--Variables 
DECLARE	@L_CodItineracion			Uniqueidentifier		= @CodItineracion,
		@L_ContextoDestino					varchar(4);

SELECT @L_ContextoDestino= RECIPIENTADDRESS FROM ItineracionesSIAGPJ.dbo.MESSAGES WHERE id = @L_CodItineracion;

--Tabla temporal para registros
DECLARE @Result TABLE	(
		--Expediente
		CANTH			varchar(255),
		CAPITAL			varchar(255),
		CODDELEST		varchar(255),
		FECHECHO		varchar(255),
		FEHECHO			varchar(255),
		AGUINAL			varchar(255),
		DESCHEC			varchar(255),
		PROVH			varchar(255),
		SALESCO			varchar(255),
		CAPINTCM		varchar(255),
		TOTAL50			varchar(255),
		INTGIRO			varchar(255),
		FECINISOB		varchar(255),
		INTCORR			varchar(255),
		PERINTPOS		varchar(255),
		PERINTSOB		varchar(255),
		TINTGIRO		varchar(255),
		TINTPOSOB		varchar(255),
		TINTMORA		varchar(255),
		TINTPOST		varchar(255),
		FECFINSOB		varchar(255)
)

	INSERT INTO @Result
	(
		CANTH,
		CAPITAL,
		CODDELEST,
		FECHECHO,
		FEHECHO,
		AGUINAL,
		DESCHEC,
		PROVH,
		SALESCO,
		CAPINTCM,
		TOTAL50,
		INTGIRO,
		FECINISOB,
		INTCORR,
		PERINTPOS,
		PERINTSOB,
		TINTGIRO,
		TINTPOSOB,
		TINTMORA,
		TINTPOST,
		FECFINSOB
	)
		-- Detalle primera itineraci¢n de Gesti¢n (puede que salgan repeticiones por el cat logo de Clase)
	SELECT
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'CANTH'),
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'CAPITAL'),	
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'CODDELEST'),			
				(SELECT TOP 1 TRY_CONVERT(DATETIME2(3), REPLACE(X.Y.value('(VALOR)[1]', 'varchar(255)'),'.',''), 103)
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'FECHECHO'),
				(SELECT TOP 1 TRY_CONVERT(DATETIME2(3), REPLACE(X.Y.value('(VALOR)[1]', 'varchar(255)'),'.',''), 103)	
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'FEHECHO'),
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'AGUINAL'),
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'DESCHEC'),
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'PROVH'),
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'SALESCO'),
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'CAPINTCM'),
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'TOTAL50'),
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'INTGIRO'),
				(SELECT TOP 1 TRY_CONVERT(DATETIME2(3), REPLACE(X.Y.value('(VALOR)[1]', 'varchar(255)'),'.',''), 103)	
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'FECINISOB'),
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'INTCORR'),
				(SELECT TOP 1 TRY_CONVERT(DATETIME2(3), REPLACE(X.Y.value('(VALOR)[1]', 'varchar(255)'),'.',''), 103)	
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'PERINTPOS'),
				(SELECT TOP 1 TRY_CONVERT(DATETIME2(3), REPLACE(X.Y.value('(VALOR)[1]', 'varchar(255)'),'.',''), 103)	
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'PERINTSOB'),
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'TINTGIRO'),
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'TINTPOSOB'),
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'TINTMORA'),
				(SELECT TOP 1 X.Y.value('(VALOR)[1]', 'varchar(255)')
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'TINTPOST'),
				(SELECT TOP 1 TRY_CONVERT(DATETIME2(3), REPLACE(X.Y.value('(VALOR)[1]', 'varchar(255)'),'.',''), 103)	
						FROM ItineracionesSIAGPJ.dbo.ATTACHMENTS 	T	WITH(NOLOCK)
						CROSS APPLY T.VALUE.nodes('(/*/DCARMASD)') AS X(Y)
						WHERE	T.ID	= A.ID
						AND		X.Y.value('(CODMASD)[1]', 'varchar(9)') = 'FECFINSOB')
	FROM		ItineracionesSIAGPJ.dbo.MESSAGES		A 	WITH(NOLOCK)	
	INNER JOIN	ItineracionesSIAGPJ.dbo.ATTACHMENTS 	X	WITH(NOLOCK)
	ON			X.ID									=	A.ID
	LEFT JOIN	Catalogo.Contexto						CC	WITH(NOLOCK) --CONTEXTO CREACION
	ON			CC.TC_CodContexto						=	A.SENDERADDRESS COLLATE DATABASE_DEFAULT
	LEFT JOIN	Catalogo.Oficina						OC	WITH(NOLOCK) 
	ON			OC.TC_CodOficina						=	CC.TC_CodOficina
	WHERE		A.ID									=	@L_CodItineracion



	Select 	
		CANTH,
		CAPITAL,
		CODDELEST,
		FECHECHO,
		FEHECHO,
		Itineracion.FN_DevuelveNumeroDecimal(AGUINAL),
		DESCHEC,
		PROVH,
		Itineracion.FN_DevuelveNumeroDecimal(SALESCO),
		CAPINTCM,
		TOTAL50,
		INTGIRO,
		FECINISOB,
		INTCORR,
		PERINTPOS,
		PERINTSOB,
		TINTGIRO,
		TINTPOSOB,
		TINTMORA,
		TINTPOST,
		FECFINSOB
	From
		@Result

END
GO

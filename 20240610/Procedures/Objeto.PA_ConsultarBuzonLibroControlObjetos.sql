SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez R.>
-- Fecha de creación:		<28/02/2020>
-- Descripción :			<Permite Consultar los objetos para el buzón de libro de control de objetos>
-- =================================================================================================================================================
CREATE PROCEDURE [Objeto].[PA_ConsultarBuzonLibroControlObjetos]   
 	@NumeroPagina				INT,
	@CantidadRegistros			INT,
	@CodOficinaPertenece		VARCHAR(4)		= NULL,
	@CodOficinaCustodia			VARCHAR(4)		= NULL,
	@EstadoDisposicion			CHAR(1)			= NULL,	
	@FechaDesde					DATETIME2		= NULL,
	@FechaHasta					DATETIME2		= NULL,
	@NumeroExpediente			VARCHAR(14)		= NULL,
	@NumeroObjeto				VARCHAR(20)		= NULL
AS
BEGIN
	
	DECLARE @LibroObjetos AS TABLE
	(
		CodigoObjeto				UNIQUEIDENTIFIER,
		NumeroObjeto				VARCHAR(20),
		Descripcion					VARCHAR(255),
		FechaRegistro				DATETIME2,
		EstadoDisposicion			CHAR(1),
		NumeroExpediente			CHAR(14),
		OficinaCustodiaDescrip		VARCHAR(255),
		CodOficinaCustodia			VARCHAR(4),
		OficinaPerteneceDescrip		VARCHAR(255),
		OficinaPertenece			VARCHAR(4),
		EsContenedor				BIT,
		EsContenido					BIT
	)

  if( @NumeroPagina is null) set @NumeroPagina=1;

     INSERT INTO @LibroObjetos(
	 CodigoObjeto,		
	 NumeroObjeto,	 
	 Descripcion,
	 FechaRegistro,				
	 EstadoDisposicion,			
	 NumeroExpediente,
	 OficinaPerteneceDescrip,
	 OficinaPertenece, 
	 OficinaCustodiaDescrip,
	 CodOficinaCustodia,
	 EsContenedor,
	 EsContenido
	) 
		SELECT		A.TU_CodObjeto									AS	CodigoObjeto,
					A.TC_NumeroObjeto								AS 	NumeroObjeto,
					A.TC_Descripcion								AS 	Descripcion,
					A.TF_FechaRegistro								AS	FechaRegistro,
					D.TC_Disposicion								AS	EstadoDisposicion,
					A.TC_NumeroExpediente							AS	NumeroExpediente,
					C.TC_Nombre										AS	OficinaPerteneceDescrip,
					C.TC_CodOficina									AS	OficinaPertenece,
					R.TC_Nombre										AS	OficinaCustodiaDescrip,
					E.TC_CodOficina_Recibe							AS	CodOficinaCustodia,
					A.TB_Contenedor									AS	EsContenedor,
					CASE WHEN A.TU_CodigoObjetoPadre IS NOT NULL 
						THEN 1 ELSE 0 END							AS	EsContenido
		FROM		Objeto.Objeto									AS	A WITH(NOLOCK)
		INNER JOIN	Catalogo.Oficina								AS	C WITH(NOLOCK)
		ON			A.TC_CodOficina									=	C.TC_CodOficina
		LEFT JOIN	Objeto.Eslabon									AS	E WITH(NOLOCK)
		ON			E.TU_CodObjeto									=	A.TU_CodObjeto
		AND			E.TF_Fecha										= (
																		select max(TF_Fecha) from Objeto.Eslabon WITH(NOLOCK) where TU_CodObjeto =	E.TU_CodObjeto
																	)
		LEFT JOIN	Catalogo.Oficina								AS	R WITH(NOLOCK)
		ON			R.TC_CodOficina									=	E.TC_CodOficina_Recibe
		LEFT JOIN	Objeto.DestinoEvidencia							AS	D WITH(NOLOCK)
		ON			D.TU_CodObjeto									=	A.TU_CodObjeto
		WHERE		(@EstadoDisposicion IS NULL						OR 	D.TC_Disposicion	= @EstadoDisposicion)
		AND			A.TC_NumeroObjeto								=	Coalesce(@NumeroObjeto, A.TC_NumeroObjeto)
		AND			A.TC_NumeroExpediente							=	Coalesce(@NumeroExpediente, A.TC_NumeroExpediente)
		AND			(@FechaDesde IS NULL							OR 	DATEDIFF(day, A.TF_FechaRegistro,@FechaDesde) <= 0)
		AND			(@FechaHasta IS NULL							OR 	DATEDIFF(day, A.TF_FechaRegistro,@FechaHasta) >= 0)
		AND			(@CodOficinaPertenece IS NULL					OR	A.TC_CodOficina = @CodOficinaPertenece)
		AND			(@CodOficinaCustodia IS NULL					OR	E.TC_CodOficina_Recibe = @CodOficinaCustodia)
		ORDER BY	A.TF_FechaRegistro ASC

--Obtener cantidad registros de la consulta
DECLARE @TotalRegistros AS INT = @@rowcount; 

--Resultado de la consulta
SELECT		@TotalRegistros			AS	TotalRegistros,	
			EsContenido				AS	EsContenido,	
			
			'SplitObjeto'			AS	SplitObjeto,										
			CodigoObjeto			AS	Codigo,
			NumeroObjeto			AS	NumeroObjeto,
			Descripcion				AS	Descripcion,
			FechaRegistro			AS	FechaRegistro,
			EsContenedor			AS	Contenedor,
			
			'SplitExpediente'		 	SplitExpediente,
			NumeroExpediente		AS	Numero,
			
			'SplitOficinaPertenece'		SplitOficinaPertenece,
			OficinaPertenece		AS	Codigo,
			OficinaPerteneceDescrip	AS	Descripcion,			
			
			'SplitOficinaCustodia'		SplitOficinaCustodia,
			CodOficinaCustodia		AS	Codigo,
			OficinaCustodiaDescrip	AS	Descripcion,
			
			'SplitDatos'				SplitDatos,
			EstadoDisposicion		AS	EstadoDisposicion
FROM		@LibroObjetos
ORDER BY	FechaRegistro ASC

OFFSET		(@NumeroPagina - 1) * @CantidadRegistros ROWS 
FETCH NEXT	@CantidadRegistros ROWS ONLY
		
END
GO

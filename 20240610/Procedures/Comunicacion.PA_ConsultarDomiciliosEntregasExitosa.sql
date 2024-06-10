SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ========================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Tatiana Flores>
-- Fecha de creación:		<14/03/2017>
-- Descripción:				<Obtiene comunicaciones entregadas satisfactoriamente.> 
--==========================================================================================================================
-- Modificación:	<14/03/2017> <Diego Navarrete> <Se cambia el @CodigoMedio de char a int, para que busque por el codigo>
-- ==========================================================================================================================
-- Modificación:	<12/07/2018> <Jeffry Hernández> <Se cambian left joins por inner joins ya que se utiliza solo para consultar medios de tipo domicilio>
-- ==========================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ConsultarDomiciliosEntregasExitosa]
(
	@CodigoInterviniente	UNIQUEIDENTIFIER,
	@CodigoEstado			CHAR,
	@CodigoMedio			INT,
	@Resultado				CHAR
)
AS
BEGIN

	SELECT 
			C.TC_Valor						AS Valor,
			C.TU_CodComunicacion			AS CodigoComunicacion,		C.TC_ConsecutivoComunicacion	AS ConsecutivoComunicacion,		
			C.TF_FechaResultado			    AS FechaResultado,			'SplitProvincia'				AS SplitProvincia,
			P.TN_CodProvincia				AS Codigo, 				  	P.TC_Descripcion				AS Descripcion,
			P.TF_Inicio_Vigencia			AS FechaActivacion,			P.TF_Fin_Vigencia				AS FechaDesactivacion,
			'SplitCanton'					AS SplitCanton,				CN.TN_CodCanton					AS Codigo,
			CN.TC_Descripcion				AS Descripcion,				CN.TF_Inicio_Vigencia			AS FechaActivacion,
			CN.TF_Fin_Vigencia				AS FechaDesactivacion,		'SplitDistrito'					AS SplitDistrito,
			D.TN_CodDistrito				AS Codigo,					D.TC_Descripcion				AS Descripcion,
			D.TF_Inicio_Vigencia			AS FechaActivacion,			D.TF_Fin_Vigencia				AS FechaDesactivacion,
			'SplitBarrio'					AS SplitBarrio,				B.TN_CodBarrio					AS Codigo,
			B.TC_Descripcion				AS Descripcion,				B.TF_Inicio_Vigencia			AS FechaActivacion,
			B.TF_Fin_Vigencia				AS FechaDesactivacion,		'SplitGeografia'				AS SplitGeografia,
			C.TG_UbicacionPunto.Lat			AS Latitud,					C.TG_UbicacionPunto.Long		AS Longitud
	
	FROM			        [Comunicacion].[Comunicacion]		C  WITH(NOLOCK)	
			INNER JOIN		[Catalogo].[Provincia]				P  WITH(NOLOCK) 
			ON				P.TN_CodProvincia				=	C.TN_CodProvincia
			INNER JOIN		[Catalogo].[Canton]					CN WITH(NOLOCK) 
			ON				CN.TN_CodCanton					=	C.TN_CodCanton
			INNER JOIN		[Catalogo].[Distrito]				D  WITH(NOLOCK) 
			ON				D.TN_CodDistrito				=	C.TN_CodDistrito
			INNER JOIN		[Catalogo].[Barrio]					B  WITH(NOLOCK) 
			ON				B.TN_CodBarrio					=	C.TN_CodBarrio
	
	WHERE					C.TU_CodInterviniente			=	@CodigoInterviniente
			AND				C.TC_Estado						=	@CodigoEstado  
			AND				C.TC_CodMedio					=	@CodigoMedio  
			AND				C.TC_Resultado					=	@Resultado

END
GO

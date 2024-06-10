SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=============================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<18/09/2017>
-- Descripción:				<Consulta el medio accesorio de un interviniente o representante> 
--=============================================================================================================================
--                          <Modificado por Cristian Cerdas Camacho 15/04/2020 se cambia la consulta SQL ya que 
--                           tenia tablas que no existian en la base datos, además se agregan nuevos parámetros de entrada> 
--=============================================================================================================================
-- Modificación:			<27/05/2021> <Ronny Ramírez R.> <Se agrega validación de tipos de medio válidos para notificar 
--							por configuración C_TipoMedioRepreONoIndica>
--=============================================================================================================================
-- Modificación:			<02/06/2021> <Ronny Ramírez R.> <Se modifica consulta para que devuelva los datos de una entidad
--							MedioComunicacion>
-- =============================================================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultarMedioAccesorioDestinatario]
(
	@CodigoComunicacion			uniqueidentifier,
	@CodigoInterviniente        uniqueidentifier
)
AS
BEGIN
		--Variables.
		DECLARE	@TempCodigoComunicacion			uniqueidentifier	=	@CodigoComunicacion,
				@TempCodigoInterviniente        uniqueidentifier	=	@CodigoInterviniente		

		--Lógica.
		Select	A.TU_CodMedioComunicacion								AS CodigoMedio,	
				A.TC_Valor												AS Valor,						
				A.TC_Rotulado											AS Rotulado,
				A.TU_CodInterviniente									AS CodigoInterviniente,
				A.TB_PerteneceExpediente								AS PerteneceExpediente,
				'Split'													AS SplitBarrio,
				H.TN_CodBarrio											AS Codigo,				
				H.TC_Descripcion										AS Descripcion,
				'Split'													AS SplitDistrito,
				B.TN_CodDistrito										AS Codigo,			
				B.TC_Descripcion										AS Descripcion,
				'Split'													AS SplitCanton,
				C.TN_CodCanton											AS Codigo,				
				C.TC_Descripcion										AS Descripcion,
				'Split'													AS SplitProvincia,
				D.TN_CodProvincia										AS Codigo,		
				D.TC_Descripcion										AS Descripcion,
				'Split'													AS SplitTipoMedioComunicacion,
				E.TN_CodMedio											AS Codigo,	
				E.TC_Descripcion										AS Descripcion,
				'Split'													AS SplitOtrosDatos,
				ISNULL(L.TN_PrioridadLegajo, A.TN_PrioridadExpediente)	AS PrioridadMedio,
				E.TC_TipoMedio											AS TipoMedio,
				F.TN_CodHorario											AS CodigoHorario,	
				F.TC_Descripcion										AS DescripcionHorario,
				A.TG_UbicacionPunto.Lat									AS Latitud,
				A.TG_UbicacionPunto.Long								AS Longitud		
	FROM		Comunicacion.Comunicacion								COM	WITH(NOLOCK)
	INNER JOIN	Comunicacion.ComunicacionIntervencion					CIN	WITH(NOLOCK)
	ON			CIN.TU_CodComunicacion									=	COM.TU_CodComunicacion		
	INNER JOIN	Expediente.IntervencionMedioComunicacion				As	A WITH(NOLOCK)			
	ON			A.TU_CodInterviniente									=	CIN.TU_CodInterviniente
	LEFT JOIN	Expediente.IntervencionMedioComunicacionLegajo			L	WITH(NOLOCK)
	ON			L.TU_CodMedioComunicacion								=	A.TU_CodMedioComunicacion	
	LEFT JOIN	Catalogo.Distrito										AS	B WITH(NOLOCK)
	ON			A.TN_CodDistrito										=	B.TN_CodDistrito 
	AND			A.TN_CodCanton											=	B.TN_CodCanton
	AND			A.TN_CodProvincia										=	B.TN_CodProvincia
	LEFT JOIN	Catalogo.Canton											AS	C WITH(NOLOCK)	
	ON			A.TN_CodCanton											=	C.TN_CodCanton
	AND			A.TN_CodProvincia										=	C.TN_CodProvincia
	LEFT JOIN	Catalogo.Provincia										AS	D WITH(NOLOCK) 
	ON			A.TN_CodProvincia										=	D.TN_CodProvincia
	LEFT JOIN	Catalogo.Barrio											AS	H WITH(NOLOCK) 
	ON			A.TN_CodBarrio											=	H.TN_CodBarrio	
	INNER JOIN	Catalogo.TipoMedioComunicacion							AS	E WITH(NOLOCK) 
	ON			A.TN_CodMedio											=	E.TN_CodMedio
	LEFT JOIN	Catalogo.HorarioMedioComunicacion						AS	F WITH(NOLOCK) 
	ON			A.TN_CodHorario											=	F.TN_CodHorario
	
	WHERE		COM.TU_CodComunicacion									=		@TempCodigoComunicacion
	AND			CIN.TU_CodInterviniente									=		@TempCodigoInterviniente
	AND			(	
					(	
						COM.TU_CodLegajo								IS NOT NULL	
						AND		
						L.TN_PrioridadLegajo							= 2
					)
					OR
					(
						COM.TU_CodLegajo								IS NULL	
						AND
						A.TN_PrioridadExpediente						=	2
					)
				)
	AND			COM.TC_CodMedio												NOT IN
																			(
																				SELECT	TC_Valor
																				FROM	Configuracion.ConfiguracionValor WITH(NOLOCK)	
																				WHERE	TC_CodConfiguracion						=	'C_TipoMedioRepreONoIndica'
																				AND		TF_FechaActivacion						<=	GETDATE() 
																				AND		(
																								TF_FechaCaducidad				IS NULL 
																							OR	
																								TF_FechaCaducidad				>	GETDATE()
																						)
																			)

END
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ===============================================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Andrew Allen DAwson>
-- Fecha de creación:		<10/10/2018>
-- Descripción :			<Permite Consultar los escritos de un expediente para el buzon de escritos>
-- ===============================================================================================================================================================================
-- Modificado:				<Jose Gabriel Cordero Soto><25/11/2019> <Se agregan campos necesarios para la consulta de datos>
-- Modificado:				<Jonathan Aguilar Navarro> <12/12/2019> <Se agrega a la consulta el ID  del archivo asociado al escrito> 
-- Modificado:				<Luis Alonso Leiva Tames> <15/07/2020> <Se agrega a la consulta el campo VariasGestiones> 
-- Modificado:				<Luis Alonso Leiva Tames> <19/05/2021> <Optimizar la consulta, por timeout> 
-- Modificado:				<Ronny Ramírez R.> <11/08/2021> <Se agrega Join con Oficina para sacar el Tipo de Oficina específico del contexto, 
--							para evitar duplicados si no se pasa el tipo de oficina> 
-- Modificado:				<Josué Quirós Batista> <05/10/2021> <Se modifica con el objetivo de listar los escritos asociados a un legajo aunque el tipo de escrito no esté asociado a la oficina.>
-- Modificado:				<Aida Elena Siles R> <19/10/2021> <Se cambia consulta a Left Join sobre las tablas Historico.ExpedienteMovimientoCirculante y Catalogo.Estado.
--							Lo anterior, porque se implementa en el SIAGPJ la opción de crear legajos sin tener un expediente creado. Permitir visualizar los escritos de legajos sin expediente.>	
-- Modificado:				<Ronny Ramírez R.> <25/10/2021> <Se modifica para excluir el filtrado por contexto, pues no se están mostrando escritos
--							creados en otros contextos cuando se itinera el legajo>
-- Modificado:              <Jose Gabriel Cordero Soto> <25/11/2021> <Se agregan campo de Codigo y Descripcion del Asunto del Legajo>
-- Modificado:              <Aida Elena Siles R> <08/02/2022> <Optimizar la consulta, debido a que se presenta error de timeout.>
-- Modificado:              <Oscar Sánchez Hernández> <10/08/2022> <HU 270251 Agregar nuevo retorno en el select que consulta nombre,apellidos del funcionario que realizó el escrito.>
-- Modificado:              <Aarón Ríos Retana> <23/08/2022> <HU 270202 Se coloca un left join en relacion con el puesto de trabajo ya que el mismo puede ser nulo
--													,a su vez se permite que sea nulo el parametro en el where>
-- Modificación				<Ronny Ramírez R.> <25/07/2023> <Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar  
--															problema de no uso de índices por el mal uso de COALESCE/ISNULL en el WHERE>
-- ===============================================================================================================================================================================
CREATE   PROCEDURE [Expediente].[PA_ConsultarEscritosLegajo]
 	@CodigoEscrito				UNIQUEIDENTIFIER= NULL,
	@CodigoLegajo				UNIQUEIDENTIFIER= NULL,
	@EsUrgente					BIT				= NULL,
	@EstadoEscrito				CHAR(1)			= NULL,
	@CodTipoEscrito				SMALLINT		= NULL,
	@CodContexto				VARCHAR(4)		= NULL,
	@CodTipoOficina				SMALLINT		= NULL

AS
BEGIN

-- Declaracion Variables 
DECLARE 
	@L_CodigoEscrito			UNIQUEIDENTIFIER= @CodigoEscrito,
	@L_CodigoLegajo				UNIQUEIDENTIFIER= @CodigoLegajo,
	@L_EsUrgente				BIT				= @EsUrgente,
	@L_EstadoEscrito			CHAR(1)			= @EstadoEscrito,
	@L_CodTipoEscrito			SMALLINT		= @CodTipoEscrito,
	@L_CodContexto				VARCHAR(4)		= @CodContexto,
	@L_CodTipoOficina			SMALLINT		= @CodTipoOficina

   SELECT  A.TU_CodEscrito										AS		Codigo
		  ,A.TC_Descripcion										AS		Descripcion
		  ,A.TF_FechaIngresoOficina								AS		FechaIngresoOficina
		  ,A.TF_FechaEnvio										AS		FechaEnvio
		  ,A.TF_FechaRegistro									AS		FechaRegistro
		  ,A.TC_CodEntrega										AS      CodigoEntrega	
		  ,A.TB_VariasGestiones									AS		VariasGestiones
		  ,'splitExpedienteCirculante'							AS      splitExpedienteCirculante
		  ,HE.TF_Fecha		   								    AS      Fecha 
		  ,'splitEstadoExpediente'								AS      splitEstadoExpediente	
		  ,G.TN_CodEstado										AS      Codigo  
		  ,G.TC_Descripcion										AS      Descripcion
		  ,'splitLegajo'										AS		splitLegajo
		  ,L.TU_CodLegajo										AS		Codigo
		  ,L.TC_Descripcion										AS		Descripcion
		  ,'splitTipoEscrito'									AS		splitTipoEscrito
		  ,A.TN_CodTipoEscrito									AS		Codigo
		  ,E.TC_Descripcion										AS		Descripcion
		  ,ISNULL(OA.TB_Urgente, 0)								AS		EsUrgente
		  ,'splitOtros'											AS      splitOtros
		  ,OA.TC_CodContexto									AS      Codigo
		  ,OA.TC_Descripcion									AS		Descripcion
		  ,C.TC_CodPuestoTrabajo								AS		CodigoPuesto
		  ,C.TC_Descripcion										AS		DescripcionPuesto
		  ,A.TC_EstadoEscrito									AS      EstadoEscrito
		  ,A.TC_NumeroExpediente								AS		NumeroExpediente
		  ,A.TC_IDARCHIVO										AS		CodigoArchivo
		  ,OA.TN_CodTipoOficina									AS		CodigoOFicina
		  ,I.TN_CodAsunto										AS      CodigoAsuntoLegajo
		  ,I.TC_Descripcion										AS		DescripcionAsuntoLegajo
		  ,F.TC_Nombre                                          AS		NombreFuncionario
		  ,F.TC_PrimerApellido                                  AS		PrimerApellidoFuncionario
		  ,F.TC_SegundoApellido                                 AS		SegundoApellidoFuncionario
	
	FROM		Expediente.EscritoExpediente	A WITH(NOLOCK)
	
	INNER JOIN	Expediente.EscritoLegajo		H WITH(NOLOCK)
	ON			H.TU_CodEscrito					= A.TU_CodEscrito

	INNER JOIN	Expediente.Legajo				L WITH(NOLOCK)
	ON			L.TU_CodLegajo					= H.TU_CodLegajo

	INNER JOIN	Catalogo.TipoEscrito			E WITH(NOLOCK)
	ON			E.TN_CodTipoEscrito				= A.TN_CodTipoEscrito

	OUTER APPLY	(
					SELECT		Z.TC_CodContexto					TC_CodContexto,
								Z.TC_Descripcion					TC_Descripcion,
								X.TB_Urgente						TB_Urgente,
								Y.TN_CodTipoOficina					TN_CodTipoOficina
					FROM		Catalogo.Contexto					Z WITH(NOLOCK)
					INNER JOIN	Catalogo.Oficina					Y WITH(NOLOCK)
					ON			Y.TC_CodOficina						= Z.TC_CodOficina
					LEFT JOIN	Catalogo.TipoEscritoTipoOficina		X WITH(NOLOCK)
					ON			X.TC_CodMateria						= Z.TC_CodMateria
					AND			X.TN_CodTipoEscrito					= A.TN_CodTipoEscrito
					AND			X.TN_CodTipoOficina					= Y.TN_CodTipoOficina
					WHERE		Z.TC_CodContexto					= A.TC_CodContexto
				) OA

	LEFT JOIN	Catalogo.PuestoTrabajo						C WITH(NOLOCK)
	ON			A.TC_CodPuestoTrabajo						=C.TC_CodPuestoTrabajo

	OUTER APPLY (	
	             SELECT F.* 
				 FROM Catalogo.PuestoTrabajoFuncionario P WITH(NOLOCK)
				 INNER JOIN	Catalogo.Funcionario		F WITH(NOLOCK)
                 ON          P.TC_UsuarioRed            =F.TC_UsuarioRed
				 WHERE 
				 P.TF_Inicio_Vigencia <= GETDATE() 
				 and (P.TF_Fin_Vigencia >= GETDATE() or P.TF_Fin_Vigencia is null)
				 and C.TC_CodPuestoTrabajo = P.TC_CodPuestoTrabajo
				 ) F

	OUTER APPLY (
					SELECT TOP	1 TF_Fecha, TN_CodEstado
					FROM		Historico.ExpedienteMovimientoCirculante WITH(NOLOCK)
					WHERE		TC_NumeroExpediente	= A.TC_NumeroExpediente
					ORDER BY	TF_Fecha DESC
				) HE
	LEFT JOIN	Catalogo.Estado					G WITH(NOLOCK)
	ON			G.TN_CodEstado					=	HE.TN_CodEstado
	LEFT JOIN	Expediente.LegajoDetalle		J WITH(NOLOCK)
	ON			J.TU_CodLegajo					= L.TU_CodLegajo
	LEFT JOIN	Catalogo.Asunto					I WITH(NOLOCK)
	ON			I.TN_CodAsunto					= J.TN_CodAsunto
	WHERE		L.TU_CodLegajo				=	ISNULL(@L_CodigoLegajo, L.TU_CodLegajo)	
	AND			A.TN_CodTipoEscrito			=	ISNULL(@L_CodTipoEscrito, A.TN_CodTipoEscrito)
	AND			A.TU_CodEscrito				=	ISNULL(@L_CodigoEscrito, A.TU_CodEscrito)
	AND (
				OA.TB_Urgente				=	ISNULL(@L_EsUrgente, OA.TB_Urgente)
				OR @L_EsUrgente				IS NULL
		)
	AND			A.TC_EstadoEscrito			=	ISNULL(@L_EstadoEscrito, A.TC_EstadoEscrito)	
	AND			OA.TN_CodTipoOficina		=	ISNULL(@L_CodTipoOficina, OA.TN_CodTipoOficina)	
	ORDER BY	A.TF_FechaEnvio
	OPTION(RECOMPILE);
END

GO

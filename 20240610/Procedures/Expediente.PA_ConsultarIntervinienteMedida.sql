SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<18/10/2022>
-- Descripción:			<Permite consultar un registro en la tabla: IntervinienteMedida. en order descendente por fecha fin del plazo vigente>
-- ==================================================================================================================================================================================
-- Modificado por:		<27-10-2022> <Jose Gabriel Cordero Soto> <Se ajusta el campo TC_Contexto por TC_CodContexto por cambio en tabla IntervinienteMedida>
-- Modificado por:		<02/11/2022> <Jose Gabriel Cordero Soto> <Se modifica nombre de TipoMedidaCautelar a TipoMedida>
-- ==================================================================================================================================================================================
CREATE    PROCEDURE	[Expediente].[PA_ConsultarIntervinienteMedida]
	@CodMedida					UNIQUEIDENTIFIER = NULL,
	@CodInterviniente			UNIQUEIDENTIFIER = NULL,
	@CodEstado					SMALLINT		 = NULL,
	@CodTipoMedida				SMALLINT		 = NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodMedida				UNIQUEIDENTIFIER		= @CodMedida,
			@L_TU_CodInterviniente		UNIQUEIDENTIFIER		= @CodInterviniente,
			@L_TN_CodEstado				SMALLINT				= @CodEstado,
			@L_TN_CodTipoMedida			SMALLINT				= @CodTipoMedida

	--Lógica
	SELECT		A.TU_CodMedida						CodigoMedida,
				A.TF_FechaEstado					FechaEstado,
				A.TC_Observaciones					Observacion,			
				'splitTipoMedida'					splitTipoMedida,
				B.TN_CodTipoMedida					Codigo, 
				B.TC_Descripcion					Descripcion,
				'splitEstadoMedida'					splitEstadoMedida,
				C.TN_CodEstado						Codigo, 
				C.TC_Descripcion					Descripcion,
				'splitInterviniente'				splitInterviniente,
				D.TU_CodInterviniente				CodigoInterviniente,
				'splitContexto'						splitContexto,
				E.TC_CodContexto					Codigo,
				E.TC_Descripcion					Descripcion,
				'splitPlazoMedida'					splitPlazoMedida,
				F.TU_CodPlazo						Codigo,
				F.TF_FechaInicio					FechaInicio,
				F.TF_FechaFin						FechaFin

	FROM		Expediente.IntervinienteMedida		A WITH (NOLOCK)
	INNER JOIN	Catalogo.TipoMedida					B WITH (NOLOCK)
	ON			B.TN_CodTipoMedida					= A.TN_CodTipoMedida
	INNER JOIN	Catalogo.EstadoMedida				C WITH (NOLOCK)
	ON			C.TN_CodEstado						= A.TN_CodEstado
	INNER JOIN	Expediente.Interviniente			D WITH (NOLOCK)
	ON			D.TU_CodInterviniente				= A.TU_CodInterviniente
	INNER JOIN  Catalogo.Contexto					E WITH (NOLOCK)
	ON			E.TC_CodContexto					= A.TC_CodContexto	
	
	--OBTIENE EL MAS RECIENTE REGISTRO DE PLAZO DE LA MEDIDA
	OUTER APPLY (
					SELECT	TOP(1)	Z.TU_CodPlazo, Z.TF_FechaInicio, Z.TF_FechaFin
					FROM			Expediente.IntervinienteMedidaPlazo Z WITH(NOLOCK)
					WHERE			Z.TU_CodMedida						= A.TU_CodMedida
					ORDER BY		Z.TF_FechaInicio DESC, Z.TF_FechaFin DESC
				) F

	WHERE		A.TU_CodMedida						= COALESCE(@L_TU_CodMedida, A.TU_CodMedida)
	AND			A.TU_CodInterviniente				= COALESCE(@L_TU_CodInterviniente, A.TU_CodInterviniente) 
	AND			A.TN_CodEstado						= COALESCE(@L_TN_CodEstado, A.TN_CodEstado)
	AND			A.TN_CodTipoMedida					= COALESCE(@L_TN_CodTipoMedida, A.TN_CodTipoMedida)
	
	ORDER BY    F.TF_FechaFin DESC
END
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Méndez Ch>
-- Fecha de creación:		<15/10/2020>
-- Descripción :			<Permite Consultar los apremios de un legajo>
-- =================================================================================================================================================================
-- Modificación:			<17/05/2021><Isaac Santiago Méndez Castillo>  <Se agrega en el select principal el "NombreActor">
-- Modificación:			<11/06/2021><Aida Elena Siles R>  <Se agrega Join con Expediente.Intervencion y Expediente.LegajoIntervencion para evitar
--															   la duplicidad de registros cuando una persona existe más de una vez en la BD.>
-- Modificación:			<08/02/2023><Jonathan Aguilar N/Karol Jiménez S> <PBI Incidente 301001 - Se ajusta consulta para obtener nombre del actor, se separa como un outer apply,
--							dado que para registros migrados no siempre se tiene el usuario entrega como parte del expediente, sino pueden ser funcionarios judiciales>

-- =================================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ConsultarApremioLegajo]
 	@CodigoApremio				UNIQUEIDENTIFIER= NULL,
	@CodigoLegajo				UNIQUEIDENTIFIER= NULL,	
	@EstadoApremio				CHAR(1)			= NULL,	
	@CodContexto				VARCHAR(4)		= NULL

AS
BEGIN

--Variables
	DECLARE	@L_CodigoApremio	UNIQUEIDENTIFIER	=	@CodigoApremio,			
			@L_CodigoLegajo		UNIQUEIDENTIFIER	=	@CodigoLegajo,
			@L_EstadoApremio	CHAR(1)				=	@EstadoApremio,
			@L_CodContexto		VARCHAR(4)			=	@CodContexto
			
   
	SELECT		A.TU_CodApremio																AS		Codigo
				,A.TC_CodEntrega															AS      CodigoEntrega	
				,A.TC_Descripcion															AS		Descripcion
				,A.TF_FechaIngresoOficina													AS		FechaIngresoOficina
				,A.TF_FechaEnvio															AS		FechaEnvio
				,A.TF_FechaEstado															AS		FechaEstado
				,A.TC_EstadoApremio															AS		EstadoApremio
				,A.TC_OrigenApremio															AS		OrigenApremio
				,A.TC_UsuarioEntrega														AS		IdentificacionActor
				,
				IIF(OA.TU_CodPersona IS NULL, A.TC_UsuarioEntrega,
					OA.TC_Nombre + ' ' + 
					OA.TC_PrimerApellido + 
					ISNULL(' ' + OA.TC_SegundoApellido,'')
				)																			AS		NombreActor
				,A.TC_TramiteOrdenApremio													AS		TramiteOrdenApremio			    
				,'Split'																	AS		Split
				,L.TU_CodLegajo																AS		Codigo
				,L.TC_Descripcion															AS		Descripcion		 
				,'Split'																	AS		Split			 
				,A.TC_IDARCHIVO																AS		Codigo
				,'Split'																	AS		Split	
				,PT.TC_CodPuestoTrabajo														AS		Codigo
				,PT.TC_Descripcion															AS		Descripcion
				,'Split'																	AS		Split	
				,F.TC_Nombre																AS		Nombre
				,F.TC_PrimerApellido														AS		PrimerApellido
				,F.TC_SegundoApellido														AS		SegundoApellido
	 	
	FROM		Expediente.ApremioLegajo			A	WITH(NOLOCK)
	JOIN		Expediente.Legajo					L	WITH(NOLOCK)
	ON			A.TU_CodLegajo						=	L.TU_CodLegajo	
	JOIN		Catalogo.Contexto					B	WITH(NOLOCK)	
	ON			A.TC_CodContexto					=	B.TC_CodContexto		
	LEFT JOIN	Catalogo.PuestoTrabajo				PT	WITH(NOLOCK)
	ON			A.TC_CodPuestoTrabajo				=	PT.TC_CodPuestoTrabajo	
	LEFT JOIN	Catalogo.PuestoTrabajoFuncionario	PF	WITH(NOLOCK)
	ON			A.TC_CodPuestoTrabajo				=	PF.TC_CodPuestoTrabajo
	AND			(PF.TF_Fin_Vigencia					IS NULL	OR	PF.TF_Fin_Vigencia	>=	GETDATE())
	LEFT JOIN	Catalogo.Funcionario				F	WITH(NOLOCK)
	ON			PF.TC_UsuarioRed					=	F.TC_UsuarioRed
	OUTER APPLY (
			SELECT		TOP 1
						PE.TU_CodPersona, PEF.TC_Nombre, PEF.TC_PrimerApellido, PEF.TC_SegundoApellido
			FROM		Persona.Persona						PE	WITH(NOLOCK)
			INNER JOIN	Persona.PersonaFisica				PEF	WITH(NOLOCK)
			ON			PE.TU_CodPersona					=	PEF.TU_CodPersona
			INNER JOIN	Expediente.Intervencion				I	WITH(NOLOCK)
			ON			PE.TU_CodPersona					=	I.TU_CodPersona
			INNER JOIN	Expediente.LegajoIntervencion		LI	WITH(NOLOCK)
			ON			I.TU_CodInterviniente				=	LI.TU_CodInterviniente
			AND			LI.TU_CodLegajo						=   ISNULL(@L_CodigoLegajo, A.TU_CodLegajo)	
WHERE		PE.TC_Identificacion				=	A.TC_UsuarioEntrega
	) OA
	WHERE		A.TU_CodLegajo						=	ISNULL(@L_CodigoLegajo, A.TU_CodLegajo)		
	AND			A.TU_CodApremio						=	ISNULL(@L_CodigoApremio, A.TU_CodApremio)
	AND			A.TC_EstadoApremio					=	ISNULL(@L_EstadoApremio, A.TC_EstadoApremio)	
	AND			B.TC_CodContexto					=	ISNULL(@L_CodContexto, B.TC_CodContexto)		 	

	ORDER BY	A.TF_FechaEnvio		ASC	

END
GO

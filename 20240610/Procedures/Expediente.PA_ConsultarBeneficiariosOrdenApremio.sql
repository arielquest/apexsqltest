SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Creado por:				<Jose Miguel Avendaño Rosales>
-- Fecha de creación:		<03/09/2021>
-- Descripción :			<Permite Consultar los beneficiarios de una orden de apremio>
-- =================================================================================================================================================
-- Modificacion: <Miguel Avendaño> <25/02/2022> <Se quitan las validaciones entre el interviniente y el legajo, para que la consulta del nombre se haga
--												exclusivamente entre el interviniente y ApremioLegajoBeneficiarios>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarBeneficiariosOrdenApremio]
	@CodigoApremio	uniqueidentifier = NULL
AS
BEGIN
	--Variables
	DECLARE			@L_CodigoApremio				uniqueidentifier				= @CodigoApremio
	
	SELECT			A.TF_Inicio_Vigencia					AS	FechaActivacion,			 
					'SplitPersona'							AS	SplitPersona,
					C.TC_Nombre								AS	Nombre,
					C.TC_PrimerApellido						AS	PrimerApellido,
					C.TC_SegundoApellido					AS	SegundoApellido,			 
					B.TC_Identificacion						AS	Identificacion,
					'SplitIdent'							AS	SplitIdent,
					D.TN_CodTipoIdentificacion				AS	Codigo,
					D.TC_Descripcion						AS	Descripcion,
					D.TC_Formato							AS	Formato
	FROM			Expediente.Intervencion					AS	A WITH(Nolock)
	Inner Join		Persona.Persona							AS	B WITH(Nolock) 
	On				A.TU_CodPersona							=	B.TU_CodPersona
	left outer join	Persona.PersonaFisica					AS	C WITH(Nolock) 
	On				C.TU_CodPersona							=	B.TU_CodPersona
	left outer join	Catalogo.TipoIdentificacion				AS	D WITH(Nolock) 
	On				B.TN_CodTipoIdentificacion				=	D.TN_CodTipoIdentificacion
	Inner Join		Expediente.ApremioLegajoBeneficiarios	As	F With(NoLock)
	On				F.TU_CodInterviniente					=	A.TU_CodInterviniente
	And				F.TU_CodApremio							=	@L_CodigoApremio
	WHERE			(A.TF_Fin_Vigencia						>=  GetDate()
	Or				A.TF_Fin_Vigencia						Is	Null)
END
GO

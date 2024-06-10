SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================================================================================================
-- Versión:					<1.0>
-- Autor:					<Jose Gabriel Cordero Soto>
-- Fecha Creación:			<08/04/2021>
-- Descripcion:				<Consultar representaciones asociadas a una carpeta>
-- =======================================================================================================================================
-- Modificado por:			<Jose Gabriel Cordero><14/04/2021><Se incorpora en la consulta el Codigo De representacion y del archivo>	
-- =======================================================================================================================================
-- Modificado por:			<Jose Gabriel Cordero><15/04/2021><Se incorpora campos referentes a propuestadocumento, puestotrabajo y detalles del archivo>	
-- =======================================================================================================================================
-- Modificado por:			<Jose Gabriel Cordero><18/04/2021><Se incorpora filtro por Codigo Archivo>	
-- =======================================================================================================================================
CREATE PROCEDURE [DefensaPublica].[PA_ConsultarRepresentacionesCarpeta] 
(
	@NRD				VARCHAR(14)		 = NULL,
	@CodRepresentacion  UNIQUEIDENTIFIER = NULL,
	@EstadoPropuesta	CHAR(1)			 = NULL,
	@CodArchivo			UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

DECLARE		@L_CodNRD							VARCHAR(14)				= @NRD,
			@L_Estado							CHAR(1)					= @EstadoPropuesta,
			@L_CodRepresentacion				UNIQUEIDENTIFIER		= @CodRepresentacion,
			@L_CodArchivo						UNIQUEIDENTIFIER		= @CodArchivo

SELECT		C.TU_CodPropuesta					CodigoPropuesta,
			C.TF_FechaPropuesta					FechaPropuesta,			
			'splitPersonaFisica'				splitPersonaFisica,			
			E.TC_Nombre							Nombre,
			E.TC_PrimerApellido					PrimerApellido,
			E.TC_SegundoApellido				SegundoApellido,
			'splitTipoIdentificacion'			splitTipoIdentificacion,
			F.TN_CodTipoIdentificacion			Codigo,
			F.TC_Descripcion					Descripcion,
			'splitArchivo'						splitArchivo,			
			G.TU_CodArchivo						Codigo,
			G.TC_Descripcion					Descripcion,
			'splitRepresentacion'				splitRepresentacion,			
			B.TU_CodRepresentacion				CodRepresentacion,
			'splitPuestoTrabajo'				splitPuestoTrabajo,
			H.TC_CodPuestoTrabajo				Codigo,
			'splitOtros'						splitOtros,
			C.TC_EstadoPropuesta				EstadoPropuesta,
			G.TN_CodEstado						EstadoArchivo

FROM		DefensaPublica.Carpeta				A WITH(NOLOCK)	
INNER JOIN	DefensaPublica.Representacion		B WITH(NOLOCK)
ON			A.TC_NRD							= B.TC_NRD
INNER JOIN	DefensaPublica.PropuestaDocumento	C WITH(NOLOCK)	
ON			C.TU_CodRepresentacion				= B.TU_CodRepresentacion
INNER JOIN  Persona.Persona						D WITH(NOLOCK)
ON			B.TU_CodPersona						= D.TU_CodPersona
INNER JOIN	Persona.PersonaFisica				E WITH(NOLOCK)
ON			D.TU_CodPersona						= E.TU_CodPersona
INNER JOIN  Catalogo.TipoIdentificacion			F WITH(NOLOCK)
ON			D.TN_CodTipoIdentificacion			= F.TN_CodTipoIdentificacion
INNER JOIN	Archivo.Archivo						G WITH(NOLOCK)
ON			G.TU_CodArchivo						= C.TU_CodArchivo
INNER JOIN	Catalogo.PuestoTrabajo				H WITH(NOLOCK)
ON			H.TC_CodPuestoTrabajo				= C.TC_CodPuestoTrabajo

WHERE		A.TC_NRD							= COALESCE(@L_CodNRD, A.TC_NRD)
AND			C.TU_CodRepresentacion				= COALESCE(@L_CodRepresentacion, C.TU_CodRepresentacion)
AND			C.TC_EstadoPropuesta				= COALESCE(@L_Estado, C.TC_EstadoPropuesta)
AND			C.TU_CodArchivo						= COALESCE(@L_CodArchivo, C.TU_CodArchivo)

END
GO

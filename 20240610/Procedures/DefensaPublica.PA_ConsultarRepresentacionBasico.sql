SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<21/05/2019>
-- Descripción :			<Permite consultar las representaciones de una carpeta
-- =================================================================================================================================================
-- Modificación:			<Aida E. Siles> <27/08/2019> <Se agrega el formato> 
-- Modificación:			<Aida E. Siles> <05/03/2021> <Se agrega el origen> 
-- =================================================================================================================================================
CREATE PROCEDURE [DefensaPublica].[PA_ConsultarRepresentacionBasico]
@NRD VARCHAR(14)
   AS
BEGIN
--VARIABLES
DECLARE		@L_NRD			VARCHAR(14)		=	@NRD

 SELECT             R.TF_Creacion					AS	FechaCreacion,
					R.TF_Actualizacion				AS	FechaModificación,
		            'Split'							AS	Split,
					R.TU_CodRepresentacion			AS	CodigoRepresentacion,
					P.TC_Origen						AS	Origen,
					'Split'							AS	Split,
					F.TU_CodPersona					AS  CodigoPersona,
					F.TC_Nombre						AS	Nombre,
					F.TC_PrimerApellido				AS	PrimerApellido,
					F.TC_SegundoApellido			AS	SegundoApellido,
					F.TC_LugarNacimiento			AS  LugarNacimiento,
					F.TF_FechaNacimiento			AS  FechaNacimiento,			 
					P.TC_Identificacion				AS	Identificacion,
					F.TB_EsIgnorado					AS	EsIgnorado,	
					F.TF_FechaDefuncion				AS	FechaDefuncion,	
					F.TC_LugarDefuncion				AS	LugarDefuncion,	
					F.TC_NombreMadre				AS	NombreMadre,		
					F.TC_NombrePadre				AS	NombrePadre,					
					'Split'							AS  Split,
					T.TN_CodTipoIdentificacion		AS	Codigo,
					T.TC_Descripcion				AS	Descripcion,
					T.TC_Formato					AS	Formato
 FROM				DefensaPublica.Representacion	AS	R WITH (NoLock)
 INNER JOIN			DefensaPublica.Carpeta			AS	C WITH (NoLock)
 ON					C.TC_NRD						=	R.TC_NRD
 INNER JOIN			Persona.Persona					AS	P WITH (Nolock) 
 ON					R.TU_CodPersona					=	P.TU_CodPersona
 LEFT OUTER JOIN	Persona.PersonaFisica			AS	F WITH (Nolock) 
 ON					F.TU_CodPersona 				=	P.TU_CodPersona
 LEFT OUTER JOIN	Catalogo.TipoIdentificacion		AS	T WITH (Nolock) 
 ON					P.TN_CodTipoIdentificacion		=	T.TN_CodTipoIdentificacion
 WHERE				R.TC_NRD						=	@L_NRD 
END
 
GO

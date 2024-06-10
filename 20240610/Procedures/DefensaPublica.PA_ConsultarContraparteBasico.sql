SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<20/05/2019>
-- Descripción :			<Permite consultar las contrapartes de una carpeta
-- =================================================================================================================================================
  
CREATE PROCEDURE [DefensaPublica].[PA_ConsultarContraparteBasico]
@NRD VARCHAR(14)
AS
BEGIN
	--VARIABLES
	DECLARE @L_NRD		VARCHAR(14)			=	@NRD

	 SELECT	            A.TF_Creacion				AS	Creacion,					
						A.TU_CodContraparte			AS	CodContraparte,
						'Split'						AS	Split,
						F.TU_CodPersona				AS  CodigoPersona,
						F.TC_Nombre					AS	Nombre,
						F.TC_PrimerApellido			AS	PrimerApellido,
						F.TC_SegundoApellido		AS	SegundoApellido,
						F.TC_LugarNacimiento		AS  LugarNacimiento,
						F.TF_FechaNacimiento		AS  FechaNacimiento,			 
						P.TC_Identificacion			AS	Identificacion,
						F.TB_EsIgnorado				AS	EsIgnorado,	
						F.TF_FechaDefuncion			AS	FechaDefuncion,	
						F.TC_LugarDefuncion			AS	LugarDefuncion,	
						F.TC_NombreMadre			AS	NombreMadre,		
						F.TC_NombrePadre			AS	NombrePadre,
						'Split'						AS  Split,
						D.TU_CodPersona				AS	CodigoPersona,
						D.TC_Nombre					AS	Nombre,
						D.TC_NombreComercial		AS	NombreComercial,
						P.TC_Identificacion			AS	Identificacion,
						'Split'						AS  Split,					
						T.TN_CodTipoIdentificacion	AS	Codigo,
						T.TC_Descripcion			AS	Descripcion,
						T.TC_Formato				AS	Formato,
						'Split'						AS  Split,
						I.TN_CodTipoEntidad			AS	Codigo,
						I.TC_Descripcion			AS	Descripcion,
						'Split'						AS  Split,
						P.TC_Origen					AS  Origen
	 FROM				DefensaPublica.Contraparte	AS	A WITH (NoLock)
	 INNER JOIN			DefensaPublica.Carpeta		AS	C WITH (NoLock)
	 ON					C.TC_NRD					=	A.TC_NRD
	 INNER JOIN			Persona.Persona				AS	P WITH (Nolock) 
	 ON					A.TU_CodPersona				=	P.TU_CodPersona
	 LEFT OUTER JOIN	Persona.PersonaFisica		AS	F WITH (Nolock) 
	 ON					F.TU_CodPersona 			=	P.TU_CodPersona
	 LEFT OUTER JOIN	Persona.PersonaJuridica		AS	D WITH (Nolock) 
	 ON					D.TU_CodPersona				=	P.TU_CodPersona
	 LEFT OUTER JOIN	Catalogo.TipoIdentificacion AS	T WITH (Nolock) 
	 ON					P.TN_CodTipoIdentificacion  =	T.TN_CodTipoIdentificacion
	 LEFT OUTER JOIN	Catalogo.TipoEntidadJuridica	AS I WITH (NoLock)
	 ON					D.TN_CodTipoEntidad			=	I.TN_CodTipoEntidad
	 WHERE				A.TC_NRD					=	@L_NRD 
END
GO

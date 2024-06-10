SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<27/06/2019>
-- Descripción :			<Permite consultar una representación>
-- =================================================================================================================================================
-- Modificación:			<Aida E Siles>	<28/10/2019>	<Se agrega a la consulta el ultimo movimiento circulante de la representación>

CREATE PROCEDURE [DefensaPublica].[PA_ConsultarRepresentacion]
	@CodRepresentacion		uniqueidentifier = null,
	@NRD					varchar(14) = null,
	@CodPersona				uniqueidentifier = null
As
Begin
Select				A.TC_Alias											As  Alias,
					A.TC_LugarTrabajo									As  LugarTrabajo,
					A.TC_Descripcion									As	Descripcion,
					'Split'												As	Split,				
					A.TU_CodRepresentacion								As	CodigoRepresentacion,
					A.TU_CodPersona										As	CodigoPersona,
					A.TC_CodPais										As	CodigoPais,
					G.TC_Descripcion									As	PaisDescrip,
					A.TN_CodProfesion									As	CodigoProfesion,
					H.TC_Descripcion									As	ProfesionDescrip,
					A.TN_CodEscolaridad									As	CodigoEscolaridad,			
					I.TC_Descripcion									As	EscolaridadDescrip,
					A.TN_CodSituacionLaboral							As	CodigoSituacionLaboral,		
					J.TC_Descripcion									As	SituacionLaboralDescrip,
					A.TN_CodEstadoCivil									As	CodigoEstadoCivil,			
					K.TC_Descripcion									As	EstadoCivilDescrip,
					A.TC_CodSexo										As	CodigoSexo,					
					L.TC_Descripcion									As	SexoDescrip,
					A.TF_Creacion										As	FechaCreacion,
					E.TN_CodEtnia										As	CodigoEtnia,
					M.TC_Descripcion									As	EtniaDescrip,
					D.TC_Origen											As	Origen,
					R.TN_CodEstadoRepresentacion						As	CodEstadoRepresentacion,
				    R.TC_CodContexto									As	CodContextoCirculante,					
					O.TN_CodEstadoRepresentacion						As	CodEstadoRepresentacion,
					O.TC_Descripcion									As	EstadoRepresentacionDescrip,
					R.TC_Movimiento										As	Movimiento,
					O.TC_Circulante										As	Circulante, 
					O.TC_Pasivo											As  CirculantePasivo,				
					'Split'												As	Split,
					A.TU_CodPersona										As	CodigoPersona,					
					D.TC_Identificacion									As	Identificacion,
					E.TC_Nombre											As	Nombre,
					E.TC_PrimerApellido									As	PrimerApellido,
					E.TC_SegundoApellido								As	SegundoApellido,
					E.TF_FechaNacimiento								As	FechaNacimiento,
					E.TC_LugarNacimiento								As	LugarNacimiento,					
					E.TF_FechaDefuncion									As	FechaDefuncion,
					E.TC_LugarDefuncion									As	LugarDefuncion,
					E.TC_NombreMadre									As	NombreMadre,
					E.TC_NombrePadre									As	NombrePadre,
					'Split'												As	Split,
					D.TN_CodTipoIdentificacion							As	Codigo,
					F.TC_Descripcion									As	Descripcion,
					F.TC_Formato										As	Formato,
					F.TB_Nacional										As	Nacional,
					'Split'												As	Split,
					R.TU_CodMovimiento									As  CodMovimiento, 
					R.TF_Movimiento										As	FechaMovimiento					
	From			DefensaPublica.Representacion						As	A With(NoLock)	
	Inner Join		Persona.Persona										As	D With(NoLock)
	On				A.TU_CodPersona										=	D.TU_CodPersona
	Inner Join		Persona.PersonaFisica								As	E With(NoLock)
	On				E.TU_CodPersona										=	D.TU_CodPersona
	Inner Join		Catalogo.TipoIdentificacion							As	F With(NoLock)
	On				D.TN_CodTipoIdentificacion							=	F.TN_CodTipoIdentificacion
	Inner Join		DefensaPublica.RepresentacionMovimientoCirculante	As	R With(NoLock)
	On				A.TU_CodRepresentacion								=	R.TU_CodRepresentacion
	Inner Join		Catalogo.EstadoRepresentacion						As	O With(NoLock)
	On				R.TN_CodEstadoRepresentacion						=	O.TN_CodEstadoRepresentacion
	And				R.TF_Movimiento										=	(Select max(TF_Movimiento)
																			From DefensaPublica.RepresentacionMovimientoCirculante
																			Where TU_CodRepresentacion = @CodRepresentacion)
	Left Join		Catalogo.Pais										As	G With(NoLock)
	On				A.TC_CodPais										=	G.TC_CodPais
	Left Join		Catalogo.Profesion									As	H With(NoLock)
	On				A.TN_CodProfesion									=	H.TN_CodProfesion
	Left Join		Catalogo.Escolaridad								As	I With(NoLock)
	On				A.TN_CodEscolaridad									=	I.TN_CodEscolaridad
	Left Join		Catalogo.SituacionLaboral							As	J With(NoLock)
	On				A.TN_CodSituacionLaboral							=	J.TN_CodSituacionLaboral
	Left Join		Catalogo.EstadoCivil								As	K With(NoLock)
	On				A.TN_CodEstadoCivil									=	K.TN_CodEstadoCivil
	Left Join		Catalogo.Sexo										As	L With(NoLock)
	On				A.TC_CodSexo										=	L.TC_CodSexo
	Left Join		Catalogo.Etnia										As	M With(NoLock)
	On				E.TN_CodEtnia										=	M.TN_CodEtnia
	Where			A.TU_CodRepresentacion								=	ISNULL(@CodRepresentacion, A.TU_CodRepresentacion)
	And				(A.TC_NRD											=	ISNULL(@NRD, A.TC_NRD))
	And				(A.TU_CodPersona									=	Case	When @CodPersona is not null And @CodRepresentacion is null
																					Then @CodPersona
																					Else A.TU_CodPersona
																			End)	
	And				((@CodRepresentacion is not null) Or (@NRD is not null) Or (@CodPersona is not null))
End
GO

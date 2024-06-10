SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Tatiana Flores>
-- Fecha de creación:		<16/11/2016>
-- Descripción:				<consulta los intervinientes del evento> 
-- Se agrega:               <Se agrega el nombre del Esquema de la Tabla>
-- Modificación:			<09/10/2018><Juan Ramírez><Se enlaza con la tabla intervención> 
-- ===========================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarIntervinientesEvento] 
@CodigoEvento Uniqueidentifier
As
Begin
	SELECT			Z.TF_Inicio_Vigencia		As FechaActivacion,		  
					Z.TF_Fin_Vigencia			As FechaDesactivacion, 
					Z.TF_Actualizacion			As FechaModificacion,		      																
					'SplitTI' As SplitTI,
					A.TU_CodInterviniente		As CodigoInterviniente,		  
					A.TF_ComisionDelito			As FechaComisionDelito, 
					A.TC_Caracteristicas		As Caracteristicas,		      
					A.TC_Alias					As Alias, 
					A.TB_Droga					As Droga, (Select count(*) From Expediente.MedidaPena  As E	WITH(Nolock)
																			   Where E.TU_CodInterviniente = A.TU_CodInterviniente) As TieneMedidaPena,
					A.TB_Rebeldia				As Rebeldia,																	
					'SplitTIn' As SplitTIn,
					A.TN_CodTipoIntervencion		As	Codigo,
					B.TC_Descripcion				As	Descripcion,				 'SplitPF' As SplitPF,
					C.TU_CodPersona					As	CodigoPersona,
					C.TC_Nombre						As	Nombre,
					C.TC_PrimerApellido				As	PrimerApellido,
					C.TC_SegundoApellido			As	SegundoApellido,
					C.TF_FechaNacimiento			As  FechaNacimiento,			 
					P.TC_Identificacion				As	Identificacion,
					C.TB_EsIgnorado					As	EsIgnorado,	
					'SplitPJ' As SplitPJ,
					D.TU_CodPersona					As	CodigoPersona,
					D.TC_Nombre						As	Nombre,
					P.TC_Identificacion				As	Identificacion,			
					'SplitIdent' As SplitIdent,
					T.TN_CodTipoIdentificacion		As	Codigo,
					T.TC_Descripcion				As	Descripcion,
					'SplitOtros' as SplitOtros,
					B.TC_Intervencion 				as Intervencion,
					Z.TC_TipoParticipacion			As TipoParticipacion,
					Z.TC_NumeroExpediente			As Numero	
	From			[Agenda].[IntervinienteEvento]  AS  X WITH (NoLock)
	Inner Join		Expediente.Interviniente		As	A WITH (Nolock)
	On				X.TU_CodInterviniente			=	A.TU_CodInterviniente
	Inner Join		Expediente.Intervencion			As	Z WITH (NoLock)
	On				Z.TU_CodInterviniente			=	A.TU_CodInterviniente
	Inner Join		Catalogo.TipoIntervencion		As	B WITH (Nolock) 
	On				B.TN_CodTipoIntervencion		=	A.TN_CodTipoIntervencion
	Inner Join		Persona.Persona					As	P WITH (Nolock) 
	On				Z.TU_CodPersona					=	P.TU_CodPersona
	left outer join	Persona.PersonaFisica			As	C WITH (Nolock) 
	On				C.TU_CodPersona					=	P.TU_CodPersona
	left outer join	Persona.PersonaJuridica			As	D WITH (Nolock) 
	On				D.TU_CodPersona					=	P.TU_CodPersona
	left outer join	Catalogo.TipoIdentificacion		As	T WITH (Nolock) 
	On				P.TN_CodTipoIdentificacion		=	T.TN_CodTipoIdentificacion		    		
	Where	        TU_CodEvento = @CodigoEvento
	
End

GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jefry Hernández>
-- Fecha de creación:		<09/05/2017>
-- Descripción :			<Permite consultar los intervinientes asociados a una solicitud de defensor>  
-- =================================================================================================================================================
-- Modificado:				<17/11/2017> <Ailyn López> <Se modifica el nombre del procedimiento>
-- Modificado:				<01/11/2019> <Isaac Dobles Mata> <Se ajusta a estructura de intervenciones>
-- =================================================================================================================================================
 
CREATE PROCEDURE [Expediente].[PA_ConsultarSolicitudDefensorInterviniente] 
     @CodSolicitudDefensor uniqueidentifier null

As  
	Begin

		Select			
			SDI.TB_Declaro					As  Declaro,				SDI.TB_Sustitucion			As	Sustitucion ,
			SDI.TC_Observaciones			As  Observaciones,			SDI.TU_CodSolicitudDefensor	As	CodSolicitudDefensor,
			'SplitInterviniente'			As	SplitInterviniente,     A.TU_CodInterviniente		As  CodigoInterviniente,
			'SplitTipoIntervencion'			As	SplitTipoIntervencion,	TI.TN_CodTipoIntervencion	As	Codigo,
			TI.TC_Descripcion				As	Descripcion,			'SplitPF'				    As	SplitPF,
			C.TU_CodPersona					As	CodigoPersona,		    C.TC_Nombre					As	Nombre,
			C.TC_PrimerApellido				As	PrimerApellido,		    C.TC_SegundoApellido		As	SegundoApellido		 			    		 
	
		From			Expediente.Interviniente					As	A							WITH (Nolock)
		Inner Join		Expediente.Intervencion						As	I							WITH (Nolock)
		On				I.TU_CodInterviniente						=   A.TU_CodInterviniente
		Inner Join		Expediente.SolicitudDefensorInterviniente	As	SDI							WITH (Nolock) 
		On				SDI.TU_CodInterviniente						=	A.TU_CodInterviniente		
		Inner Join      Catalogo.TipoIntervencion					As  TI							WITH (Nolock) 
		On				TI.TN_CodTipoIntervencion					=   A.TN_CodTipoIntervencion	
		Inner join	    Persona.PersonaFisica						As	C							WITH (Nolock) 
		On				C.TU_CodPersona								=	I.TU_CodPersona
		
		Where			SDI.TU_CodSolicitudDefensor					=	@CodSolicitudDefensor

End

  



GO

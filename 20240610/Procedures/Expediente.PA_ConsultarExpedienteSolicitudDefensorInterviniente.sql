SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jefry Hernández>
-- Fecha de creación:		<12/05/2017>
-- Descripción :			<Permite consultar los intervinientes asociados a un expediente 
--							y con permiso de solicitar una solicitud de defensor>
-- ================================================================================================================================================= 
-- Modificación:			<04/08/2017> <Ailyn López> <Se agregaron corchetes>
-- Modificación:			<01/11/2019> <Isaac Dobles Mata> <Se ajusta para estructura de expediente y legajos>		
-- =================================================================================================================================================
 
CREATE PROCEDURE [Expediente].[PA_ConsultarExpedienteSolicitudDefensorInterviniente]
     @NumeroExpediente			char(14),
	 @CodMateria				Varchar(5),
	 @CodSolicitudDefensor		Uniqueidentifier  = null --Toma valor cuando se está editando una solicitud 	  

As  
	Begin

	;With
	IntervinientesConSolicitud
	As
	(
	--Se extraen los intervinientes asociados al expediente y a solicitudes de defensor	
	Select Distinct I.[TU_CodInterviniente]  
	From 			[Expediente].[Intervencion] I
	Inner Join 		[Expediente].[SolicitudDefensorInterviniente]   As	SDI
	On				I.[TU_CodInterviniente]							=	SDI.[TU_CodInterviniente]
	Where			I.[TC_NumeroExpediente]								=	@NumeroExpediente
	And				SDI.[TU_CodSolicitudDefensor]					<>  Coalesce(@CodSolicitudDefensor, NewId()) --Se excluyen los intervinientes de la solicitud que se está editando
	)

		Select
			
			A.[TU_CodInterviniente]			As  CodigoInterviniente,	A.[TF_ComisionDelito]			As  FechaComisionDelito, 
			A.[TC_Caracteristicas]			As  Caracteristicas,		A.[TC_Alias]					As  Alias, 
		    Case
				When ICS.[TU_CodInterviniente] Is Null Then	0
				Else										1
			End 
			As AsociadoASolicitudDefensor,
			'SplitTipoIntervencion'			As	SplitTipoIntervencion,	TI.[TC_Descripcion]				As  Descripcion, 
			TI.[TN_CodTipoIntervencion]     As  Codigo,					TI.[TF_Fin_Vigencia]			As  FechaDesactivacion,		
			TI.[TF_Inicio_Vigencia]			As  FechaActivacion,        A.[TB_Droga]					As  Droga,				    
			'SplitPF'						As  SplitPF,				C.[TU_CodPersona]				As	CodigoPersona,		    
			C.[TC_Nombre]					As	Nombre,					C.[TC_PrimerApellido]			As	PrimerApellido,		    
			C.[TC_SegundoApellido]			As	SegundoApellido,		P.[TC_Identificacion]			As	Identificacion,		    
			'SplitIdent'					As  SplitIdent,				T.[TN_CodTipoIdentificacion]	As	Codigo,				    
			T.[TC_Descripcion]				As	Descripcion				 
	
		From			[Expediente].[Interviniente]			As	A WITH (Nolock)
		Inner Join		[Expediente].[Intervencion]				As	I WITH (Nolock)
		On				I.TU_CodInterviniente					=	A.TU_CodInterviniente
		Inner Join		[Catalogo].[MateriaTipoIntervencion]	As	B WITH (Nolock) 
		On				A.[TN_CodTipoIntervencion]				=	B.[TN_CodTipoIntervencion]
		Inner Join      [Catalogo].[TipoIntervencion]			As	TI WITH (Nolock)
		On				TI.[TN_CodTipoIntervencion]				=	B.[TN_CodTipoIntervencion]
		Inner Join		[Persona].[Persona]						As	P WITH (Nolock) 
		On				I.[TU_CodPersona]						=	P.[TU_CodPersona]
		Inner join		[Persona].[PersonaFisica]				As	C WITH (Nolock) 
		On				C.[TU_CodPersona]						=	P.[TU_CodPersona]
		Inner join		[Catalogo].[TipoIdentificacion]			As	T WITH (Nolock) 
		On				P.[TN_CodTipoIdentificacion]			=	T.[TN_CodTipoIdentificacion]
		Left Join       IntervinientesConSolicitud				As	ICS
		On				ICS.[TU_CodInterviniente]				=	A.[TU_CodInterviniente]
		

		Where			I.[TC_NumeroExpediente]					=	@NumeroExpediente
		And             B.[TB_PuedeSolicitarDefensor]			=   1
		And				B.[TC_CodMateria]						=   @CodMateria

 End

  



GO

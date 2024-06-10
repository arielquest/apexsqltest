SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:			<Gerardo Lopez R>
-- Fecha Creación:	<08/06/2016>
-- Descripcion:		<Consultar resultados de resolucion de intervinientes por resolucion>
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 05/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ConsultarIntervinienteResultadoResolucion] 
          @CodigoLegajo uniqueidentifier , 
		  @CodigoResolucion uniqueidentifier =null,
		  @CodigoInterviniente     uniqueidentifier =null       
AS
BEGIN

 	    
		SELECT	 R.TU_CodResultadoResolucionInterviniente as CodigoResultadoResolucion,  'SplitRR' as SplitRR,
	            RR.TN_CodResultadoResolucion as Codigo, RR.TC_Descripcion AS Descripcion,'SplitII' As SplitII,		
		        A.TU_CodInterviniente		    As CodigoInterviniente,'SplitTI' As SplitTI,
				A.TN_CodTipoIntervencion		As	Codigo,
				B.TC_Descripcion				As	Descripcion,   'SplitPF' As SplitPF,
				C.TU_CodPersona					As	CodigoPersona,
				C.TC_Nombre						As	Nombre,
				C.TC_PrimerApellido				As	PrimerApellido,
				C.TC_SegundoApellido			As	SegundoApellido,'SplitPJ' As SplitPJ,
				D.TU_CodPersona					As	CodigoPersona,
				D.TC_Nombre						As	Nombre, 
				P.TC_Identificacion				As	Identificacion, 'SplitOtros' As SplitOtros,				
		        R. TU_CodResolucion             as CodigoResolucion,
			    E.TC_NumeroResolucion           AS NumeroResolucion,
				P.TC_CodTipoPersona             as TipoPersona,
				T.TN_CodTipoIdentificacion		As	TipoIdentificacion,
				T.TC_Descripcion				As	DescripcionTipoIdentificacion,  
				B.TC_Intervencion               as Intervencion
		 From               Expediente.ResultadoResolucionInterviniente R With(NoLock) 
		    INNER JOIN      Expediente.Resolucion           As E  With(NoLock) on R.TU_CodResolucion=E.TU_CodResolucion
	        INNER JOIN      Catalogo.ResultadoResolucion    As RR With(NoLock) on R.TN_CodResultadoResolucion  = RR.TN_CodResultadoResolucion 
			INNER JOIN      Expediente.Interviniente  	    As  A WITH (Nolock) on R.TU_CodInterviniente = A.TU_CodInterviniente
			Inner Join		Catalogo.TipoIntervencion		As	B WITH (Nolock)  On	 B.TN_CodTipoIntervencion =	A.TN_CodTipoIntervencion
			Inner Join		Persona.Persona					As	P WITH (Nolock)  On	 A.TU_CodPersona  =	P.TU_CodPersona
			left outer join	Persona.PersonaFisica			As	C WITH (Nolock)  On	 C.TU_CodPersona  =	P.TU_CodPersona
			left outer join	Persona.PersonaJuridica			As	D WITH (Nolock)  On	 D.TU_CodPersona  =	P.TU_CodPersona
			left outer join	Catalogo.TipoIdentificacion		As	T WITH (Nolock)  On	 P.TN_CodTipoIdentificacion	=	T.TN_CodTipoIdentificacion
		  Where      E.TU_CodLegajo = @CodigoLegajo
		    and E.TC_NumeroResolucion is not null
			-- and E.TC_CodEstadoResolucion  in (Select TC_CodEstadoResolucion from Catalogo.EstadoResolucion Where TB_Finalizado =1)
		  and  R.TU_CodResolucion  =  isnull(@CodigoResolucion ,R.TU_CodResolucion ) 
		  and R.TU_CodInterviniente = isnull(@CodigoInterviniente,R.TU_CodInterviniente)
		  
		  order by  C.TC_Nombre	 ,D.TC_Nombre				


	
END


GO

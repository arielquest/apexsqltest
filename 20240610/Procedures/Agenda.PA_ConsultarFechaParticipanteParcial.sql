SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Tatiana Flores>
-- Fecha de creación:		<20/12/2016>
-- Descripción:				<Obtiene fecha de participantes parciales por codigo participacion y evento> 
-- ===========================================================================================

CREATE PROCEDURE [Agenda].[PA_ConsultarFechaParticipanteParcial] 

     @CodigoParticipacion Uniqueidentifier,
     @CodigoEvento        Uniqueidentifier   
As
Begin
	Select		FPP.TU_CodParticipacion           		As CodigoParticipacion,
				FPP.TF_FechaInicioParticipacion	  		As FechaInicio, 
				FPP.TF_FechaFinParticipacion	  		As FechaFin
                  
	From		[Agenda].[FechaParticipanteParcial]	As	FPP  With(Nolock)
	Inner Join	[Agenda].[FechaEvento]              As  FA  With(Nolock)
	On			FA.TU_CodFechaEvento                =	FPP.TU_CodFechaEvento							
	Where		FA.TU_CodEvento                      =	@CodigoEvento 
	And			FPP.TU_CodParticipaciOn				=	@CodigoParticipacion
	
End
GO
